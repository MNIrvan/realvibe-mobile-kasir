<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Informasi extends Model
{
    protected $table = 'informasis';
    
    protected $fillable = [
        'judul',
        'deskripsi',
        'image_path',
        'is_active',
    ];
}
