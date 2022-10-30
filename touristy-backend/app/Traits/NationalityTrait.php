<?php

namespace App\Traits;

use App\Models\Nationality;

trait NationalityTrait
{
    //save nationality

    public function saveNationality($country)
    {
        $nationality = Nationality::where('nationality', $country)->first();

        if (!$nationality) {
            $nationality = Nationality::create(['nationality' => $country]);
        }

        return $nationality->id;
    }
}