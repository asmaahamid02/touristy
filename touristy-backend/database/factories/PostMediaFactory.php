<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class PostMediaFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'media_path' => rand(1, 56) . '.jpg',
            'media_type' => 'image',
        ];
    }
}