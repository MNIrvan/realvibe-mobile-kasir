<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pesanan;
use App\Models\DetailPesanan;
use App\Models\Menu;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;

class CheckoutController extends Controller
{
    /**
     * POST /api/checkout
     * Customer mengirim pesanan dari web.
     */
    public function checkout(Request $request)
    {
        $request->validate([
            'nama_pemesan' => 'required|string|max:100',
            'metode_pembayaran' => 'required|in:tunai,qris',
            'catatan' => 'nullable|string|max:500',
            'items' => 'required|array|min:1',
            'items.*.nama' => 'required|string',
            'items.*.harga' => 'required|numeric|min:0',
            'items.*.qty' => 'required|integer|min:1',
        ]);

        $sessionId = $request->session()->getId();

        // Cek apakah sudah punya pesanan aktif (anti-spam: 1 pesanan per sesi)
        $existing = Pesanan::where('session_id', $sessionId)
            ->where('status', 'menunggu_konfirmasi')
            ->where('waktu_batas_bayar', '>', Carbon::now())
            ->first();

        if ($existing) {
            return response()->json([
                'success' => false,
                'message' => 'Anda masih memiliki pesanan aktif. Tunggu pesanan sebelumnya diproses.',
            ], 429);
        }

        // Auto-cleanup: hapus pesanan expired
        Pesanan::where('status', 'menunggu_konfirmasi')
            ->where('waktu_batas_bayar', '<', Carbon::now())
            ->update(['status' => 'batal']);

        Pesanan::where('status', 'batal')
            ->where('updated_at', '<', Carbon::now()->subHours(1))
            ->delete();

        // Generate nomor antrian hari ini
        $todayCount = Pesanan::whereDate('waktu_pesan', Carbon::today())->count() + 1;
        $nomorAntrian = '#RV-' . str_pad($todayCount, 3, '0', STR_PAD_LEFT);

        // Buat pesanan
        $pesanan = Pesanan::create([
            'nomor_antrian' => $nomorAntrian,
            'nama_pemesan' => $request->nama_pemesan,
            'metode_pembayaran' => $request->metode_pembayaran,
            'catatan' => $request->catatan,
            'status' => 'menunggu_konfirmasi',
            'tipe_pesanan' => 'web',
            'waktu_pesan' => Carbon::now(),
            'waktu_batas_bayar' => Carbon::now()->addMinutes(30),
            'session_id' => $sessionId,
        ]);

        $totalBayar = 0;

        foreach ($request->items as $item) {
            // Cari menu_id berdasarkan nama menu
            $menu = Menu::where('nama_menu', $item['nama'])->first();
            $menuId = $menu ? $menu->id : 0;
            $harga = $menu ? intval(floatval($menu->harga)) : intval(floatval($item['harga']));

            DetailPesanan::create([
                'pesanan_id' => $pesanan->id,
                'menu_id' => $menuId,
                'jumlah' => $item['qty'],
                'harga_satuan' => $harga,
            ]);

            $totalBayar += $harga * $item['qty'];
        }

        return response()->json([
            'success' => true,
            'pesanan_id' => $pesanan->id,
            'nomor_antrian' => $nomorAntrian,
            'total_bayar' => $totalBayar,
            'waktu_batas' => $pesanan->waktu_batas_bayar->toIso8601String(),
        ]);
    }

    /**
     * GET /api/checkout/status/{id}
     * Customer polling status pesanannya.
     */
    public function status($id)
    {
        $pesanan = Pesanan::find($id);
        if (!$pesanan) {
            return response()->json(['status' => 'not_found'], 404);
        }

        // Cek apakah sudah expired
        if ($pesanan->status === 'menunggu_konfirmasi' && Carbon::now()->greaterThan($pesanan->waktu_batas_bayar)) {
            $pesanan->update(['status' => 'batal']);
        }

        return response()->json([
            'status' => $pesanan->status,
            'nomor_antrian' => $pesanan->nomor_antrian,
        ]);
    }

    /**
     * GET /api/kasir/pesanan
     * Kasir Flutter mengambil daftar antrean pesanan web.
     */
    public function kasirIndex()
    {
        // Auto-cleanup expired
        Pesanan::where('status', 'menunggu_konfirmasi')
            ->where('waktu_batas_bayar', '<', Carbon::now())
            ->update(['status' => 'batal']);

        $pesanans = Pesanan::where('status', 'menunggu_konfirmasi')
            ->where('tipe_pesanan', 'web')
            ->with('detailPesanan.menu')
            ->orderBy('waktu_pesan', 'asc')
            ->get();

        $result = $pesanans->map(function ($p) {
            $items = $p->detailPesanan->map(function ($d) {
                return [
                    'name' => ($d->jumlah) . 'x ' . ($d->menu ? $d->menu->nama_menu : 'Menu #' . $d->menu_id),
                    'price' => 'Rp ' . number_format($d->harga_satuan * $d->jumlah, 0, ',', '.'),
                ];
            });

            $total = $p->detailPesanan->sum(function ($d) {
                return $d->harga_satuan * $d->jumlah;
            });

            $timeRemaining = max(0, Carbon::now()->diffInSeconds($p->waktu_batas_bayar, false));

            return [
                'id' => $p->id,
                'nomor_antrian' => $p->nomor_antrian,
                'name' => $p->nama_pemesan,
                'total' => intval($total),
                'metode' => $p->metode_pembayaran,
                'catatan' => $p->catatan,
                'items' => $items,
                'timeRemaining' => intval($timeRemaining),
            ];
        });

        return response()->json($result);
    }

    /**
     * POST /api/kasir/pesanan/{id}/terima
     * Kasir menerima pesanan.
     */
    public function terima($id)
    {
        $pesanan = Pesanan::find($id);
        if (!$pesanan || $pesanan->status !== 'menunggu_konfirmasi') {
            return response()->json(['success' => false, 'message' => 'Pesanan tidak ditemukan atau sudah diproses.'], 404);
        }

        $pesanan->update(['status' => 'diproses']);

        return response()->json(['success' => true, 'message' => 'Pesanan diterima.']);
    }

    /**
     * POST /api/kasir/pesanan/{id}/tolak
     * Kasir menolak pesanan.
     */
    public function tolak($id)
    {
        $pesanan = Pesanan::find($id);
        if (!$pesanan || $pesanan->status !== 'menunggu_konfirmasi') {
            return response()->json(['success' => false, 'message' => 'Pesanan tidak ditemukan atau sudah diproses.'], 404);
        }

        $pesanan->update(['status' => 'batal']);

        return response()->json(['success' => true, 'message' => 'Pesanan ditolak.']);
    }
}
