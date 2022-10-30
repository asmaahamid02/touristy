<?php

use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\Controller;
use App\Http\Controllers\EventController;
use App\Http\Controllers\GroupController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\TripController;
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

    //get file route
    Route::get('/file/{path}', [Controller::class, 'getFile'])->where('path', '.*');

    Route::group(['middleware' => ['jwt.verify']], function () {
        //users
        Route::group(['prefix' => 'users'], function () {
            Route::get('/', [UserController::class, 'index']);
            Route::get('/{id?}', [UserController::class, 'show'])->where('id', '[0-9]+');
            Route::put('/{id?}', [UserController::class, 'update'])->where('id', '[0-9]+');
            Route::delete('/{id?}', [UserController::class, 'deleteAccount'])->where('id', '[0-9]+');
            Route::get('/follow/{id}', [UserController::class, 'follow'])->where('id', '[0-9]+');;
            Route::get('/block/{id}', [UserController::class, 'block'])->where('id', '[0-9]+');
            Route::get('/followers/{id?}', [UserController::class, 'getFollowers'])->where('id', '[0-9]+');
            Route::get('/followings/{id?}', [UserController::class, 'getFollowings'])->where('id', '[0-9]+');
            Route::get('/blocked/{id?}', [UserController::class, 'getBlockedUsers'])->where('id', '[0-9]+');
        });

        //posts
        Route::group(['prefix' => 'posts'], function () {
            Route::get('/', [PostController::class, 'index']);
            Route::get('/{id}', [PostController::class, 'show']);
            Route::post('/', [PostController::class, 'create']);
            Route::put('/{id}', [PostController::class, 'update']);
            Route::delete('/{id}', [PostController::class, 'delete']);
        });

        //trips
        Route::group(['prefix' => 'trips'], function () {
            Route::get('/', [TripController::class, 'index']);
            Route::get('/{id}', [TripController::class, 'show']);
            Route::post('/', [TripController::class, 'create']);
            Route::put('/{id}', [TripController::class, 'update']);
            Route::delete('/{id}', [TripController::class, 'delete']);
            Route::get('/user/{id}', [TripController::class, 'getTripsByUser']);
            Route::get('/location/{id}', [TripController::class, 'getTripsByLocation']);
        });

        //comments
        Route::group(['prefix' => 'comments'], function () {
            Route::post('/', [CommentController::class, 'create']);
            Route::put('/{id}', [CommentController::class, 'update']);
            Route::delete('/{id}', [CommentController::class, 'delete']);
            Route::get('/post/{id}', [CommentController::class, 'getCommentsByPost']);
        });

        //events
        Route::group(['prefix' => 'events'], function () {
            Route::get('/', [EventController::class, 'index']);
            Route::get('/{id}', [EventController::class, 'show'])->where('id', '[0-9]+');
            Route::post('/', [EventController::class, 'create']);
            Route::put('/{id}', [EventController::class, 'update'])->where('id', '[0-9]+');
            Route::delete('/{id}', [EventController::class, 'delete']);
            Route::get('/interest/{id}', [EventController::class, 'interestInEvent'])->where('id', '[0-9]+');
            Route::get('/join/{id}', [EventController::class, 'joinEvent'])->where('id', '[0-9]+');;
            Route::get('/interested/{id?}', [EventController::class, 'getInterestedEvents'])->where('id', '[0-9]+');
            Route::get('/joined/{id?}', [EventController::class, 'getJoinedEvents'])->where('id', '[0-9]+');
        });

        //groups
        Route::group(['prefix' => 'groups'], function () {
            Route::get('/', [GroupController::class, 'index']);
            Route::get('/{id}', [GroupController::class, 'show'])->where('id', '[0-9]+');
            Route::post('/', [GroupController::class, 'create']);
            Route::put('/{id}', [GroupController::class, 'update'])->where('id', '[0-9]+');
            Route::delete('/{id}', [GroupController::class, 'delete']);
        });
    });
});