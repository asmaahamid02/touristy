<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class CommentFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'user_id' => rand(1, 100),
            'content' => $this->faker->paragraph(rand(1, 3)),
            'created_at' => $this->faker->dateTimeBetween('-1 year', 'now'),
        ];
    }
}