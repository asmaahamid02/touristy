<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class UserFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array
     */
    public function definition()
    {
        return [
            'first_name' => $this->faker->firstName,
            'last_name' => $this->faker->lastName,
            'email' => $this->faker->unique()->safeEmail(),
            'email_verified_at' => now(),
            'password' => '$2a$12$Iaor2RV0H/u/2GdMV1ntBOdzNq8LdPvZxBJZSxQ9kJINA.pQ3ftW6', // password123
            'user_type_id' => 2,
            'date_of_birth' => $this->faker->date(),
            'gender' => $this->faker->randomElement(['male', 'female', 'other']),
            'profile_picture' => rand(1, 56) . '.jpg',
        ];
    }

    /**
     * Indicate that the model's email address should be unverified.
     *
     * @return \Illuminate\Database\Eloquent\Factories\Factory
     */
    public function unverified()
    {
        return $this->state(function (array $attributes) {
            return [
                'email_verified_at' => null,
            ];
        });
    }
}