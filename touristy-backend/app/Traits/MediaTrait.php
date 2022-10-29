<?php

namespace App\Traits;

use Illuminate\Support\Facades\Storage;

trait MediaTrait
{

    public function saveBase64Image($base64Image, $folderName)
    {
        //split the base64URL from the image data
        @list($type, $fileData) = explode(';', $base64Image);
        //get the file extension
        @list(, $extension) = explode('/', $type);
        //get the file name
        @list(, $fileData) = explode(',', $fileData);
        //decode the file data
        $fileData = base64_decode($fileData);
        //create a unique file name
        $imageName = uniqid() . time() . '.' . $extension;
        //save the file to the server
        $path = 'uploads/' . $folderName . '/' . time() . '/' . $imageName;

        Storage::put($path, $fileData);

        return $path;
    }

    public function uploadMedia($file, $folderName)
    {
        $fileName = uniqid() . time() . '.' . $file->getClientOriginalExtension();
        $path = 'uploads/' . $folderName . '/' . time() . '/' . $fileName;
        Storage::put($path, file_get_contents($file));

        return $path;
    }

    public function deleteMedia($path)
    {
        Storage::delete($path);
    }
}