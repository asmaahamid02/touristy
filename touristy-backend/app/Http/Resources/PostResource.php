<?php

namespace App\Http\Resources;

use Illuminate\Http\Resources\Json\JsonResource;

class PostResource extends JsonResource
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
            'content' => $this->content,
            'location' => new LocationResource($this->whenLoaded('location')),
            'media' => MediaResource::collection($this->whenLoaded('media')),
            'user' => new UserResource($this->whenLoaded('user')),
            'likes' => $this->likes_count,
            'comments' => $this->comments_count,
            'isLikedByUser' => $this->isLikedByUser,
            'created_at' => $this->created_at,
        ];
    }
}