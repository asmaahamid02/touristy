<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class PostFactory extends Factory
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
            'content' => $this->faker->paragraph(10),
            'publicity' => $this->faker->randomElement(['public']),
            'created_at' => $this->faker->dateTimeBetween('-1 year', 'now'),
        ];
    }
}