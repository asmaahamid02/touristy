<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Models\UserType;
use App\Traits\MediaTrait;
use App\Traits\NationalityTrait;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\Response;

class UserController extends Controller
{
    use ResponseJson, MediaTrait, NationalityTrait;
    public function index()
    {
        //get all users with nationality
        $users = User::where('is_deleted', 0)->where('id', '!=', Auth::id())->with('nationality')->get();

        if ($users->count() == 0)
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'No Users found');
        // $users = User::where('is_deleted', 0)->wi->get();
        return $this->jsonResponse($users, 'data', Response::HTTP_OK, 'Users');
    }

    public function show($id = null)
    {

        if ($id == null)
            $id = Auth::id();


        $user = User::where('id', $id)->where('is_deleted', 0)->with(['nationality'])->first();

        if (!$user) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'User not found');
        }

        return $this->jsonResponse($user, 'data', Response::HTTP_OK, 'User');
    }

    public function update(Request $request, $id = null)
    {
        if ($id == null)
            $id = Auth::id();

        $user = User::where('id', $id)->where('is_deleted', 0)->first();

        if ($user == null) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'User not found');
        }

        if ($user->id != Auth::id() || ($user->id != Auth::id() && $user->user_type->type != 'admin')) {
            return $this->jsonResponse('', 'errors', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
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
            'nationality' => 'string',
            'country_code' => 'string',
        ]);

        //Send failed response if request is not valid
        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'errors', Response::HTTP_UNPROCESSABLE_ENTITY, 'Validation Error');
        }

        $user->first_name = $request->first_name;
        $user->last_name = $request->last_name;
        $user->gender = $request->gender;
        $user->date_of_birth = $request->date_of_birth;


        if ($request->has('bio')) {
            $user->bio = $request->bio;
        }

        if ($request->has('nationality')) {
            $user->nationality_id = $this->saveNationality($request->nationality, $request->country_code);
        }

        if ($request->has('profile_picture')) {
            $path = $this->saveBase64Image($request->profile_picture, 'profile_pictures' . $user->id);
            $user->profile_picture = $path;
        }

        if ($request->has('cover_picture')) {
            $path = $this->saveBase64Image($request->cover_picture, 'cover_pictures' . $user->id);
            $user->cover_picture = $path;
        }

        $user->save();

        $user->nationality = $user->nationality;
        return $this->jsonResponse($user, 'data', Response::HTTP_OK, 'Profile updated successfully');
    }

    public function deleteAccount($id = null)
    {
        if ($id == null)
            $id = Auth::id();

        $user = User::where('id', $id)->where('is_deleted', 0)->first();

        if ($user == null) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'User not found');
        }

        if ($user->id != Auth::id() || ($user->id != Auth::id() && $user->user_type->type != 'admin')) {
            return $this->jsonResponse('', 'errors', Response::HTTP_UNAUTHORIZED, 'Unauthorized');
        }

        if ($user->user_type->type == 'admin') {
            return $this->jsonResponse('', 'errors', Response::HTTP_UNPROCESSABLE_ENTITY, 'Admin cannot be deleted');
        }

        $user->is_deleted = 1;
        $user->email = $user->email . '_deleted';
        $user->save();

        if ($id == null) {
            Auth::logout();
        }

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'Account deleted successfully');
    }

    //follow/unfollow user
    public function follow($id)
    {
        $user = User::where('id', $id)->where('is_deleted', 0)->first();

        if ($user == null) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'User not found');
        }

        if ($user->id == Auth::id()) {
            return $this->jsonResponse('', 'errors', Response::HTTP_UNPROCESSABLE_ENTITY, 'You cannot follow yourself');
        }

        //check if user is blocked or blocked by me
        if (
            $user->blockings()->where('blocked_user_id', Auth::id())->exists() ||
            $user->blockers()->where('user_id', Auth::id())->exists()
        ) {
            return $this->jsonResponse('', 'errors', Response::HTTP_UNPROCESSABLE_ENTITY, 'You cannot follow this user');
        }

        //check if user is already followed, unfollow it
        if ($user->followers()->where('follower_user_id', Auth::id())->exists()) {
            $user->followers()->detach(Auth::id());
            return $this->jsonResponse('', 'data', Response::HTTP_OK, $user->first_name . ' ' . $user->last_name . ' unfollowed successfully');
        }

        $user->followers()->attach(Auth::id());

        return $this->jsonResponse('', 'data', Response::HTTP_OK,  $user->first_name . ' ' . $user->last_name  . ' followed successfully');
    }

    //block/unblock user
    public function block($id)
    {
        $user = User::where('id', $id)->where('is_deleted', 0)->first();

        if ($user == null) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'User not found');
        }

        if ($user->id == Auth::id()) {
            return $this->jsonResponse('', 'errors', Response::HTTP_UNPROCESSABLE_ENTITY, 'You cannot block yourself');
        }

        //check if user is already blocked, unblock it
        if ($user->blockers()->where('user_id', Auth::id())->exists()) {
            $user->blockers()->detach(Auth::id());
            return $this->jsonResponse('', 'data', Response::HTTP_OK,  $user->first_name . ' ' . $user->last_name  . ' unblocked successfully');
        }

        //check if user is already followed, unfollow it
        if ($user->followers()->where('follower_user_id', Auth::id())->exists()) {
            $user->followers()->detach(Auth::id());
        }

        //check if user following me, unfollow me
        if ($user->followings()->where('followed_user_id', Auth::id())->exists()) {
            $user->followings()->detach(Auth::id());
        }

        //block user    
        $user->blockers()->attach(Auth::id());

        return $this->jsonResponse('', 'data', Response::HTTP_OK,  $user->first_name . ' ' . $user->last_name . ' blocked successfully');
    }

    //get followers
    public function getFollowers($id = null)
    {
        $user = $id ? User::where('id', $id)->where('is_deleted', 0)->first() : Auth::user();

        if ($user == null) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'User not found');
        }

        $followers = $user->followers()->orderBy('created_at', 'DESC')->get();

        if ($followers->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'No followers found');
        }

        return $this->jsonResponse($followers, 'data', Response::HTTP_OK, 'Followers');
    }

    //get followings
    public function getFollowings($id = null)
    {
        $user = $id ? User::where('id', $id)->where('is_deleted', 0)->first() : Auth::user();

        if ($user == null) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'User not found');
        }

        $followings = $user->followings()->orderBy('created_at', 'DESC')->get();

        if ($followings->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'No followings found');
        }

        return $this->jsonResponse($followings, 'data', Response::HTTP_OK, 'Followings');
    }

    //get blocked users
    public function getBlockedUsers($id = null)
    {
        $user = $id ? User::where('id', $id)->where('is_deleted', 0)->first() : Auth::user();

        if ($user == null) {
            return $this->jsonResponse('', 'errors', Response::HTTP_NOT_FOUND, 'User not found');
        }

        $blockedUsers = $user->blockings()->orderBy('created_at', 'DESC')->get();

        if ($blockedUsers->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'No blocked users found');
        }

        return $this->jsonResponse($blockedUsers, 'data', Response::HTTP_OK, 'Blocked users');
    }

    //get unfollowed users
    public function getUnfollowedUsers()
    {
        $user = Auth::user();
        $unfollowedUsers = User::where('id', '!=', $user->id)
            ->where('is_deleted', 0)
            ->whereNotIn('id', $user->followings()->pluck('followed_user_id')->toArray())
            ->whereNotIn('id', $user->blockers()->pluck('user_id')->toArray())
            ->whereNotIn('id', $user->blockings()->pluck('blocked_user_id')->toArray())
            ->inRandomOrder()
            ->get();

        if ($unfollowedUsers->count() == 0) {
            return $this->jsonResponse('', 'data', Response::HTTP_OK, 'No unfollowed users found');
        }

        return $this->jsonResponse($unfollowedUsers->load(['nationality']), 'data', Response::HTTP_OK, 'Unfollowed users');
    }
}