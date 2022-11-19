<?php

namespace App\Http\Resources;

use App\Models\Location;
use Illuminate\Http\Resources\Json\JsonResource;

class UserResource extends JsonResource
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
            'id' => $this->id,
            'first_name' => $this->first_name,
            'last_name' => $this->last_name,
            'nationality' => new NationalityResource($this->whenLoaded('nationality')),
            'email' => $this->email,
            'isFollowedByUser' => $this->isFollowedByUser,
            'isFollowingUser' => $this->isFollowingUser,
            'isBlockedByUser' => $this->isBlockedByUser,
            'isBlockingUser' => $this->isBlockingUser,
            'profile_picture' => $this->profile_picture != null ? asset('storage/uploads/' . $this->profile_picture) : null,
            'cover_picture' => $this->cover_picture != null ? asset('storage/uploads/' . $this->cover_picture) : null,
            'bio' => $this->bio,
            'followers' => $this->followers_count,
            'followings' => $this->followings_count,
            'location' => new LocationResource($this->whenLoaded('location')),
            'joinedAt' => $this->created_at,
        ];
    }
}