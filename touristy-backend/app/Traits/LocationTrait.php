<?php

namespace App\Traits;

use App\Models\Location;

trait LocationTrait
{

    public function saveLocation($latitude, $longitude, $city, $country)
    {
        // $location = Location::where('latitude', $latitude)->where('longitude', $longitude)->first();

        // if ($location) {
        //     return $location->id;
        // }

        $location =  Location::Create([
            'latitude' => $latitude,
            'longitude' => $longitude,
            'city' => $city,
            'country' => $country
        ]);

        return $location->id;
    }
}