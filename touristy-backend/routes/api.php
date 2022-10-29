<?php

use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\CommentController;
use App\Http\Controllers\EventController;
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

    Route::group(['middleware' => ['jwt.verify']], function () {
        //users
        Route::group(['prefix' => 'users'], function () {
            Route::get('/', [UserController::class, 'index']);
            Route::get('/user/{id?}', [UserController::class, 'show']);
            Route::put('/{id?}', [UserController::class, 'update']);
            Route::delete('/{id?}', [UserController::class, 'deleteAccount']);
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
            Route::post('/', [EventController::class, 'create']);
        });
    });
});