<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class NationalityResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return array|\Illuminate\Contracts\Support\Arrayable|\JsonSerializable
     */
    public function toArray($request)
    {
        return [
            'nationality' => $this->nationality,
            'country_code' => $this->country_code,

        ];
    }
}