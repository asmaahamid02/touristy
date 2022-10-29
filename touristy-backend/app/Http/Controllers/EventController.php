<?php

namespace App\Http\Controllers;

use App\Models\Event;
use App\Traits\LocationTrait;
use App\Traits\MediaTrait;
use App\Traits\ResponseJson;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class EventController extends Controller
{
    use ResponseJson, MediaTrait, LocationTrait;
    public function index()
    {
        $events = Event::orderBy('created_at', 'desc')->get();

        if ($events->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Events not found');
        }

        return $this->jsonResponse($events, 'data', Response::HTTP_OK, 'Events');
    }

    public function create(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string',
            'description' => 'required|string',
            'start_date' => 'required|date|after_or_equal:now',
            'end_date' => 'date|after_or_equal:start_date',
            'image' => 'base64image',
            'longitude' => 'required|numeric',
            'latitude' => 'required|numeric',
            'city' => 'required|string',
            'country' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        $location_id = $this->saveLocation($request->latitude, $request->longitude, $request->city, $request->country);

        $event = new Event();

        $event->user_id = Auth::id();
        $event->location_id = $location_id;
        $event->name = $request->name;
        $event->description = $request->description;
        $event->start_date = $request->start_date;
        $event->end_date = $request->end_date;

        if ($request->has('image')) {
            $event->image = $this->saveBase64Image($request->image, 'events' . DIRECTORY_SEPARATOR . Auth::id());
        }

        $event->save();

        return $this->jsonResponse($event, 'data', Response::HTTP_CREATED, 'Event created');
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