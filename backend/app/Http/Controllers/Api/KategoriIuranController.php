<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\KategoriIuran;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class KategoriIuranController extends Controller
{
    public function index()
    {
        return response()->json(KategoriIuran::orderBy('id','desc')->get());
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'nama' => 'required|string|max:255',
            'jenis' => ['required', Rule::in(['Rutin','Khusus'])],
            'nominal' => 'required|integer|min:0',
        ]);

        $item = KategoriIuran::create($data);
        return response()->json($item, 201);
    }

    public function show($id)
    {
        $item = KategoriIuran::findOrFail($id);
        return response()->json($item);
    }

    public function update(Request $request, $id)
    {
        $item = KategoriIuran::findOrFail($id);
        $data = $request->validate([
            'nama' => 'required|string|max:255',
            'jenis' => ['required', Rule::in(['Rutin','Khusus'])],
            'nominal' => 'required|integer|min:0',
        ]);
        $item->update($data);
        return response()->json($item);
    }

    public function destroy($id)
    {
        $item = KategoriIuran::findOrFail($id);
        $item->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
