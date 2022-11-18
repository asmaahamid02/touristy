<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class TripFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [

            'title' => $this->faker->sentence(3),
            'description' => $this->faker->paragraph(3),
            'arrival_date' => $this->faker->dateTimeBetween('now', '+1 years'),
            'departure_date' => $this->faker->dateTimeBetween('+1 years', '+2 years'),
            'is_past' => $this->faker->boolean(20),
            'location_id' => $this->faker->numberBetween(1, 100),
            'user_id' => $this->faker->numberBetween(1, 100),
        ];
    }
}