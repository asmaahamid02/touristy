<?php

namespace App\Http\Controllers;

use App\Models\Location;
use App\Models\Trip;
use App\Traits\LocationTrait;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class TripController extends Controller
{
    use ResponseJson, LocationTrait;
    public function index()
    {
        $trips = Trip::orderBy('created_at', 'desc')->with('user')->with('location')->get();

        if ($trips->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Trips not found');
        }

        return $this->jsonResponse($trips, 'data', Response::HTTP_OK, 'Trips');
    }

    public function create(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'title' => 'required|string',
            'description' => 'required|string',
            'departure_date' => 'nullable|date|after_or_equal:' . date('Y-m-d'),
            'arrival_date' => 'nullable|date|after:departure_date',            
            'longitude' => 'required|numeric',
            'latitude' => 'required|numeric',
            'address' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        $tripData['location_id'] = $this->saveLocation($request->latitude, $request->longitude, $request->address);
        if ($request->has('departure_date')) {
            $tripData['departure_date'] = $request->departure_date;
        }

        if(!$request->has('arrival_date') && !$request->has('departure_date')) {
            $tripData['is_past'] = 1;
        }

        $trip = Trip::create([
            'user_id' =>  Auth::user()->id,
            'location_id' => $tripData['location_id'],
            'title' => $request->title,
            'description' => $request->description,
            'arrival_date' => $request->arrival_date,
            'departure_date' => $tripData['departure_date'] ?? null,
            'is_past' => $tripData['is_past'] ?? 0,
        ]);

        return $this->jsonResponse($trip->load(['location']), 'data', Response::HTTP_CREATED, 'Trip created');
    }

    public function show($id)
    {
        $trip = Trip::where('id', $id)->with('user')->with('location')->first();

        if (!$trip) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Trip not found');
        }

        return $this->jsonResponse($trip, 'data', Response::HTTP_OK, 'Trip');
    }

    public function update(Request $request, $id)
    {
        $trip = Trip::where('id', $id)->first();

        if (!$trip) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Trip not found');
        }

        $validator = Validator::make($request->all(), [
            'title' => 'required|string',
            'description' => 'required|string',
            'arrival_date' => 'required_without:is_past|date|after_or_equal:' . date('Y-m-d'),
            'departure_date' => 'required_without:is_past|date|after:arrival_date',
            'is_past' => 'required_without_all:arrival_date,departure_date|date|before:' . date('Y-m-d'),
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        $trip->title = $request->title;
        $trip->description = $request->description;

        if ($request->has('is_past')) {
            $trip->is_past = $request->is_past;
        } else {
            $trip->arrival_date = $request->arrival_date;
            $trip->departure_date = $request->departure_date;
        }

        $trip->save();

        return $this->jsonResponse($trip->load(['location']), 'data', Response::HTTP_OK, 'Trip updated');
    }

    public function delete($id)
    {
        $trip = Trip::where('id', $id)->first();

        if (!$trip) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Trip not found');
        }

        $trip->delete();

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Trip deleted');
    }

    public function getTripsByUser($id)
    {
        $trips = Trip::where('user_id', $id)->orderBy('created_at', 'desc')->with('user')->with('location')->get();

        if ($trips->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Trips not found');
        }

        return $this->jsonResponse($trips, 'data', Response::HTTP_OK, 'Trips');
    }

    public function getTripsByLocation($id)
    {
        $trips = Trip::where('location_id', $id)->orderBy('created_at', 'desc')->with('user')->with('location')->get();

        if ($trips->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Trips not found');
        }

        return $this->jsonResponse($trips, 'data', Response::HTTP_OK, 'Trips');
    }

    //get random trips
    public function getRandomTrips()
    {
        $trips =  Trip::where('user_id', '!=', Auth::id())
            //remove trips from blocked users
            ->whereDoesntHave('user.blockings', function ($query) {
                $query->where('blocked_user_id', Auth::id());
            })
            //remove trips from blocked by users
            ->whereDoesntHave('user.blockers', function ($query) {
                $query->where('user_id', Auth::id());
            })
            ->inRandomOrder()
            ->with('user')
            ->with('location')
            ->limit(10)
            ->get();

        if ($trips->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Trips not found');
        }

        return $this->jsonResponse($trips, 'data', Response::HTTP_OK, 'Trips');
    }


//get trips grouped by locations
    public function getTripsGroupedByLocations()
    {
        $trips =  Trip::where('user_id', '!=', Auth::id())
            //remove trips from blocked users
            ->whereDoesntHave('user.blockings', function ($query) {
                $query->where('blocked_user_id', Auth::id());
            })
            //remove trips from blocked by users
            ->whereDoesntHave('user.blockers', function ($query) {
                $query->where('user_id', Auth::id());
            })   
            ->with('location')    
            ->get();

        if ($trips->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Trips not found');
        }

        //grouped by approximate longitude and latitude
    
        $groupedTrips = $trips->groupBy(function ($item, $key) {            
            return round($item->location->latitude, 1) . ';' . round($item->location->longitude, 1);

        });

        //add count trips in each group and trips ids
        $groupedTrips = $groupedTrips->map(function ($item, $key) {
            return [
                'count' => $item->count(),
                'ids' => $item->pluck('id'),                
                'latitude' => $item->first()->location->latitude,        
                'longitude' => $item->first()->location->longitude,
            ];
        });

        //change keys to numbers
        $groupedTrips = $groupedTrips->values();
                
        return $this->jsonResponse($groupedTrips, 'data', Response::HTTP_OK, 'Trips');
    }
    
    //get trips by ids
    public function getTripsByIds(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'ids' => 'required|array',
            'ids.*' => 'required|integer',
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_BAD_REQUEST, 'Validation error');
        }

        $trips =  Trip::whereIn('id', $request->ids)
            ->with('user')
            ->with('location')
            ->get();

        if ($trips->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Trips not found');
        }

        return $this->jsonResponse($trips, 'data', Response::HTTP_OK, 'Trips');
    }




}