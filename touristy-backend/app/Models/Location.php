<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Location extends Model
{
    use HasFactory;

    protected $fillable = [
        'latitude',
        'longitude',
        'address'
    ];

    public function posts()
    {
        return $this->hasMany(Post::class);
    }

    public function trips()
    {
        return $this->hasMany(Trip::class);
    }

    public function events()
    {
        return $this->hasMany(Event::class);
    }
}