<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Traits\MediaTrait;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class EventController extends Controller
{
    use ResponseJson, MediaTrait;
    public function index()
    {
        $events = Event::orderBy('created_at', 'desc')->get();

        if ($events->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Events not found');
        }

        return $this->jsonResponse($events, 'data', Response::HTTP_OK, 'Events');
    }

    public function create()
    {
        //
    }

    public function show($id)
    {
        //
    }

    public function update(Request $request, $id)
    {
        //
    }

    public function delete($id)
    {
        //
    }
}