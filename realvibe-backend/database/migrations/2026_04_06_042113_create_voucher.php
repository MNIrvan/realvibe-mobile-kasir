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
        Schema::create('voucher', function (Blueprint $table) {
            $table->integer('id')->unsigned()->autoIncrement()->primary();
            $table->string('kode_voucher')->unique();
            $table->decimal('nilai_diskon', 8, 2);
            $table->string('tipe_diskon');
            $table->date('tanggal_kadaluarsa');
            $table->Integer('max_penggunaan');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('voucher');
    }
};
