<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Tymon\JWTAuth\Contracts\JWTSubject;


class User extends Authenticatable implements JWTSubject
{
    use HasFactory, Notifiable;
    protected $fillable = [
        'first_name',
        'last_name',
        'email',
        'password',
        'date_of_birth',
        'gender',
        'profile_picture',
        'cover_picture',
        'bio',
        'is_deleted',
    ];

    protected $hidden = [
        'password', 'remember_token',
    ];

    protected $casts = [
        'email_verified_at' => 'datetime',
    ];

    // JWTSubject interface methods
    public function getJWTIdentifier()
    {
        return $this->getKey();
    }
    public function getJWTCustomClaims()
    {
        return [];
    }

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
        return $this->belongsToMany(Group::class, 'users_groups', 'user_id', 'group_id')->withTimestamps();
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

    public function followings()
    {
        return $this->belongsToMany(User::class, 'followships', 'follower_user_id', 'followed_user_id')->withTimestamps();
    }

    public function followers()
    {
        return $this->belongsToMany(User::class, 'followships', 'followed_user_id', 'follower_user_id')->withTimestamps();
    }

    public function blockings()
    {
        return $this->belongsToMany(User::class, 'blockships', 'user_id', 'blocked_user_id')->withTimestamps();
    }

    public function blockers()
    {
        return $this->belongsToMany(User::class, 'blockships', 'blocked_user_id', 'user_id')->withTimestamps();
    }
}