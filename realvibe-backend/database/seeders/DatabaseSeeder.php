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
        User::updateOrCreate(
            ['username' => 'testuser'],
            [
                'name' => 'Test User',
                'password' => bcrypt('password123'),
                'role' => 'user',
            ]
        );

        User::updateOrCreate(
            ['username' => 'admin'],
            [
                'name' => 'Admin Cafe',
                'password' => bcrypt('admin123'),
                'role' => 'admin',
            ]
        );

        User::updateOrCreate(
            ['username' => 'kasir'],
            [
                'name' => 'Kasir Cafe',
                'password' => bcrypt('kasir123'),
                'role' => 'kasir',
            ]
        );
    }
}
