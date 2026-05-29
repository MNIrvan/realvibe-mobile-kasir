<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Feedback extends Model
{
    protected $table = 'feedbacks';

    protected $fillable = [
        'nama_pelanggan',
        'kontak',
        'pesan',
        'rating',
        'is_read',
    ];
}
