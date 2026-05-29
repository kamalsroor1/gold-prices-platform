<?php

namespace App\Domains\Auth\Http\Controllers;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    public function register(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20|unique:users',
            'email' => 'nullable|string|email|max:255|unique:users',
            'password' => 'required|string|min:6|confirmed',
        ]);

        $user = User::create([
            'name' => $request->name,
            'phone_number' => $request->phone_number,
            'email' => $request->email,
            'password' => Hash::make($request->password),
            'api_token' => Str::random(80),
        ]);

        return response()->json(['user' => $user, 'token' => $user->api_token], 201);
    }

    public function login(Request $request)
    {
        $request->validate([
            'phone_number' => 'required|string|max:20',
            'password' => 'required',
        ]);

        $user = User::where('phone_number', $request->phone_number)->first();

        if (!$user || !Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'phone_number' => ['بيانات الاعتماد غير صحيحة.'],
            ]);
        }

        if (!$user->api_token) {
            $user->update(['api_token' => Str::random(80)]);
        }

        return response()->json(['user' => $user, 'token' => $user->api_token]);
    }

    public function logout(Request $request)
    {
        $user = $request->user();
        if ($user) {
            $user->update(['api_token' => null]);
        }
        return response()->json(['message' => 'تم تسجيل الخروج بنجاح']);
    }

    public function profile(Request $request)
    {
        return response()->json(['user' => $request->user()]);
    }

    public function updateProfile(Request $request)
    {
        $user = $request->user();
        
        $data = $request->validate([
            'country_id' => 'sometimes|integer|exists:countries,id',
            'price_alerts_enabled' => 'sometimes|boolean',
            'periodic_alerts_enabled' => 'sometimes|boolean',
            'daily_summary_enabled' => 'sometimes|boolean',
            'app_language' => 'sometimes|string|max:20',
        ]);

        $user->update($data);

        return response()->json(['user' => $user, 'message' => 'تم تحديث الإعدادات بنجاح']);
    }
}
