<?php

namespace Database\Seeders;

use App\Models\Comment;
use App\Models\Post;
use App\Models\PostMedia;
use Illuminate\Database\Seeder;

class PostSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        Post::factory(100)->create()->each(
            function ($post) {
                $post->media()->saveMany(
                    PostMedia::factory(rand(1, 5))->create([
                        'post_id' => $post->id,
                    ])
                );

                $post->comments()->saveMany(
                    Comment::factory(rand(1, 5))->create([
                        'post_id' => $post->id,
                    ])
                );
            }
        );
    }
}