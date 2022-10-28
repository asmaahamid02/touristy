<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RoleMiddleware
{
    public function handle(Request $request, Closure $next, ...$roles)
    {
        if (!Auth::check())
            return redirect('login');

        $user = Auth::user()->user_type;

        foreach ($roles as $role) {
            if ($user->type == $role)
                return $next($request);
        }

        return redirect('login');
    }
}