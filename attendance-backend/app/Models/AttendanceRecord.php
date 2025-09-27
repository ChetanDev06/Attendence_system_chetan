<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class AttendanceRecord extends Model
{
    protected $fillable = [
        'class_id', 'student_id', 'marked_by', 
        'present_at', 'method', 'confidence', 'device_id', 'raw_meta'
    ];

    protected $casts = [
        'raw_meta' => 'array',
        'present_at' => 'datetime'
    ];

    // Attendance belongs to a student
    public function student(): BelongsTo
    {
        return $this->belongsTo(Student::class);
    }

    // Attendance belongs to a class
    public function schoolClass(): BelongsTo
    {
        return $this->belongsTo(SchoolClass::class, 'class_id');
    }

    // Attendance may be marked by a teacher (user)
    public function markedBy(): BelongsTo
    {
        return $this->belongsTo(User::class, 'marked_by');
    }
}
