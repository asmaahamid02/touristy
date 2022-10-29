<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserType;
use App\Traits\MediaTrait;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;
use JWTAuth;

class AuthController extends Controller
{
    use ResponseJson, MediaTrait;
    public function register(Request $request)
    {
        //Validate data
        $validator = Validator::make($request->all(), [
            'first_name' => 'required|string',
            'last_name' => 'required|string',
            'email' => 'required|email|unique:users',
            'password' => 'required|string|min:6|max:50',
            'gender' => 'required|string',
            'date_of_birth' => 'required|date',
            'profile_picture' => 'nullable|base64image',
            'role' => 'required|string',
        ]);

        //Send failed response if request is not valid
        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_UNPROCESSABLE_ENTITY, 'Validation Error');
        }

        //Request is valid, create new user
        $user = new User();

        $user_type = UserType::where('type', $request->role)->first();
        if ($user_type) {
            $user->user_type_id = $user_type->id;
        } else {
            return $this->jsonResponse('', 'data', Response::HTTP_UNPROCESSABLE_ENTITY, 'Role not found');
        }

        $user->first_name = $request->first_name;
        $user->last_name = $request->last_name;
        $user->email = $request->email;
        $user->password = bcrypt($request->password);
        $user->gender = $request->gender;
        $user->date_of_birth = $request->date_of_birth;
        $user->save();

        if ($request->has('profile_picture')) {
            $path = $this->saveBase64Image($request->profile_picture, 'profile_pictures/' . $user->id);
            $user->profile_picture = $path;
            $user->save();
        }

        //User created, return success response
        return $this->login($request);
        // return $this->jsonResponse($user, 'data', Response::HTTP_CREATED, 'User created successfully');
    }

    public function login(Request $request)
    {
        $credentials = $request->only('email', 'password');

        //valid credential
        $validator = Validator::make($credentials, [
            'email' => 'required|email',
            'password' => 'required|string|min:6|max:50'
        ]);

        //Send failed response if request is not valid
        if ($validator->fails()) {
            return $this->jsonResponse($validator->errors(), 'data', Response::HTTP_UNPROCESSABLE_ENTITY, 'Validation Error');
        }

        //Request is validated
        //Crean token
        try {
            if (!$token = JWTAuth::attempt($credentials)) {
                return $this->jsonResponse('', 'data', Response::HTTP_BAD_REQUEST, 'Invalid email or password');
            }
        } catch (JWTException $e) {
            return $credentials;
            return $this->jsonResponse('', 'data', Response::HTTP_INTERNAL_SERVER_ERROR, 'Could not create token');
        }

        //Token created, return with success response and jwt token
        return $this->jsonResponse(['token' => $token], 'data', Response::HTTP_OK, 'Login successful');
    }

    public function me()
    {
        $user = auth()->user();
        return $this->jsonResponse($user, 'data', Response::HTTP_OK, 'User data');
    }

    public function refresh()
    {
        $token = auth()->refresh();
        return $this->jsonResponse(['token' => $token], 'data', Response::HTTP_OK, 'Token refreshed successfully');
    }

    public function logout()
    {
        auth()->logout();

        return $this->jsonResponse('', 'data', Response::HTTP_OK, 'User logged out successfully');
    }
}