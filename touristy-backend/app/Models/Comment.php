<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Comment extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'post_id',
        'comment_id',
        'content',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function post()
    {
        return $this->belongsTo(Post::class);
    }

    public function comment()
    {
        return $this->belongsTo(Comment::class);
    }

    public function replies()
    {
        return $this->hasMany(Comment::class);
    }

    public function mentioned_users()
    {
        return $this->belongsToMany(User::class, 'comments_mentions', 'comment_id', 'user_id');
    }

    public function likes()
    {
        return $this->belongsToMany(User::class, 'likes', 'comment_id', 'user_id')->withTimestamps();
    }
}