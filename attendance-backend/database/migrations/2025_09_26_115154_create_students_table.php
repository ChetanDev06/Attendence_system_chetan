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
        Schema::create('students', function (Blueprint $table) {
            $table->id();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::create('students', function (Blueprint $t) {
        $t->id();
        $t->string('name');
        $t->string('roll_no')->nullable();
        $t->date('dob')->nullable();
        $t->string('photo_url')->nullable();
        $t->timestamps();
});
    }
};
