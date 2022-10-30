<?php

namespace App\Http\Controllers;

use App\Models\Group;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class GroupController extends Controller
{
    public function index()
    {
        $groups = Group::orderBy('created_at', 'DESC')->get();

        if ($groups->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'No groups found');
        }

        return $this->jsonResponse($groups, 'data', Response::HTTP_OK, 'Groups');
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