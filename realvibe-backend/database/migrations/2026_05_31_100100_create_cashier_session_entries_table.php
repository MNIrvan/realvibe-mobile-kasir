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
        Schema::create('cashier_session_entries', function (Blueprint $table) {
            $table->id();
            $table->foreignId('cashier_session_id')->constrained('cashier_sessions')->cascadeOnDelete();
            $table->enum('entry_type', ['in', 'out'])->index();
            $table->string('title');
            $table->decimal('amount', 14, 2);
            $table->text('notes')->nullable();
            $table->dateTime('happened_at');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('cashier_session_entries');
    }
};
