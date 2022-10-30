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
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_UNPROCESSABLE_ENTITY, 'Validation error');
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
        $group = Group::find($id);

        if (!$group) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Group not found');
        }

        return $this->jsonResponse($group, 'data', Response::HTTP_OK, 'Group');
    }

    public function update(Request $request, $id)
    {
        $group = Group::find($id);

        if (!$group) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Group not found');
        }

        if ($group->creator_id != Auth::id()) {
            return $this->jsonResponse('', 'data', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
        }

        $validator = Validator::make($request->all(), [
            'name' => 'string|unique:groups,name,' . $group->id,
            'description' => 'string',
            'image' => 'base64image',
        ]);

        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_UNPROCESSABLE_ENTITY, 'Validation error');
        }

        if ($request->has('name') && $request->name != $group->name && $request->name != null) {
            $group->name = $request->name;
        }

        if ($request->has('description') && $request->description != $group->description && $request->description != null) {
            $group->description = $request->description;
        }

        if ($request->has('image') && $request->image != $group->image && $request->image != null) {
            $this->deleteMedia($group->image);
            $this->deleteEmptyFolders($group->image);
            $group->image = $this->saveBase64Image($request->image, 'groups');
        }

        $group->save();

        return $this->jsonResponse($group, 'data', Response::HTTP_OK, 'Group updated');
    }

    public function delete($id)
    {
        $group = Group::find($id);

        if (!$group) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Group not found');
        }

        if ($group->creator_id != Auth::id()) {
            return $this->jsonResponse('', 'data', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
        }

        $this->deleteMedia($group->image);
        $this->deleteEmptyFolders($group->image);
        $group->delete();

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Group deleted');
    }

    public function joinGroup($id)
    {
        $group = Group::find($id);

        if (!$group) {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'Group not found');
        }

        if ($group->creator_id == Auth::id()) {
            return $this->jsonResponse('', 'data', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
        }

        if ($group->users->contains(Auth::id())) {
            $group->users()->detach(Auth::id());
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'You left the group');
        }

        $group->users()->attach(Auth::id());

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Joined group');
    }
}