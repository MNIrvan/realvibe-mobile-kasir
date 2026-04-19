<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Kereta;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class KeretaController extends Controller
{
    /**
     * GET /api/kereta
     * Daftar semua kereta beserta URL foto
     */
    public function index(): JsonResponse
    {
        $kereta = Kereta::all()->map(function ($item) {
            return [
                'id' => $item->id,
                'gambar' => $item->gambar,
                'gambar_url' => $item->gambar_url,
                'created_at' => $item->created_at,
                'updated_at' => $item->updated_at,
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $kereta,
        ]);
    }

    /**
     * GET /api/kereta/{id}
     * Detail satu kereta
     */
    public function show(int $id): JsonResponse
    {
        $kereta = Kereta::find($id);

        if (!$kereta) {
            return response()->json(['success' => false, 'message' => 'Kereta tidak ditemukan'], 404);
        }

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $kereta->id,
                'gambar' => $kereta->gambar,
                'gambar_url' => $kereta->gambar_url,
                'created_at' => $kereta->created_at,
                'updated_at' => $kereta->updated_at,
            ],
        ]);
    }

    /**
     * POST /api/kereta
     * Buat data kereta baru dengan foto jadwal
     */
    public function store(Request $request): JsonResponse
    {
        $validator = Validator::make($request->all(), [
            'foto' => 'required|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $file = $request->file('foto');
        $filename = 'jadwal_' . time() . '_' . $file->getClientOriginalName();
        $path = $file->storeAs('kereta', $filename, 'public');

        $kereta = Kereta::create([
            'gambar' => $path,
        ]);

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $kereta->id,
                'gambar' => $kereta->gambar,
                'gambar_url' => $kereta->gambar_url,
                'created_at' => $kereta->created_at,
                'updated_at' => $kereta->updated_at,
            ],
        ], 201);
    }

    /**
     * POST /api/kereta/{id}/upload-foto
     * Upload / ganti foto jadwal kereta.
     */
    public function uploadFoto(Request $request, int $id): JsonResponse
    {
        $kereta = Kereta::find($id);

        if (!$kereta) {
            return response()->json(['success' => false, 'message' => 'Kereta tidak ditemukan'], 404);
        }

        $validator = Validator::make($request->all(), [
            'foto' => 'required|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $file = $request->file('foto');
        $filename = 'jadwal_' . time() . '_' . $file->getClientOriginalName();
        $path = $file->storeAs("kereta/{$id}", $filename, 'public');

        if ($kereta->gambar) {
            Storage::disk('public')->delete($kereta->gambar);
        }

        $kereta->update([
            'gambar' => $path,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Foto jadwal berhasil diperbarui',
            'data' => [
                'id' => $kereta->id,
                'gambar' => $kereta->gambar,
                'gambar_url' => $kereta->gambar_url,
                'created_at' => $kereta->created_at,
                'updated_at' => $kereta->updated_at,
            ],
        ]);
    }

    /**
     * GET /api/kereta/{id}/riwayat-foto
     * Ambil semua riwayat foto lama
     */
    public function riwayatFoto(int $id): JsonResponse
    {
        $kereta = Kereta::find($id);

        if (!$kereta) {
            return response()->json(['success' => false, 'message' => 'Kereta tidak ditemukan'], 404);
        }

        $riwayat = $kereta->riwayat_foto ?? [];

        // Tambahkan URL ke setiap entry riwayat
        $riwayatDenganUrl = array_map(function ($item) {
            return [
                ...$item,
                'url' => Storage::disk('public')->url($item['path']),
            ];
        }, $riwayat);

        return response()->json([
            'success' => true,
            'data' => $riwayatDenganUrl,
        ]);
    }
}