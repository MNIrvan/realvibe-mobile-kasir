<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Menu;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

class MenuController extends Controller
{
    /**
     * Menampilkan semua data menu.
     */
    public function index()
    {
        $menus = Menu::orderBy('id', 'desc')->get();

        return response()->json([
            'status' => 'success',
            'data' => $menus,
        ]);
    }

    /**
     * Menampilkan satu data menu berdasarkan ID.
     */
    public function show($id)
    {
        $menu = Menu::find($id);

        if (!$menu) {
            return response()->json([
                'status' => 'error',
                'message' => 'Menu tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'status' => 'success',
            'data' => $menu,
        ]);
    }

    /**
     * Menyimpan data menu baru.
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'id_kategori_menu' => 'required|integer',
            'nama_menu' => 'required|string|max:255',
            'harga' => 'required|numeric|min:0',
            'stok' => 'required|in:tersedia,habis',
            'gambar' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $data = $request->only(['id_kategori_menu', 'nama_menu', 'harga', 'stok']);

        // Handle upload gambar
        if ($request->hasFile('gambar')) {
            $path = $request->file('gambar')->store('menu', 'public');
            $data['gambar'] = $path;
        }

        $menu = Menu::create($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Menu berhasil ditambahkan',
            'data' => $menu,
        ], 201);
    }

    /**
     * Memperbarui data menu.
     */
    public function update(Request $request, $id)
    {
        $menu = Menu::find($id);

        if (!$menu) {
            return response()->json([
                'status' => 'error',
                'message' => 'Menu tidak ditemukan',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'id_kategori_menu' => 'sometimes|required|integer',
            'nama_menu' => 'sometimes|required|string|max:255',
            'harga' => 'sometimes|required|numeric|min:0',
            'stok' => 'sometimes|required|in:tersedia,habis',
            'gambar' => 'nullable|image|mimes:jpg,jpeg,png,webp|max:2048',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'status' => 'error',
                'message' => 'Validasi gagal',
                'errors' => $validator->errors(),
            ], 422);
        }

        $data = $request->only(['id_kategori_menu', 'nama_menu', 'harga', 'stok']);

        // Handle upload gambar baru
        if ($request->hasFile('gambar')) {
            // Hapus gambar lama jika ada
            if ($menu->gambar && Storage::disk('public')->exists($menu->gambar)) {
                Storage::disk('public')->delete($menu->gambar);
            }
            $path = $request->file('gambar')->store('menu', 'public');
            $data['gambar'] = $path;
        }

        $menu->update($data);

        return response()->json([
            'status' => 'success',
            'message' => 'Menu berhasil diperbarui',
            'data' => $menu,
        ]);
    }

    /**
     * Menghapus data menu.
     */
    public function destroy($id)
    {
        $menu = Menu::find($id);

        if (!$menu) {
            return response()->json([
                'status' => 'error',
                'message' => 'Menu tidak ditemukan',
            ], 404);
        }

        // Hapus gambar jika ada
        if ($menu->gambar && Storage::disk('public')->exists($menu->gambar)) {
            Storage::disk('public')->delete($menu->gambar);
        }

        $menu->delete();

        return response()->json([
            'status' => 'success',
            'message' => 'Menu berhasil dihapus',
        ]);
    }
}
