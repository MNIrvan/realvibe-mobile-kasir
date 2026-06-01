<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class CashierSessionEntry extends Model
{
    use HasFactory;

    protected $fillable = [
        'cashier_session_id',
        'entry_type',
        'title',
        'amount',
        'notes',
        'happened_at',
    ];

    protected function casts(): array
    {
        return [
            'amount' => 'decimal:2',
            'happened_at' => 'datetime',
        ];
    }

    public function session(): BelongsTo
    {
        return $this->belongsTo(CashierSession::class, 'cashier_session_id');
    }
}
