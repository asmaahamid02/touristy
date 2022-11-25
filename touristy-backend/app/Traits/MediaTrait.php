<?php

namespace App\Traits;

use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;

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
        $path = $folderName . '/' . time() . '/' . $imageName;

        Storage::disk('uploads')->put($path, $fileData);

        return $path;
    }

    public function uploadMedia($file, $folderName)
    {
        $fileName = uniqid() . time() . '.' . $file->getClientOriginalExtension();
        // $path = 'uploads/' . $folderName . '/' . time() . '/' . $fileName;
        $path = $folderName . '/' . time() . '/' . $fileName;
        Storage::disk('uploads')->put($path, file_get_contents($file));

        return $path;
    }

    public function deleteMedia($path)
    {
        Storage::delete($path);
    }

    //delete empty folders
    public function deleteEmptyFolders($path)
    {
        $path = explode('/', $path);
        $path = array_slice($path, 0, count($path) - 1);
        $path = implode('/', $path);

        if (Storage::exists($path)) {
            $files = Storage::allFiles($path);
            if (count($files) == 0) {
                Storage::deleteDirectory($path);
                $this->deleteEmptyFolders($path);
            }
        }
    }

    public function getMimeType($file)
    {
        $finfo = finfo_open(FILEINFO_MIME_TYPE);
        $mime = finfo_file($finfo, $file);
        $mime = explode('/', $mime)[0];
        finfo_close($finfo);

        return $mime;
    }

    //save base64String as image
    public function saveBase64String($base64String, $folderName)
    {
        $file_name =  uniqid() . time() . '.png'; 

        //save the file to the server
        $path = $folderName . '/' . time() . '/' . $file_name;
        Storage::disk('uploads')->put($path, base64_decode($base64String));

        return $path;
    }
   
}