<?php

namespace App\Http\Controllers;

use App\Http\Resources\PostResource;
use App\Http\Resources\UserResource;
use App\Models\Post;
use App\Models\Tag;
use App\Traits\LocationTrait;
use App\Traits\MediaTrait;
use App\Traits\ResponseJson;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class PostController extends Controller
{
    use ResponseJson, MediaTrait, LocationTrait;
    public function index()
    {
        $posts  = Post::where('is_deleted', 0)->whereHas('user', function ($query) {
            $query->where('is_deleted', 0)
                // ->where('id', '!=', Auth::id())
                //remove blocked users
                ->whereDoesntHave('blockings', function ($query) {
                    $query->where('blocked_user_id', Auth::id());
                })
                //remove blocked by users
                ->whereDoesntHave('blockers', function ($query) {
                    $query->where('user_id', Auth::id());
                });
        })
            ->with('user.nationality')
            ->with('location')
            ->with('tags', function ($query) {
                return $query->select('tags.id', 'tag');
            })
            ->withCount('comments', 'likes')            
            ->with('media')
            ->orderBy('created_at', 'desc')->paginate(10);

        if ($posts->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'No posts found');
        }

        //add isLikedByUser to each post
        foreach ($posts as $post) {
            $post->isLikedByUser = $post->likes->contains('user_id', Auth::id());
        }

        //add isFollowedByUser to each post
        foreach ($posts as $post) {
            $post->user->isFollowedByUser = $post->user->followers->contains(Auth::id());
        }

        return $this->jsonResponse(PostResource::collection($posts), 'data', Response::HTTP_OK, 'Posts');
    }

    public function create(Request $request)
    {
        //validate data
        $validator = $this->validateData($request);

        //return error if validation fails
        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'errors', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        try {
            //create post
            $postData = array();
            $user_id = Auth::id();

            $postData['user_id'] = $user_id;

            if ($request->has('content')) {
                $postData['content'] = $request->content;
            }

            if ($request->has('latitude') && $request->has('longitude') && $request->has('address')) {
                $postData['location_id'] = $this->saveLocation($request->latitude, $request->longitude, $request->address);
                $postData['address'] = $request->address;
            }

            $postData['publicity'] = $request->publicity;

            $post = Post::create($postData);

            //save tags
            if ($request->has('tags')) {
                foreach ($request->tags as $tag) {

                    Tag::firstOrCreate(['tag' => $tag])->posts()->attach($post->id);
                }
            }

            //save media
            if ($request->has('media')) {
                $this->saveMedia($request->media, $post);
            }

            return $this->jsonResponse(new PostResource($post->load(['media', 'user.nationality', 'location', 'tags'])), 'data', Response::HTTP_OK, 'Post created');
        } catch (Exception $error) {

            return $this->jsonResponse($error->getMessage(), 'errors', Response::HTTP_INTERNAL_SERVER_ERROR, 'Internal server error');
        }
    }

    public function show($id)
    {
        $post = Post::where('id', $id)->where('is_deleted', 0)->first();

        if (!$post) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'Post not found');
        }

        return $this->jsonResponse($post->load(['tags', 'media', 'user', 'likes', 'comments']), 'data', Response::HTTP_OK, 'Post');
    }

    public function update(Request $request, $id)
    {
        //validate data
        $validator = $this->validateData($request);

        //return error if validation fails
        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'errors', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        try {
            //get post
            $post = Post::where('id', $id)->where('is_deleted', 0)->with('user.nationality')
                ->with('location')
                ->with('tags', function ($query) {
                    return $query->select('tags.id', 'tag');
                })
                ->withCount('comments', 'likes')
                ->with('likes', function ($query) {
                    return $query->where('user_id', Auth::id())->select('user_id', 'post_id')->get();
                })
                ->with('media')->first();

            if (!$post) {
                return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'Post not found');
            }

            //check if user is owner of post
            if ($post->user_id != Auth::id()) {
                return $this->jsonResponse('', 'errors', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
            }

            //update post

            if ($request->has('content')) {
                $post->content = $request->content;
            }

            if ($request->has('publicity')) {
                $post->publicity = $request->publicity;
            }

            if ($request->has('latitude') && $request->has('longitude') && $request->has('address')) {
                $post->location_id = $this->saveLocation($request->latitude, $request->longitude, $request->address);
            }

            $post->save();

            //save tags
            if ($request->has('tags')) {
                $post->tags()->detach();
                foreach ($request->tags as $tag) {

                    Tag::firstOrCreate(['tag' => $tag]);
                }

                $tags = Tag::whereIn('tag', $request->tags)->get()->pluck('id'); //->get();                
                $post->tags()->sync($tags);
            }

            //save media
            if ($request->has('media')) {
                //delete media to re insert them
                $post->media()->delete();
                $this->saveMedia($request->media, $post);
            }

            return $this->jsonResponse(new PostResource($post), 'data', Response::HTTP_OK, 'Post updated');
        } catch (Exception $error) {

            return $this->jsonResponse($error->getMessage(), 'errors', Response::HTTP_INTERNAL_SERVER_ERROR, 'Internal server error');
        }
    }

    public function delete($id)
    {
        try {
            //get post
            $post = Post::where('id', $id)->where('is_deleted', 0)->first();

            if (!$post) {
                return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'Post not found');
            }

            //check if user is owner of post
            if ($post->user_id != Auth::id()) {
                return $this->jsonResponse('', 'errors', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
            }

            $post->is_deleted = 1;
            $post->save();
            $post->media()->delete();

            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Post deleted');
        } catch (Exception $error) {
            return $this->jsonResponse($error->getMessage(), 'errors', Response::HTTP_INTERNAL_SERVER_ERROR, 'Internal server error');
        }
    }

    public function saveMedia($media, $post)
    {
        foreach ($media as $mediaFile) {
            $mime = $this->getMimeType($mediaFile);

            if ($mime == 'image') {
                $post->media()->create([
                    'media_type' => 'image',
                    'media_path' => $this->uploadMedia($mediaFile, 'posts/images/' . $post->user_id . '/' . $post->id),
                ]);
            } else {
                $post->media()->create([
                    'media_type' => 'video',
                    'media_path' => $this->uploadMedia($mediaFile, 'posts/videos/' . $post->user_id . '/' . $post->id),
                ]);
            }
        }
    }

    //like post
    public function like($id)
    {
        //get post
        $post = Post::where('id', $id)->where('is_deleted', 0)->first();

        if (!$post) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'Post not found');
        }

        //check if user already liked post
        if ($post->likes()->where('user_id', Auth::id())->exists()) {
            //if user already liked post, unlike it
            $post->likes()->detach(Auth::id());
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Post unliked');
        }

        $post->likes()->attach(Auth::id());
        return $this->jsonResponse($post->likes()->count(), 'data', Response::HTTP_OK, 'Post liked');
    }

    //get post of following users
    public function getFollowingPosts()
    {
        $posts =  Post::where('is_deleted', 0)->whereHas('user', function ($query) {
            $query->where('is_deleted', 0)
                ->where('id', '!=', Auth::id())
                //remove blocked users
                ->whereDoesntHave('blockings', function ($query) {
                    $query->where('blocked_user_id', Auth::id());
                })
                //remove blocked by users
                ->whereDoesntHave('blockers', function ($query) {
                    $query->where('user_id', Auth::id());
                })
                ->whereHas('followers', function ($query) {
                    $query->where('follower_user_id', Auth::id());
                });
        })
            ->with('user.nationality')
            ->with('location')
            ->with('tags', function ($query) {
                return $query->select('tags.id', 'tag');
            })
            ->withCount('comments', 'likes')
        
            ->with('media')
            ->orderBy('created_at', 'desc')->paginate(10);

        if ($posts->isEmpty()) {
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'No posts found');
        }

        //add isLikedByUser to each post

        foreach ($posts as $post) {
            $post->isLikedByUser = $post->likes->contains('user_id', Auth::id());
        }


        //add isFollowedByUser to each post
        foreach ($posts as $post) {
            $post->user->isFollowedByUser = $post->user->followers->contains(Auth::id());
        }


        return $this->jsonResponse(PostResource::collection($posts), 'data', Response::HTTP_OK, 'Posts found');
    }

    //validate data for creating and updating posts
    public function validateData(Request $request)
    {
        return Validator::make($request->all(), [
            'content' => 'required_without:media|string',
            'tags' => 'nullable|array',
            'tags.*' => 'string',
            'media' => 'required_without:content|between:1,10|array',
            'media.*' => [
                function ($attribute, $value, $fail) {
                    //check if is it image
                    $is_image = Validator::make(
                        ['upload' => $value],
                        ['upload' => 'image|mimes:jpeg,png,jpg']
                    )->passes();

                    //check if is it video
                    $is_video = Validator::make(
                        ['upload' => $value],
                        ['upload' => 'mimetypes:video/avi,video/mpeg,video/quicktime,video/mp4']
                    )->passes();

                    //return error if not image or video
                    if (!$is_video && !$is_image) {
                        $fail(':attribute must be image (.png, .jpeg, .jpg) or video.');
                    }

                    //if video, check if it is less than 10MB, less than 60 sec minutes
                    if ($is_video) {
                        $validator = Validator::make(
                            ['video' => $value],
                            ['video' => "max:102400"]
                        );
                        if ($validator->fails()) {
                            $fail(":attribute must be 10 megabytes or less and 60 sec or less.");
                        }
                    }

                    //if image, check if it is less than 2MB
                    if ($is_image) {
                        $validator = Validator::make(
                            ['image' => $value],
                            ['image' => "max:2048"]
                        );
                        if ($validator->fails()) {
                            $fail(":attribute must be two megabytes or less.");
                        }
                    }
                },
            ],
            'publicity' => 'required|string|in:public,followers',
        ]);
    }

    //get user posts
    public function getUserPosts($id)
    {
        $posts = Post::where('user_id', $id)
        ->where('is_deleted', 0)
        ->with('user.nationality')
        ->with('user.location')
        ->with('location')
        ->withCount('comments', 'likes')
        ->with('media')
        ->orderBy('created_at', 'desc')->get();

        if ($posts->isEmpty()) {
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'No posts found');
        }

        $posts->map(function($post){
            $post->isLikedByUser = $post->likes->contains(Auth::id());
            $post->user->isFollowedByUser = $post->user->followers->contains(Auth::id());
          
        });   
        


        return $this->jsonResponse(PostResource::collection($posts), 'data', Response::HTTP_OK, 'Posts found');

    }
}