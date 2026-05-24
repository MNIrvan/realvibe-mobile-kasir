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
        //
        Schema::create('kereta', function (Blueprint $table) {
            $table->id();
            $table->string('rute')->nullable();
            $table->time('waktu_keberangkatan')->nullable();
            $table->integer('kuota_maksimal')->default(0);
            $table->integer('sisa_kuota')->default(0);
            $table->integer('harga_tiket')->nullable();
            $table->string('gambar')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
        Schema::dropIfExists('kereta');
    }
};
