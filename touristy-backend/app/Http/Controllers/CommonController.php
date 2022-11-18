<?php

namespace App\Http\Controllers;

use App\Http\Resources\PostResource;
use App\Http\Resources\UserResource;
use App\Traits\ResponseJson;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\Response;

class CommonController extends Controller
{
    use ResponseJson;
    //get file
    public function getFile($path)
    {
        //check if file exists
        if (Storage::exists($path)) {
            //get file
            $file = Storage::get($path);
            //get file type
            $type = Storage::mimeType($path);
            //get file size
            $size = Storage::size($path);
            //get file name
            $name = basename($path);
            //return file
            return response($file, 200)
                ->header('Content-Type', $type)
                ->header('Content-Length', $size)
                ->header('Content-Disposition', 'inline; filename="' . $name . '"');
        } else {
            //return error
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'File not found');
        }
    }

    //search
    public function search($model, $search, $columns)
    {
        $search = preg_split('/\s+/', $search, -1, PREG_SPLIT_NO_EMPTY);
        $model_full = 'App\Models\\' . $model;
        //search
        $searchResult = $model_full::where(function ($query) use ($columns, $search) {
            foreach ($columns as $column) {
                foreach ($search as $word) {
                    $query->orWhere($column, 'LIKE', '%' . $word . '%');
                }
            }
        });

        return $searchResult->count() > 0 ? $searchResult : null;
    }

    //apply user filters
    public function applyUserFilters($query)
    {
        return $query->where('is_deleted', 0)
            ->where('id', '!=', Auth::id())
            //remove admins
            ->whereHas('user_type', function ($query) {
                $query->where('type', '!=', 'admin');
            })
            //remove blocked users
            ->whereDoesntHave('blockings', function ($query) {
                $query->where('blocked_user_id', Auth::id());
            })
            //remove blocked by users
            ->whereDoesntHave('blockers', function ($query) {
                $query->where('user_id', Auth::id());
            })->orderBy('first_name')->orderBy('last_name');
    }

    //search in users, posts, trips, events, groups.
    public function searchAll($search)
    {
        //search in users
        $users = $this->search('User', $search, ['first_name', 'last_name']);
        $users = $users ? $this->applyUserFilters($users)
            ->orderBy('first_name')
            ->orderBy('last_name')
            ->with('location')
            ->withCount('followers')
            ->withCount('followings')
            ->get() : null;

        if ($users != null) {
            $users->map(function ($user) {
                if ($user == Auth::user())
                    $user->isFollowedByUser = false;
                else
                    $user->isFollowedByUser = $user->followers->contains(Auth::id());
            });
        }

        //search in posts
        $posts = $this->search('Post', $search, ['content']);
        $posts = $posts ? $posts->where('is_deleted', 0)->whereHas('user', function ($query) {
            $this->applyUserFilters($query);
        })->with('location')->orderBy('created_at', 'desc')->get() : null;


        if ($posts != null) {
            $posts->map(function ($post) {
                $post->isLikedByUser = $post->likes->contains(Auth::id());
                $post->user->isFollowedByUser = $post->user->followers->contains(Auth::id());
                //followings count
                $post->user->followings_count = $post->user->followings->count();
                //followers count
                $post->user->followers_count = $post->user->followers->count();
            });
        }

        //search in trips
        $trips = $this->search('Trip', $search, ['title', 'description']);
        $trips = $trips ? $trips->whereHas('user', function ($query) {
            $this->applyUserFilters($query);
        })->with('location')->orderBy('created_at', 'desc')->get() : null;


        //return search results
        return [
            'users' => $users ? UserResource::collection($users) : null,
            'posts' => $posts ? PostResource::collection($posts) : null,
            'trips' => $trips,
        ];
    }

    //search in users
    public function searchUsers($search)
    {
        //search in users
        $users = $this->search('User', $search, ['first_name', 'last_name']);
        $users = $users ? $this->applyUserFilters($users)
            ->orderBy('first_name')
            ->orderBy('last_name')
            ->with('location')
            ->withCount('followers')
            ->withCount('followings')
            ->get() : null;

        if ($users != null) {
            $users->map(function ($user) {
                if ($user == Auth::user())
                    $user->isFollowedByUser = false;
                else
                    $user->isFollowedByUser = $user->followers->contains(Auth::id());
            });
        }

        if ($users != null)
            return $this->jsonResponse(UserResource::collection($users), 'data', Response::HTTP_OK, 'Users found');

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Users not found');
    }

    //search in trips
    public function searchTrips($search)
    {
        //search in trips
        $trips = $this->search('Trip', $search, ['title', 'description']);
        $trips = $trips ? $trips->whereHas('user', function ($query) {
            $this->applyUserFilters($query);
        })->with('location')->orderBy('created_at', 'desc')->get() : null;

        if ($trips != null)
            return $this->jsonResponse($trips, 'data', Response::HTTP_OK, 'Trips found');

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Trips not found');
    }

    //search in posts
    public function searchPosts($search)
    {
        //search in posts
        $posts = $this->search('Post', $search, ['content']);
        $posts = $posts ? $posts->where('is_deleted', 0)->whereHas('user', function ($query) {
            $this->applyUserFilters($query);
        })->with('location')->with('media')->withCount('comments')->withCount('likes')->orderBy('created_at', 'desc')->get() : null;

        if ($posts != null) {
            $posts->map(function ($post) {
                $post->isLikedByUser = $post->likes->contains(Auth::id());
                $post->user->isFollowedByUser = $post->user->followers->contains(Auth::id());
                //followings count
                $post->user->followings_count = $post->user->followings->count();
                //followers count
                $post->user->followers_count = $post->user->followers->count();
            });
        }

        if ($posts != null)
            return $this->jsonResponse(PostResource::collection($posts), 'data', Response::HTTP_OK, 'Posts found');

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Posts not found');
    }
}