<?php

namespace App\Http\Controllers;

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\StudentController;
use App\Http\Controllers\ClassController;
use App\Http\Controllers\AttendanceController;
use App\Http\Controllers\IrisTemplateController;
use App\Http\Controllers\DeviceController;
use Illuminate\Support\Facades\App;

// -------------------------------------------
// 1️⃣ Students Endpoints
// -------------------------------------------

// Get all students
Route::get('/students', [StudentController::class, 'index']);

// Get a single student by ID
Route::get('/students/{id}', [StudentController::class, 'show']);

// Create a new student
Route::post('/students', [StudentController::class, 'store']);

// Update an existing student
Route::put('/students/{id}', [StudentController::class, 'update']);

// Delete a student
Route::delete('/students/{id}', [StudentController::class, 'destroy']);
Route::get('/classes', [ClassController::class, 'index']);
Route::get('/classes/{id}', [ClassController::class, 'show']);
Route::post('/classes', [ClassController::class, 'store']);
Route::put('/classes/{id}', [ClassController::class, 'update']);
Route::delete('/classes/{id}', [ClassController::class, 'destroy']);

// Assign students to class
Route::post('/classes/{id}/students', [ClassController::class, 'assignStudents']);

// Mark attendance (iris/manual)
Route::post('/attendance', [AttendanceController::class, 'store']);

// Get attendance by class or student
Route::get('/attendance', [AttendanceController::class, 'index']);
Route::get('/attendance/{id}', [AttendanceController::class, 'show']);

Route::get('/iris-templates', [IrisTemplateController::class, 'index']);
Route::post('/iris-templates', [IrisTemplateController::class, 'store']);
Route::get('/iris-templates/{student_id}', [IrisTemplateController::class, 'show']);

Route::post('/devices', [DeviceController::class, 'store']);
Route::get('/devices', [DeviceController::class, 'index']);
Route::get('/devices/{id}', [DeviceController::class, 'show']);

Route::post('/login', [AuthController::class, 'login']);
Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
});

Route::get('/dev/iris-templates', [IrisTemplateController::class, 'devIndex']);
if (App::environment('local')) {
    Route::get('/dev/iris-templates', [IrisTemplateController::class, 'devIndex']);
}
Route::post('/attendance', [AttendanceController::class, 'store'])->middleware('auth:api');