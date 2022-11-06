<?php

namespace App\Traits;

use App\Models\Nationality;

trait NationalityTrait
{
    //save nationality

    public function saveNationality($country, $country_code)
    {
        $nationality = Nationality::where('country_code', $country_code)->first();

        if (!$nationality) {
            $nationality = Nationality::create([
                'nationality' => $country,
                'country_code' => $country_code
            ]);
        }

        return $nationality->id;
    }
}