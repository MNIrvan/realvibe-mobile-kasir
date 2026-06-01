<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class CashierSession extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'session_code',
        'business_date',
        'opened_at',
        'closed_at',
        'status',
        'opening_balance',
        'total_cash_in',
        'total_cash_out',
        'subtotal',
    ];

    protected function casts(): array
    {
        return [
            'business_date' => 'date',
            'opened_at' => 'datetime',
            'closed_at' => 'datetime',
            'opening_balance' => 'decimal:2',
            'total_cash_in' => 'decimal:2',
            'total_cash_out' => 'decimal:2',
            'subtotal' => 'decimal:2',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function entries(): HasMany
    {
        return $this->hasMany(CashierSessionEntry::class);
    }
}
