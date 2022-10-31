<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class PostMedia extends Model
{
    use HasFactory;

    protected $table = 'posts_media';

    protected $fillable = [
        'post_id',
        'media_path',
        'media_type',
    ];
}