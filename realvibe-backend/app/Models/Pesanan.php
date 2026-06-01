<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pesanan extends Model
{
    protected $table = 'pesanan';

    protected $fillable = [
        'sesi_id',
        'meja_id',
        'nomor_antrian',
        'status',
        'tipe_pesanan',
        'waktu_pesan',
        'waktu_batas_bayar',
        'alasan_batal',
        'nama_pemesan',
        'metode_pembayaran',
        'catatan',
        'session_id',
    ];

    protected $casts = [
        'waktu_pesan' => 'datetime',
        'waktu_batas_bayar' => 'datetime',
    ];

    public function detailPesanan()
    {
        return $this->hasMany(DetailPesanan::class, 'pesanan_id');
    }
}
