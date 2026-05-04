<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // 1. Membuat Test User (Bawaan Laravel)
        User::create([
            'name' => 'Test User',
            'username' => 'testuser',
            'password' => bcrypt('password123'),
            'role' => 'user',
        ]);

        // 2. Membuat Admin (Sesuai kebutuhan Natta Coffee)
        User::create([
            'name' => 'Admin Cafe',
            'username' => 'admin',
            'password' => bcrypt('admin123'),
            'role' => 'admin',
        ]);

        // 3. Membuat Kasir (Sesuai kebutuhan Natta Coffee)
        User::create([
            'name' => 'Kasir Cafe',
            'username' => 'kasir',
            'password' => bcrypt('kasir123'),
            'role' => 'kasir',
        ]);
    } // Pastikan semua kode di atas berada SEBELUM kurung ini
}



