<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
    // GET /api/users
    public function index()
    {
        return response()->json(User::all());
    }

    // GET /api/users/{id}
    public function show($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json(['message' => 'User not found'], 404);
        }

        return response()->json($user);
    }

    // POST /api/users
    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string',
            'email' => 'required|email|unique:users,email',
            'hp' => 'required|string',
            'password' => 'required|string|min:6',
            'role' => 'required|string',
        ]);

        $user = User::create([
            'name' => $request->name,
            'email' => $request->email,
            'hp' => $request->hp,
            'password' => Hash::make($request->password),
            'role' => $request->role,
        ]);

        return response()->json($user, 201);
    }

    // PUT /api/users/{id}
public function update(Request $request, $id)
{
    $user = User::find($id);
    if (!$user) {
        return response()->json([
            'success' => false,
            'message' => 'User tidak ditemukan'
        ], 404);
    }

    $request->validate([
        'name' => 'required',
        'email' => "required|email|unique:users,email,$id",
        'hp' => 'required',
        'role' => 'required'
    ]);

    $user->update([
        'name' => $request->name,
        'email' => $request->email,
        'hp' => $request->hp,
        'role' => $request->role,
    ]);

    return response()->json([
        'success' => true,
        'message' => 'User updated successfully',
        'data' => $user
    ]);
}

    // DELETE /api/users/{id}
    public function destroy($id)
    {
        $user = User::find($id);

        if (!$user) {
            return response()->json([
                'message' => 'User not found'
            ], 404);
        }

        $user->delete();

        return response()->json([
            'message' => 'User deleted successfully'
        ]);
    }
}
