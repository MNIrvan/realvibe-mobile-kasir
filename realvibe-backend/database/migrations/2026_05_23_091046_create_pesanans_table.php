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
        Schema::create('pesanan', function (Blueprint $table) {
            $table->id();
            $table->integer('sesi_id')->nullable();
            $table->integer('meja_id')->nullable();
            $table->string('nomor_antrian')->nullable();
            $table->string('status')->nullable();
            $table->string('tipe_pesanan')->nullable();
            $table->timestamp('waktu_pesan')->nullable();
            $table->timestamp('waktu_batas_bayar')->nullable();
            $table->string('alasan_batal')->nullable();
            $table->text('nama_pemesan')->nullable(); 
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('pesanan');
    }
};
