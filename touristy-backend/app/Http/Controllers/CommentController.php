<?php

namespace App\Http\Controllers;

use App\Models\Comment;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class CommentController extends Controller
{
    use ResponseJson;
    public function create(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'content' => 'required|string',
            'post_id' => 'required|integer',
            'comment_id' => 'nullable|integer',
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        $comment = new Comment();
        $comment->user_id = Auth::id();
        $comment->post_id = $request->post_id;
        $comment->content = $request->content;

        if ($request->has('comment_id')) {
            $comment->comment_id = $request->comment_id;
        }

        $comment->save();

        return $this->jsonResponse($comment, 'data', Response::HTTP_CREATED, 'Comment created');
    }

    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'content' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        $comment = Comment::find($id)->first();

        if (!$comment) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Comment not found');
        }

        if ($comment->user_id != Auth::id()) {
            return $this->jsonResponse('', 'data', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
        }

        $comment->content = $request->content;
        $comment->save();

        return $this->jsonResponse($comment, 'data', Response::HTTP_OK, 'Comment updated');
    }

    public function delete($id)
    {
        //
    }
}