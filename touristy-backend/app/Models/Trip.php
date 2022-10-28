<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Trip extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'location_id',
        'title',
        'description',
        'arrival_date',
        'departure_date',
        'is_past',
    ];

    // Relationships
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}