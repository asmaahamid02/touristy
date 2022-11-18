<?php

namespace App\Traits;

use App\Models\Location;

trait LocationTrait
{

    public function saveLocation($latitude, $longitude, $address)
    {
        $location =  Location::Create([
            'latitude' => $latitude,
            'longitude' => $longitude,
            'address' => $address,
        ]);

        return $location->id;
    }
}