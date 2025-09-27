<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsToMany;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SchoolClass extends Model
{
    protected $fillable = ['name','grade','school_id'];

    // Many students belong to a class
    public function students(): BelongsToMany
    {
        return $this->belongsToMany(Student::class, 'class_student');
    }

    // Attendance records for this class
    public function attendanceRecords(): HasMany
    {
        return $this->hasMany(AttendanceRecord::class);
    }
}
