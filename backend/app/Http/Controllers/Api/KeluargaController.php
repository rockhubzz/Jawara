<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Keluarga;
use App\Models\Warga;
use Illuminate\Http\Request;

class KeluargaController extends Controller
{
    // GET all data
    public function index()
    {
        return response()->json(Keluarga::all(), 200);
    }

    // GET detail by ID
    public function show($id)
    {
        $data = Keluarga::find($id);
        $anggota = Warga::where('keluarga_id', $id)->get();

        if (!$data) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        return response()->json(['data' => $data, 'anggota' => $anggota], 200);
    }

    // POST create new data
    public function store(Request $request)
    {
        $request->validate([
            'nama_keluarga'      => 'required|string|max:255',
            'kepala_keluarga'    => 'required|string|max:255',
            'alamat'             => 'required|string',
            'kepemilikan'        => 'required|string',
            'status'             => 'required|string',
        ]);

        $data = Keluarga::create($request->all());

        return response()->json([
            'message' => 'Data keluarga berhasil ditambahkan',
            'data'    => $data
        ], 201);
    }

    // PUT update data
    public function update(Request $request, $id)
    {
        $data = Keluarga::find($id);

        if (!$data) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        $data->update($request->all());

        return response()->json([
            'message' => 'Data keluarga berhasil diupdate',
            'data'    => $data
        ], 200);
    }

    // DELETE destroy
    public function destroy($id)
    {
        $data = Keluarga::find($id);

        if (!$data) {
            return response()->json(['message' => 'Data tidak ditemukan'], 404);
        }

        $data->delete();

        return response()->json(['message' => 'Data berhasil dihapus'], 200);
    }
}
