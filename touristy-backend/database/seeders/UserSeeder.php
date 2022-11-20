<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        User::factory(100)->create(
            [
                'nationality_id' => rand(1, 252),
                'location_id' => rand(1, 100),
            ]
        );
    }
}