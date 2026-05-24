<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Storage;

class Kereta extends Model
{
    use HasFactory;

    protected $table = 'kereta';

    protected $fillable = [
        'rute',
        'waktu_keberangkatan',
        'kuota_maksimal',
        'sisa_kuota',
        'harga_tiket',
        'gambar',
    ];

    public function getGambarUrlAttribute(): ?string
    {
        if (!$this->gambar) {
            return null;
        }

        return Storage::disk('public')->url($this->gambar);
    }

    /**
     * Accessor: URL lengkap semua riwayat foto
     */
    public function getRiwayatFotoUrlAttribute(): array
    {
        if (!$this->riwayat_foto)
            return [];
        return array_map(
            fn($path) => Storage::disk('public')->url($path),
            $this->riwayat_foto
        );
    }
}
