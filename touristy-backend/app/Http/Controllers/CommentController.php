<?php

namespace App\Http\Controllers;

use App\Http\Resources\CommentResource;
use App\Models\Comment;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

use function PHPSTORM_META\map;

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

        $commentData = array();
        $commentData['user_id'] = Auth::id();
        $commentData['post_id'] = $request->post_id;
        $commentData['content'] = $request->content;


        if ($request->has('comment_id')) {
            $commentData['comment_id'] = $request->comment_id;
        }

        $comment = Comment::create($commentData);

        $comment->user = $comment->user;
        return $this->jsonResponse(new CommentResource($comment), 'data', Response::HTTP_OK, 'Comment created');
    }

    public function update(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'content' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        $comment = Comment::find($id);

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
        $comment = Comment::find($id);

        if (!$comment) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Comment not found');
        }

        if ($comment->user_id != Auth::id()) {
            return $this->jsonResponse('', 'data', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
        }

        $comment->delete();

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Comment deleted');
    }

    public function getCommentsByPost($post_id)
    {
        $comments = Comment::where('post_id', $post_id)->with('user')->with('replies')->withCount('likes')->orderBy('created_at', 'DESC')->get();

        if ($comments->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Comments not found');
        }

        foreach ($comments as $comment) {
            $comment->isLiked = $comment->likes->contains('user_id', Auth::id());
        }

        return $this->jsonResponse(CommentResource::collection($comments), 'data', Response::HTTP_OK, 'Comments');
    }

    //like comment or unlike comment
    public function like($id)
    {
        $comment = Comment::find($id);

        if (!$comment) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Comment not found');
        }

        $comment->likes()->toggle(Auth::id());

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Success');
    }
}