<?php

namespace App\Http\Controllers;

use App\Traits\ResponseJson;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Bus\DispatchesJobs;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\Response;

class Controller extends BaseController
{
    use AuthorizesRequests, DispatchesJobs, ValidatesRequests, ResponseJson;

    //get file
    public function getFile($path)
    {
        //check if file exists
        if (Storage::exists($path)) {
            //get file
            $file = Storage::get($path);
            //get file type
            $type = Storage::mimeType($path);
            //get file size
            $size = Storage::size($path);
            //get file name
            $name = basename($path);
            //return file
            return response($file, 200)
                ->header('Content-Type', $type)
                ->header('Content-Length', $size)
                ->header('Content-Disposition', 'inline; filename="' . $name . '"');
        } else {
            //return error
            return $this->jsonResponse('', 'data', Response::HTTP_NOT_FOUND, 'File not found');
        }
    }
}