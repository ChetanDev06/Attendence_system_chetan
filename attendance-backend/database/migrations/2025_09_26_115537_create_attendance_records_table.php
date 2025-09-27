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
        Schema::create('attendance_records', function (Blueprint $table) {
            $table->id();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::create('attendance_records', function (Blueprint $table) {
        $table->id();
        $table->foreignId('class_id')->constrained('classes')->onDelete('cascade');
        $table->foreignId('student_id')->constrained('students')->onDelete('cascade');
        $table->foreignId('marked_by')->nullable()->constrained('users')->onDelete('set null'); // teacher/device
        $table->timestamp('present_at');
        $table->string('method'); // iris/manual/qr
        $table->float('confidence')->nullable();
        $table->string('device_id')->nullable();
        $table->json('raw_meta')->nullable();
        $table->timestamps();
});

    }
};
