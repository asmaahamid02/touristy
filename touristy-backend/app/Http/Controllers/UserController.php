<?php

namespace App\Http\Controllers;

use App\Models\User;
use App\Traits\ResponseJson;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class UserController extends Controller
{
    use ResponseJson;
    public function index()
    {
        $users = User::all();
        return $this->jsonResponse($users, 'data', Response::HTTP_OK, 'Users');
    }

    public function show($id)
    {
        $user = User::find($id)->first();
        if ($user) {
            return $this->jsonResponse($user, 'data', Response::HTTP_OK, 'User');
        } else {
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'User not found');
        }
    }

    public function update(Request $request, $id)
    {
        //
    }

    public function delete($id)
    {
        //
    }
}