<?php

namespace App\Http\Controllers;

use App\Models\Trip;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class TripController extends Controller
{
    use ResponseJson;
    public function index()
    {
        $trips = Trip::orderBy('created_at', 'desc')->with('user')->with('location')->get();

        if ($trips->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Trips not found');
        }

        return $this->jsonResponse($trips, 'data', Response::HTTP_OK, 'Trips');
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

    public function destroy($id)
    {
        //
    }
}