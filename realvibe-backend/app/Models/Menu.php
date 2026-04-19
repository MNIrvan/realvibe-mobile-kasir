<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Menu extends Model
{
    protected $table = 'menu';

    protected $fillable = [
        'id_kategori_menu',
        'nama_menu',
        'harga',
        'stok',
        'gambar',
    ];

    protected $casts = [
        'harga' => 'decimal:2',
    ];
}
