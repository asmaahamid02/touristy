<?php

namespace App\Http\Controllers;

use App\Models\Post;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class PostController extends Controller
{
    use ResponseJson;
    public function index()
    {
        $posts  = Post::where('is_deleted', 0)->get();

        if ($posts->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'No posts found');
        }

        return $this->jsonResponse($posts, 'data', Response::HTTP_OK, 'Posts');
    }

    public function create(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'content' => 'required_without:media|string',
            'tags' => 'nullable|array',
            'tags.*' => 'string',
            'media' => ['required_without:content', function ($attribute, $value, $fail) {
                if (count($value) > 10) {
                    $fail('You can only upload 10 media files at a time');
                }
            }],
            'media.*' => [
                function ($attribute, $value, $fail) {
                    $is_image = Validator::make(
                        ['upload' => $value],
                        ['upload' => 'image|mimes:jpeg,png,jpg']
                    )->passes();

                    $is_video = Validator::make(
                        ['upload' => $value],
                        ['upload' => 'mimetypes:video/avi,video/mpeg,video/quicktime']
                    )->passes();

                    if (!$is_video && !$is_image) {
                        $fail(':attribute must be image (.png, .jpeg, .jpg) or video.');
                    }

                    if ($is_video) {
                        $validator = Validator::make(
                            ['video' => $value],
                            ['video' => "max:102400|duration:0,60"]
                        );
                        if ($validator->fails()) {
                            $fail(":attribute must be 10 megabytes or less and 60 sec or less.");
                        }
                    }

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

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'errors', Response::HTTP_BAD_REQUEST, 'Validation error');
        }
    }

    public function store(Request $request)
    {
        //
    }

    public function show($id)
    {
        //
    }

    public function edit($id)
    {
        //
    }

    public function update(Request $request, $id)
    {
        //
    }

    public function destroy($id)
    {
        //
    }
}