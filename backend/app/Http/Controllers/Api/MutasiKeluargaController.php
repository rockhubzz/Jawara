<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MutasiKeluarga;
use App\Models\Keluarga;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class MutasiKeluargaController extends Controller
{
    public function index()
    {
        // paginated response optional — here return all for simplicity
        $data = MutasiKeluarga::orderBy('id', 'DESC')->paginate(10);

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

        if ($request->keluarga_id) {
            $keluarga = Keluarga::with('rumah')->find($request->keluarga_id);
            if ($keluarga) {
                $payload['nama_keluarga'] = $keluarga->nama_keluarga;
                $payload['kepala_keluarga'] = $keluarga->kepala_keluarga;
                $payload['alamat'] = $keluarga->alamat;
                $payload['kepemilikan'] = $keluarga->kepemilikan;
                $payload['status_keluarga'] = $keluarga->status;
                $payload['rumah_id'] = $keluarga->rumah_id;
            }
        }

        $mutasi = MutasiKeluarga::create($payload);

        if ($request->keluarga_id) {
            Keluarga::find($request->keluarga_id)?->delete();
        }

        return response()->json(['success' => true, 'data' => $mutasi], 201);
    }

    public function show($id)
    {
        $mutasi = MutasiKeluarga::find($id);

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
