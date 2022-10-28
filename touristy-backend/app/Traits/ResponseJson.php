<?php

namespace App\Traits;


trait ResponseJson
{

    function jsonResponse($responseObject, $responseKey, $statusCode, $message)
    {
        $responseJson['statusCode'] = $statusCode;
        $responseJson['message'] = $message;
        $responseJson[$responseKey] = $responseObject;
        return response($responseJson, $statusCode);
    }
}