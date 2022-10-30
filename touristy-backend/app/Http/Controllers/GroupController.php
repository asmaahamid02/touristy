<?php

namespace App\Http\Controllers;

use App\Models\Group;
use App\Traits\MediaTrait;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;

class GroupController extends Controller
{
    use ResponseJson, MediaTrait;
    public function index()
    {
        $groups = Group::orderBy('created_at', 'DESC')->get();

        if ($groups->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'No groups found');
        }

        return $this->jsonResponse($groups, 'data', Response::HTTP_OK, 'Groups');
    }

    public function create(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'name' => 'required|string|unique:groups',
            'description' => 'required|string',
            'image' => 'required|base64image',
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'errors', Response::HTTP_UNPROCESSABLE_ENTITY, 'Validation error');
        }

        $group = new Group();
        $group->name = $request->name;
        $group->description = $request->description;
        $group->image = $this->saveBase64Image($request->image, 'groups');
        $group->creator_id = Auth::id();
        $group->save();

        return $this->jsonResponse($group, 'data', Response::HTTP_CREATED, 'Group created');
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