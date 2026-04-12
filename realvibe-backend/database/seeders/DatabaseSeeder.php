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
<<<<<<< HEAD
        // User::factory(10)->create();

        User::factory()->create([
            'name' => 'Test User',
            'email' => 'test@example.com',
        ]);
    }
=======
        // Membuat Admin
    \App\Models\User::create([
        'nama' => 'Admin Cafe',
        'username' => 'admin',
        'password' => bcrypt('admin123'),
        'role' => 'admin',
    ]);

    // Membuat Kasir
    \App\Models\User::create([
        'nama' => 'Kasir Cafe',
        'username' => 'kasir',
        'password' => bcrypt('kasir123'),
        'role' => 'kasir',
    ]);

    }


>>>>>>> 7c57db720f0eaac1a8d7a2d80c0b0e3db15139c6
}
