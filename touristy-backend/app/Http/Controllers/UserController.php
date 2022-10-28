<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Traits\MediaTrait;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\Response;

class UserController extends Controller
{
    use ResponseJson, MediaTrait;
    public function index()
    {
        $users = User::where('is_deleted', 0)->get();
        return $this->jsonResponse($users, 'data', Response::HTTP_OK, 'Users');
    }

    public function show($id = null)
    {
        if ($id == null) {
            $user = Auth::user();
        } else {
            $user = User::where('id', $id)->where('is_deleted', 0)->first();

            if (!$user) {
                return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'User not found');
            }
        }

        return $this->jsonResponse($user, 'data', Response::HTTP_OK, 'User');
    }

    public function update(Request $request, $id = null)
    {
        if ($id == null) {
            $user = Auth::user();
        } else {
            $user = User::where('id', $id)->where('is_deleted', 0)->first();

            if ($user == null) {
                return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'User not found');
            }
        }

        //Validate data
        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'gender' => 'required|string|in:male,female,other',
            'date_of_birth' => 'required|date',
            'profile_picture' => 'nullable|base64image',
            'cover_picture' => 'nullable|base64image',
            'bio' => 'string|max:150',
        ]);

        //Send failed response if request is not valid
        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_UNPROCESSABLE_ENTITY, 'Validation Error');
        }

        $user->first_name = $request->first_name;
        $user->last_name = $request->last_name;
        $user->gender = $request->gender;
        $user->date_of_birth = $request->date_of_birth;


        if ($request->has('bio')) {
            $user->bio = $request->bio;
        }

        if ($request->has('profile_picture')) {
            $path = $this->saveBase64Image($request->profile_picture, 'profile_pictures');
            $user->profile_picture = $path;
        }

        if ($request->has('cover_picture')) {
            $path = $this->saveBase64Image($request->cover_picture, 'cover_pictures');
            $user->cover_picture = $path;
        }

        $user->save();

        return $this->jsonResponse($user, 'data', Response::HTTP_OK, 'Profile updated successfully');
    }

    public function deleteAccount($id = null)
    {
        if ($id == null) {
            $user = Auth::user();
        } else {
            $user = User::where('id', $id)->where('is_deleted', 0)->first();

            if ($user == null) {
                return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'User not found');
            }

            if ($user->user_type->type == 'admin') {
                return $this->jsonResponse('', 'data', Response::HTTP_UNPROCESSABLE_ENTITY, 'Admin cannot be deleted');
            }
        }

        $user->is_deleted = 1;
        $user->email = $user->email . '_deleted';
        $user->save();

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Account deleted successfully');
    }
}