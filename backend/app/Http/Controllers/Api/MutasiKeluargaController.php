<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MutasiKeluarga;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class MutasiKeluargaController extends Controller
{
    public function index()
    {
        // paginated response optional — here return all for simplicity
        $data = MutasiKeluarga::with('keluarga')->orderBy('id', 'DESC')->paginate(10);

        return response()->json($data);
    }

    public function store(Request $request)
    {
        $payload = $request->validate([
            'keluarga_id' => 'nullable|exists:keluarga,id',
            'jenis_mutasi' => 'required|string',
            'tanggal' => 'required|date',
            'alasan' => 'nullable|string',
        ]);

        $mutasi = MutasiKeluarga::create($payload);

        return response()->json(['success' => true, 'data' => $mutasi], 201);
    }

    public function show($id)
    {
        $mutasi = MutasiKeluarga::with('keluarga')->find($id);

        if (!$mutasi) {
            return response()->json(['success' => false, 'message' => 'Not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $mutasi]);
    }

    public function update(Request $request, $id)
    {
        $mutasi = MutasiKeluarga::findOrFail($id);

        $payload = $request->validate([
            'keluarga_id' => 'nullable|exists:keluarga,id',
            'jenis_mutasi' => 'required|string',
            'tanggal' => 'required|date',
            'alasan' => 'nullable|string',
        ]);

        $mutasi->update($payload);

        return response()->json(['success' => true, 'data' => $mutasi]);
    }

    public function destroy($id)
    {
        $mutasi = MutasiKeluarga::find($id);
        if (!$mutasi) {
            return response()->json(['success' => false, 'message' => 'Not found'], 404);
        }

        $mutasi->delete();
        return response()->json(['success' => true]);
    }
}
