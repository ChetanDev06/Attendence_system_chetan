<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class IrisTemplate extends Model
{
    protected $fillable = ['student_id','embedding','meta'];

    // cast meta JSON column to array automatically
    protected $casts = [
        'meta' => 'array',
    ];

    // Each template belongs to a student
    public function student(): BelongsTo
    {
        return $this->belongsTo(Student::class);
    }
}
