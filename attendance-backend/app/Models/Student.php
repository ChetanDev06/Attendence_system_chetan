<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Student extends Model
{
    // 1️⃣ Fillable fields: allows mass assignment
    protected $fillable = ['name','roll_no','dob','photo_url'];

    // 2️⃣ Relationship: A student can belong to many classes
    public function classes(): BelongsToMany
    {
        // many-to-many relation via pivot table 'class_student'
        return $this->belongsToMany(SchoolClass::class, 'class_student');
    }

    // 3️⃣ Relationship: A student can have many iris templates
    public function irisTemplates(): HasMany
    {
        return $this->hasMany(IrisTemplate::class);
    }

    // 4️⃣ Relationship: A student can have many attendance records
    public function attendanceRecords(): HasMany
    {
        return $this->hasMany(AttendanceRecord::class);
    }
}
