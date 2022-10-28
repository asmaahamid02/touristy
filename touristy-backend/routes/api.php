<?php

use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::group(['prefix' => 'v0.1'], function () {
    Route::group(['prefix' => 'auth'], function () {
        Route::post('/register', [AuthController::class, 'register']);
        Route::post('/login', [AuthController::class, 'login']);

        Route::group(['middleware' => ['jwt.verify']], function () {
            Route::get('/me', [AuthController::class, 'me']);
            Route::get('/refresh', [AuthController::class, 'refresh']);
            Route::get('/logout', [AuthController::class, 'logout']);
        });
    });

    Route::group(['middleware' => ['jwt.verify']], function () {
        Route::group(['prefix' => 'users'], function () {
            Route::get('/', [UserController::class, 'index']);
            Route::get('/user/{id?}', [UserController::class, 'show']);
            Route::put('/{id?}', [UserController::class, 'update']);
            Route::delete('/{id?}', [UserController::class, 'deleteAccount']);
        });
    });
});