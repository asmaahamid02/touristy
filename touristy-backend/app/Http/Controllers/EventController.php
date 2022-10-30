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
        $event = Event::find($id)->with('user')->with('location')->first();

        if (!$event) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Event not found');
        }

        return $this->jsonResponse($event, 'data', Response::HTTP_OK, 'Event');
    }

    public function update(Request $request, $id)
    {
        $event = Event::find($id)->with('user')->with('location')->first();

        if (!$event) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Event not found');
        }

        if ($event->user_id != Auth::id()) {
            return $this->jsonResponse('', 'data', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
        }

        $validator = Validator::make($request->all(), [
            'name' => 'string',
            'description' => 'string',
            'start_date' => 'date|after_or_equal:now',
            'end_date' => 'date|after_or_equal:start_date',
            'image' => 'base64image',
            'longitude' => 'numeric',
            'latitude' => 'numeric',
            'city' => 'string',
            'country' => 'string',
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        if ($request->has('name')) {
            $event->name = $request->name;
        }

        if ($request->has('description')) {
            $event->description = $request->description;
        }

        if ($request->has('start_date')) {
            $event->start_date = $request->start_date;
        }

        if ($request->has('end_date')) {
            $event->end_date = $request->end_date;
        }

        if ($request->has('image')) {
            // Delete old image
            if ($event->image) {
                $this->deleteMedia($event->image);
            }

            $event->image = $this->saveBase64Image($request->image, 'events' . DIRECTORY_SEPARATOR . Auth::id());
        }

        if ($request->has('longitude') && $request->has('latitude') && $request->has('city') && $request->has('country')) {
            $location_id = $this->saveLocation($request->latitude, $request->longitude, $request->city, $request->country);
            $event->location_id = $location_id;
        }

        $event->save();

        return $this->jsonResponse($event, 'data', Response::HTTP_OK, 'Event updated');
    }

    public function delete($id)
    {
        $event = Event::find($id);

        if (!$event) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Event not found');
        }

        if ($event->user_id != Auth::id()) {
            return $this->jsonResponse('', 'data', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
        }

        // Delete old image
        if ($event->image) {
            $this->deleteMedia($event->image);
        }

        $event->delete();

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Event deleted');
    }

    public function interestInEvent($id)
    {
        $user_id = Auth::id();

        $event = Event::where('id', $id)->where('user_id', '!=', $user_id)->first();

        if (!$event) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Event not found');
        }

        if ($event->interested_users()->where('user_id', $user_id)->first()) {
            $event->interested_users()->detach($user_id);

            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Event removed from interested events');
        }

        $event->interested_users()->attach($user_id);

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Event added to your interested events');
    }

    public function getInterestedEvents($id = null)
    {
        $user_id = $id ? $id : Auth::id();

        $events = Event::whereHas('interested_users', function ($query) use ($user_id) {
            $query->where('user_id', $user_id);
        })->with('user')->with('location')->get();


        if ($events->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'No events found');
        }

        return $this->jsonResponse($events, 'data', Response::HTTP_OK, 'Events');
    }

    public function joinEvent($id)
    {
        $user_id = Auth::id();

        $event = Event::where('id', $id)->where('user_id', '!=', $user_id)->first();

        if (!$event) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Event not found');
        }

        if ($event->joined_users()->where('user_id', $user_id)->first()) {
            $event->joined_users()->detach($user_id);

            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Event removed from joined events');
        }

        $event->joined_users()->attach($user_id);

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Event added to your joined events');
    }

    public function getJoinedEvents($id = null)
    {
        $user_id = $id ? $id : Auth::id();

        $events = Event::whereHas('joined_users', function ($query) use ($user_id) {
            $query->where('user_id', $user_id);
        })->with('user')->with('location')->get();

        if ($events->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'No events found');
        }

        return $this->jsonResponse($events, 'data', Response::HTTP_OK, 'Events');
    }

    public function getEventsByUser($id = null)
    {
        $user_id = $id ? $id : Auth::id();
        $events = Event::where('user_id', $user_id)->with('location')->get();

        if ($events->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'No events found');
        }

        return $this->jsonResponse($events, 'data', Response::HTTP_OK, 'Events');
    }

    //get random events
    public function getRandomEvents()
    {
        $events = Event::where('user_id', '!=', Auth::id())->whereHas('user', function ($query) {
            $query->where('id', '!=', Auth::id())
                //remove blocked users
                ->whereDoesntHave('blockings', function ($query) {
                    $query->where('blocked_user_id', Auth::id());
                })
                //remove blocked by users
                ->whereDoesntHave('blockers', function ($query) {
                    $query->where('user_id', Auth::id());
                });
        })
            //remove events that are already joined
            ->whereDoesntHave('joined_users', function ($query) {
                $query->where('user_id', Auth::id());
            })

            //remove events that are already interested
            ->whereDoesntHave('interested_users', function ($query) {
                $query->where('user_id', Auth::id());
            })

            ->with('user')->with('location')->inRandomOrder()->limit(10)->get();

        if ($events->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'No events found');
        }

        return $this->jsonResponse($events, 'data', Response::HTTP_OK, 'Events');
    }
}