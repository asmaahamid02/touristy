<?php

namespace App\Traits;

use App\Models\Location;

trait LocationTrait
{

    public function saveLocation($latitude, $longitude, $city, $country)
    {
        $location = Location::where('latitude', $latitude)->where('longitude', $longitude)->first();

        if ($location) {
            return $location->id;
        }

        $location = new Location();
        $location->latitude = $latitude;
        $location->longitude = $longitude;
        $location->city = $city;
        $location->country = $country;
        $location->save();

        return $location->id;
    }
}