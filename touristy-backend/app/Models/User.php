<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;
    protected $fillable = [
        'name',
        'email',
        'password',
    ];

    protected $hidden = [
        'password',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    // Relationships
    public function nationality()
    {
        return $this->belongsTo(Nationality::class);
    }

    public function posts()
    {
        return $this->hasMany(Post::class);
    }

    public function user_type()
    {
        return $this->belongsTo(UserType::class);
    }

    public function created_groups()
    {
        return $this->hasMany(Group::class);
    }

    public function created_trips()
    {
        return $this->hasMany(Trip::class);
    }

    public function groups()
    {
        return $this->belongsToMany(Group::class);
    }

    public function created_events()
    {
        return $this->hasMany(Event::class);
    }

    public function interested_events()
    {
        return $this->belongsToMany(Event::class, 'interested_events', 'user_id', 'event_id')->withTimestamps();
    }
}