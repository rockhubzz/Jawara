<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Rumah;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class RumahController extends Controller
{
    // GET /api/rumah
    public function index()
    {
        // you can add pagination later: Rumah::paginate(20)
        return response()->json(Rumah::orderBy('id','desc')->get());
    }

    // POST /api/rumah
    public function store(Request $request)
    {
        $data = $request->validate([
            'alamat' => 'required|string|max:1000',
            'kode' => 'nullable|string|max:50',
            'status' => ['required', Rule::in(['Tersedia','Ditempati','Nonaktif'])],
            'keterangan' => 'nullable|string|max:2000',
        ]);

        $rumah = Rumah::create($data);

        return response()->json($rumah, 201);
    }

    // GET /api/rumah/{id}
    public function show($id)
    {
        $rumah = Rumah::findOrFail($id);
        return response()->json($rumah);
    }

    // PUT /api/rumah/{id}
    public function update(Request $request, $id)
    {
        $rumah = Rumah::findOrFail($id);

        $data = $request->validate([
            'alamat' => 'required|string|max:1000',
            'kode' => 'nullable|string|max:50',
            'status' => ['required', Rule::in(['Tersedia','Ditempati','Nonaktif'])],
            'keterangan' => 'nullable|string|max:2000',
        ]);

        $rumah->update($data);

        return response()->json($rumah);
    }

    // DELETE /api/rumah/{id}
    public function destroy($id)
    {
        $rumah = Rumah::findOrFail($id);
        $rumah->delete();

        return response()->json(['message' => 'Rumah deleted']);
    }
}
