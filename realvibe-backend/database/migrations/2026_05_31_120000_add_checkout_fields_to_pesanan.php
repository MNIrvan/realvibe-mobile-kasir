<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('pesanan', function (Blueprint $table) {
            $table->string('metode_pembayaran')->nullable()->after('nama_pemesan');
            $table->text('catatan')->nullable()->after('metode_pembayaran');
            $table->string('session_id')->nullable()->after('catatan');
        });
    }

    public function down(): void
    {
        Schema::table('pesanan', function (Blueprint $table) {
            $table->dropColumn(['metode_pembayaran', 'catatan', 'session_id']);
        });
    }
};
