<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\CashierSession;
use App\Models\CashierSessionEntry;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class CashierSessionController extends Controller
{
    public function active(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|integer|exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $session = CashierSession::with('entries')
            ->where('user_id', $request->integer('user_id'))
            ->where('status', 'open')
            ->latest('opened_at')
            ->first();

        return response()->json([
            'status' => 'success',
            'data' => $session,
        ]);
    }

    public function open(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'user_id' => 'required|integer|exists:users,id',
            'opening_balance' => 'required|numeric|min:0',
            'business_date' => 'nullable|date',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $userId = $request->integer('user_id');
        $existingOpen = CashierSession::where('user_id', $userId)->where('status', 'open')->exists();
        if ($existingOpen) {
            return response()->json([
                'status' => 'error',
                'message' => 'Masih ada sesi kasir yang aktif. Tutup sesi aktif terlebih dahulu.',
            ], 409);
        }

        $businessDate = $request->filled('business_date')
            ? Carbon::parse($request->input('business_date'))->toDateString()
            : Carbon::today()->toDateString();

        $now = Carbon::now();
        $sessionCode = sprintf('CS-%d-%s', $userId, $now->format('YmdHis'));

        $session = CashierSession::create([
            'user_id' => $userId,
            'session_code' => $sessionCode,
            'business_date' => $businessDate,
            'opened_at' => $now,
            'status' => 'open',
            'opening_balance' => $request->input('opening_balance'),
            'total_cash_in' => 0,
            'total_cash_out' => 0,
            'subtotal' => $request->input('opening_balance'),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Sesi kasir dibuka',
            'data' => $session->fresh(),
        ], 201);
    }

    public function addEntry(Request $request, int $sessionId)
    {
        $session = CashierSession::where('id', $sessionId)->where('status', 'open')->first();
        if (!$session) {
            return response()->json([
                'status' => 'error',
                'message' => 'Sesi kasir tidak ditemukan atau sudah ditutup',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'entry_type' => 'required|in:in,out',
            'title' => 'required|string|max:255',
            'amount' => 'required|numeric|min:0.01',
            'notes' => 'nullable|string',
            'happened_at' => 'nullable|date',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $entry = DB::transaction(function () use ($request, $session) {
            $entry = CashierSessionEntry::create([
                'cashier_session_id' => $session->id,
                'entry_type' => $request->input('entry_type'),
                'title' => $request->input('title'),
                'amount' => $request->input('amount'),
                'notes' => $request->input('notes'),
                'happened_at' => $request->filled('happened_at')
                    ? Carbon::parse($request->input('happened_at'))
                    : Carbon::now(),
            ]);

            $this->recalculateSessionTotals($session->id);
            return $entry;
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Entry kas berhasil ditambahkan',
            'data' => $entry->fresh(),
        ], 201);
    }

    public function updateEntry(Request $request, int $sessionId, int $entryId)
    {
        $session = CashierSession::where('id', $sessionId)->where('status', 'open')->first();
        if (!$session) {
            return response()->json([
                'status' => 'error',
                'message' => 'Sesi kasir tidak ditemukan atau sudah ditutup',
            ], 404);
        }

        $entry = CashierSessionEntry::where('cashier_session_id', $sessionId)->find($entryId);
        if (!$entry) {
            return response()->json([
                'status' => 'error',
                'message' => 'Entry kas tidak ditemukan',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'entry_type' => 'sometimes|required|in:in,out',
            'title' => 'sometimes|required|string|max:255',
            'amount' => 'sometimes|required|numeric|min:0.01',
            'notes' => 'nullable|string',
            'happened_at' => 'nullable|date',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        DB::transaction(function () use ($request, $entry, $sessionId) {
            $entry->update($request->only([
                'entry_type',
                'title',
                'amount',
                'notes',
                'happened_at',
            ]));
            $this->recalculateSessionTotals($sessionId);
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Entry kas berhasil diperbarui',
            'data' => $entry->fresh(),
        ]);
    }

    public function deleteEntry(int $sessionId, int $entryId)
    {
        $session = CashierSession::where('id', $sessionId)->where('status', 'open')->first();
        if (!$session) {
            return response()->json([
                'status' => 'error',
                'message' => 'Sesi kasir tidak ditemukan atau sudah ditutup',
            ], 404);
        }

        $entry = CashierSessionEntry::where('cashier_session_id', $sessionId)->find($entryId);
        if (!$entry) {
            return response()->json([
                'status' => 'error',
                'message' => 'Entry kas tidak ditemukan',
            ], 404);
        }

        DB::transaction(function () use ($entry, $sessionId) {
            $entry->delete();
            $this->recalculateSessionTotals($sessionId);
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Entry kas berhasil dihapus',
        ]);
    }

    public function close(Request $request, int $sessionId)
    {
        $session = CashierSession::where('id', $sessionId)->where('status', 'open')->first();
        if (!$session) {
            return response()->json([
                'status' => 'error',
                'message' => 'Sesi kasir tidak ditemukan atau sudah ditutup',
            ], 404);
        }

        $session = DB::transaction(function () use ($session) {
            $reloaded = $this->recalculateSessionTotals($session->id);
            $reloaded->update([
                'status' => 'closed',
                'closed_at' => Carbon::now(),
            ]);

            $reloaded->update([
                'subtotal' => (
                    (float) $reloaded->opening_balance
                    + (float) $reloaded->total_cash_in
                    - (float) $reloaded->total_cash_out
                ),
            ]);

            return $reloaded->fresh(['entries']);
        });

        return response()->json([
            'status' => 'success',
            'message' => 'Sesi kasir ditutup',
            'data' => $session,
        ]);
    }

    private function recalculateSessionTotals(int $sessionId): CashierSession
    {
        $session = CashierSession::findOrFail($sessionId);
        $totals = CashierSessionEntry::selectRaw(
            "COALESCE(SUM(CASE WHEN entry_type = 'in' THEN amount ELSE 0 END), 0) AS cash_in, " .
            "COALESCE(SUM(CASE WHEN entry_type = 'out' THEN amount ELSE 0 END), 0) AS cash_out"
        )
            ->where('cashier_session_id', $sessionId)
            ->first();

        $cashIn = (float) ($totals->cash_in ?? 0);
        $cashOut = (float) ($totals->cash_out ?? 0);

        $session->update([
            'total_cash_in' => $cashIn,
            'total_cash_out' => $cashOut,
            'subtotal' => (
                (float) $session->opening_balance
                + $cashIn
                - $cashOut
            ),
        ]);

        return $session->fresh(['entries']);
    }
}
