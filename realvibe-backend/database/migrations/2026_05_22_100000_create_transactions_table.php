<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('transaksi', function (Blueprint $table) {
            $table->id();
            $table->string('order_id')->unique();
            $table->foreignId('kasir_id')->nullable()->constrained('users')->nullOnDelete();
            $table->string('nama_pelanggan')->nullable();
            $table->integer('grand_total')->default(0);
            $table->enum('status', ['success', 'refund'])->default('success');
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('transaksi');
    }
};
