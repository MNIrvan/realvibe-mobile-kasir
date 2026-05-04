<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        // 1. Validasi input dari Flutter
        $request->validate([
            'username' => 'required',
            'password' => 'required',
        ]);

        // 2. Cari user berdasarkan username
        $user = User::where('username', $request->username)->first();

        // 3. Cek apakah user ada dan password benar
        // Catatan: Pastikan password di database di-hash menggunakan bcrypt/Hash::make
        if ($user && Hash::check($request->password, $user->password)) {
            return response()->json([
                'status' => 'success',
                'message' => 'Login berhasil',
                'data' => [
                    'id' => $user->id,
                    'nama' => $user->name,
                    'username' => $user->username,
                    'role' => $user->role,
                ]
            ], 200);
        }

        // 4. Jika gagal
        return response()->json([
            'status' => 'error',
            'message' => 'Username atau password salah'
        ], 401);
    }


    public function register(Request $request)
    {
        // 1. Validasi Input
        $request->validate([
            'nama' => 'required|string|max:255',
            'username' => 'required|string|unique:users',
            'password' => 'required|min:6',
        ]);

        // 2. Simpan ke Database dengan Password Hashing otomatis dari model
        $user = User::create([
            'name' => $request->nama,
            'username' => $request->username,
            'password' => Hash::make($request->password),
        ]);

        return response()->json([
            'status' => 'success',
            'message' => 'Registrasi berhasil',
            'data' => $user
        ], 201);
    }


}

