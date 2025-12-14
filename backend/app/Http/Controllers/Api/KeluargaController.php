<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Keluarga;
use App\Models\Warga;
use App\Models\Rumah;
use Illuminate\Http\Request;

class KeluargaController extends Controller
{
    // GET all data
    public function index()
    {
        return response()->json(Keluarga::with('rumah')->get(), 200);
    }

    // GET detail by ID
    public function show($id)
    {
        $data = Keluarga::with('rumah')->find($id);
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
            'kepemilikan'        => 'required|string',
            'status'             => 'required|string',
            'rumah_id'           => 'nullable|exists:rumah,id|unique:keluarga,rumah_id',
        ]);

        $data = Keluarga::create($request->all());

        // Update rumah status if rumah_id is set
        if ($request->rumah_id) {
            $rumah = \App\Models\Rumah::find($request->rumah_id);
            if ($rumah) {
                $rumah->update(['status' => 'Ditempati']);
            }
        }

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

        // Update rumah status
        $oldRumahId = $data->getOriginal('rumah_id');
        $newRumahId = $request->rumah_id;

        if ($oldRumahId != $newRumahId) {
            // Set old rumah to Tersedia if no other keluarga uses it
            if ($oldRumahId) {
                $oldRumah = \App\Models\Rumah::find($oldRumahId);
                if ($oldRumah && !Keluarga::where('rumah_id', $oldRumahId)->where('id', '!=', $data->id)->exists()) {
                    $oldRumah->update(['status' => 'Tersedia']);
                }
            }
            // Set new rumah to Ditempati
            if ($newRumahId) {
                $newRumah = \App\Models\Rumah::find($newRumahId);
                if ($newRumah) {
                    $newRumah->update(['status' => 'Ditempati']);
                }
            }
        }

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

        $rumahId = $data->rumah_id;

        $data->delete();

        // Set rumah to Tersedia if no other keluarga uses it
        if ($rumahId && !Keluarga::where('rumah_id', $rumahId)->exists()) {
            $rumah = \App\Models\Rumah::find($rumahId);
            if ($rumah) {
                $rumah->update(['status' => 'Tersedia']);
            }
        }

        return response()->json(['message' => 'Data berhasil dihapus'], 200);
    }
}
