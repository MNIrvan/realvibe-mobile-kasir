<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('cashier_sessions', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->cascadeOnDelete();
            $table->string('session_code')->unique();
            $table->date('business_date')->index();
            $table->dateTime('opened_at');
            $table->dateTime('closed_at')->nullable();
            $table->enum('status', ['open', 'closed'])->default('open')->index();
            $table->decimal('opening_balance', 14, 2)->default(0);
            $table->decimal('total_cash_in', 14, 2)->default(0);
            $table->decimal('total_cash_out', 14, 2)->default(0);
            $table->decimal('subtotal', 14, 2)->default(0);
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cashier_sessions');
    }
};
