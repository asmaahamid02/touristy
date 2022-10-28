<?php

namespace Database\Seeders;

use App\Models\UserType;
use Illuminate\Database\Seeder;

class UserTypeSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        $userTypes = [
            [
                'type' => 'admin',

            ],
            [
                'type' => 'user',
            ]
        ];

        foreach ($userTypes as $userType) {
            UserType::create($userType);
        }
    }
}