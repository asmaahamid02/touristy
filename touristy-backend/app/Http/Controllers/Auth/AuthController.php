<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserType;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;
use Symfony\Component\HttpFoundation\Response;
use JWTAuth;

class AuthController extends Controller
{
    use ResponseJson;
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


        if ($request->has('profile_picture')) {
            $base64Image = $request->profile_picture;

            //split the base64URL from the image data
            @list($type, $fileData) = explode(';', $base64Image);
            //get the file extension
            @list(, $extension) = explode('/', $type);
            //get the file data
            @list(, $fileData) = explode(',', $fileData);
            //specify the full image name
            $imageName = rand(100000, 999999) . time() . '.' . $extension;
            //save the image to the specified path

            $path = 'profiles/' . time() . '/' . $imageName;
            Storage::put($path, base64_decode($fileData));

            $user->profile_picture = $path;
        }

        $user->save();

        //User created, return success response

        return $this->jsonResponse($user, 'data', Response::HTTP_CREATED, 'User created successfully');
    }
}