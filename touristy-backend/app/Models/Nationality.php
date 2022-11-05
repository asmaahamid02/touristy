<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Nationality extends Model
{
    use HasFactory;

    protected $fillable = [
        'nationality',
        'country_code'
    ];

    public function users()
    {
        return $this->hasMany(User::class);
    }
}