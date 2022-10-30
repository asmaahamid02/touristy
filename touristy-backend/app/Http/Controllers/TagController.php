<?php

namespace App\Http\Controllers;

use App\Models\Tag;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class TagController extends Controller
{
    use ResponseJson;
    //get tags with their count of posts order by count of posts

    public function index($limit = null)
    {
        $tags = Tag::withCount('posts')->orderBy('posts_count', 'desc')->orderBy('tag', 'asc');

        if ($limit != null)
            $tags = $tags->limit($limit);

        $tags = $tags->get();

        if ($tags->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'No tags found');
        }

        return $this->jsonResponse($tags, 'data', Response::HTTP_OK, 'Tags');
    }
}