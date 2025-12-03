<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Warga;
use Illuminate\Http\Request;

class WargaController extends Controller
{
    public function index()
    {
        return Warga::with('keluarga')->get();
    }

    public function show($id)
    {
        return Warga::with('keluarga')->findOrFail($id);
    }

    public function store(Request $r)
    {
        $data = $r->validate([
            'nama' => 'required',
            'nik' => 'required|unique:warga',
            'keluarga_id' => 'required|exists:keluarga,id',
            'jenis_kelamin' => 'required',
            'status_domisili' => 'required',
            'status_hidup' => 'required',
        ]);

        return Warga::create($data);
    }

    public function update(Request $r, $id)
    {
        $w = Warga::findOrFail($id);

        $data = $r->validate([
            'nama' => 'required',
            'nik' => 'required|unique:warga,nik,' . $id,
            'keluarga_id' => 'required|exists:keluarga,id',
            'jenis_kelamin' => 'required',
            'status_domisili' => 'required',
            'status_hidup' => 'required',
        ]);

        $w->update($data);
        return $w;
    }

    public function destroy($id)
    {
        Warga::findOrFail($id)->delete();
        return response()->json(['message' => 'deleted']);
    }
}
