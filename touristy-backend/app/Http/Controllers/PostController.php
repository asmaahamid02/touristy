<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Models\Tag;
use App\Traits\MediaTrait;
use App\Traits\ResponseJson;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class PostController extends Controller
{
    use ResponseJson, MediaTrait;
    public function index()
    {
        $posts  = Post::where('is_deleted', 0)->orderBy('created_at', 'desc')->get();

        if ($posts->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'No posts found');
        }

        return $this->jsonResponse($posts->load(['tags', 'media']), 'data', Response::HTTP_OK, 'Posts');
    }

    public function create(Request $request)
    {
        //validate data
        $validator = Validator::make($request->all(), [
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
                        ['upload' => 'mimetypes:video/avi,video/mpeg,video/quicktime']
                    )->passes();

                    //return error if not image or video
                    if (!$is_video && !$is_image) {
                        $fail(':attribute must be image (.png, .jpeg, .jpg) or video.');
                    }

                    //if video, check if it is less than 10MB, less than 60 sec minutes
                    if ($is_video) {
                        $validator = Validator::make(
                            ['video' => $value],
                            ['video' => "max:102400|duration:0,60"]
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

        //return error if validation fails
        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'errors', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        try {
            //create post
            $post = new Post();
            $user_id = Auth::id();
            $post->user_id = $user_id;

            if ($request->has('content')) {
                $post->content = $request->content;
            }

            $post->publicity = $request->publicity;

            $post->save();

            //save tags
            if ($request->has('tags')) {
                foreach ($request->tags as $tag) {

                    Tag::firstOrCreate(['tag' => $tag])->posts()->attach($post->id);
                }
            }

            //save media
            if ($request->has('media')) {
                foreach ($request->media as $mediaFile) {
                    $mime = $this->getMimeType($mediaFile);

                    if ($mime == 'image') {
                        $post->media()->create([
                            'media_type' => 'image',
                            'media_path' => $this->uploadMedia($mediaFile, 'posts/images/' . $user_id . '/' . $post->id),
                        ]);
                    } else {
                        $post->media()->create([
                            'media_type' => 'video',
                            'media_path' => $this->uploadMedia($mediaFile, 'posts/videos/' . $user_id . '/' . $post->id),
                        ]);
                    }
                }
            }
            return $this->jsonResponse($post->load(['tags', 'media']), 'data', Response::HTTP_CREATED, 'Post created');
        } catch (Exception $error) {

            return $this->jsonResponse($error->getMessage(), 'data', Response::HTTP_INTERNAL_SERVER_ERROR, 'Internal server error');
        }
    }

    public function show($id)
    {
        $post = Post::where('id', $id)->where('is_deleted', 0)->first();

        if (!$post) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Post not found');
        }

        return $this->jsonResponse($post->load(['tags', 'media']), 'data', Response::HTTP_OK, 'Post');
    }

    public function update(Request $request, $id)
    {
        //validate data
        $validator = Validator::make($request->all(), [
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
                        ['upload' => 'mimetypes:video/avi,video/mpeg,video/quicktime']
                    )->passes();

                    //return error if not image or video
                    if (!$is_video && !$is_image) {
                        $fail(':attribute must be image (.png, .jpeg, .jpg) or video.');
                    }

                    //if video, check if it is less than 10MB, less than 60 sec minutes
                    if ($is_video) {
                        $validator = Validator::make(
                            ['video' => $value],
                            ['video' => "max:102400|duration:0,60"]
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

        //return error if validation fails
        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'errors', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        try {
            //get post
            $post = Post::where('id', $id)->where('is_deleted', 0)->first();

            if (!$post) {
                return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Post not found');
            }

            //check if user is owner of post
            if ($post->user_id != Auth::id()) {
                return $this->jsonResponse('', 'data', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
            }

            //update post

            if ($request->has('content')) {
                $post->content = $request->content;
            }

            $post->publicity = $request->publicity;

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

            //delete media to re insert them
            $post->media()->delete();

            //save media
            if ($request->has('media')) {
                foreach ($request->media as $mediaFile) {
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

            return $this->jsonResponse($post->load(['tags', 'media']), 'data', Response::HTTP_OK, 'Post updated');
        } catch (Exception $error) {

            return $this->jsonResponse($error->getMessage(), 'data', Response::HTTP_INTERNAL_SERVER_ERROR, 'Internal server error');
        }
    }

    public function delete($id)
    {
        //
    }

    public function getMimeType($file)
    {
        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mime = finfo_file($finfo, $file);
        $mime = explode('/', $mime)[0];
        finfo_close($finfo);

        return $mime;
    }
}