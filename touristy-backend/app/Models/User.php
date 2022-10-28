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
        return $this->belongsToMany(Group::class, 'users_groups', 'user_id', 'group_id');
    }

    public function created_events()
    {
        return $this->hasMany(Event::class);
    }

    public function interested_events()
    {
        return $this->belongsToMany(Event::class, 'interested_events', 'user_id', 'event_id')->withTimestamps();
    }

    public function joined_events()
    {
        return $this->belongsToMany(Event::class, 'joined_events', 'user_id', 'event_id')->withTimestamps();
    }

    public function mentioned_in_posts()
    {
        return $this->belongsToMany(Post::class, 'posts_mentions', 'user_id', 'post_id');
    }

    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    public function mentioned_in_comments()
    {
        return $this->belongsToMany(Comment::class, 'comments_mentions', 'user_id', 'comment_id');
    }

    public function post_likes()
    {
        return $this->belongsToMany(Post::class, 'likes', 'user_id', 'post_id')->withTimestamps();
    }

    public function comment_likes()
    {
        return $this->belongsToMany(Comment::class, 'likes', 'user_id', 'comment_id')->withTimestamps();
    }

    public function following()
    {
        return $this->belongsToMany(User::class, 'followships', 'user_id', 'followed_user_id')->withTimestamps();
    }
}