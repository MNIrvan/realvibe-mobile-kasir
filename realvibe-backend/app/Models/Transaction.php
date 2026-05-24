<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Transaction extends Model
{
    protected $fillable = [
        'order_id',
        'kasir_id',
        'nama_pelanggan',
        'grand_total',
        'status',
    ];

    public function kasir()
    {
        return $this->belongsTo(User::class, 'kasir_id');
    }
}
