<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\SchoolClass;
use App\Models\AttendanceRecord;

class AttendanceController extends Controller
{
    public function store(Request $r)
{
    $r->validate([
        'class_id' => 'required|exists:classes,id',
        'student_id' => 'required|exists:students,id',
        'device_id' => 'nullable|string',
        'method' => 'required|string',
        'confidence' => 'nullable|numeric'
    ]);

    $class = SchoolClass::find($r->class_id);

    // Prevent duplicate for same date + class + student
    $todayStart = now()->startOfDay();
    $exists = AttendanceRecord::where('class_id', $class->id)
        ->where('student_id', $r->student_id)
        ->where('present_at', '>=', $todayStart)
        ->exists();

    if ($exists) {
        return response()->json(['ok' => false, 'message' => 'already marked'], 409);
    }

    $rec = AttendanceRecord::create([
        'class_id' => $class->id,
        'student_id' => $r->student_id,
        'marked_by' => $r->user()->id,
        'present_at' => now(),
        'method' => $r->method,
        'confidence' => $r->confidence,
        'device_id' => $r->device_id,
        'raw_meta' => $r->raw_meta ?? null
    ]);

    return response()->json(['ok' => true, 'record' => $rec], 201);
}
}
