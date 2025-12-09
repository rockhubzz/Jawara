<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Kegiatan;
use Illuminate\Http\Request;
use Illuminate\Validation\Rule;

class KegiatanController extends Controller
{
    // GET /api/kegiatan
    public function index()
    {
        // return list — default latest first
        $items = Kegiatan::orderBy('id', 'ASC')->get(); // ASC so your UI numbering matches
        return response()->json($items);
    }

    // POST /api/kegiatan
    public function store(Request $r)
    {
        $data = $r->validate([
            'nama' => 'required|string|max:255',
            'kategori' => 'nullable|string|max:100',
            'penanggung_jawab' => 'nullable|string|max:150',
            'biaya' => 'nullable|integer',
            'tanggal' => 'nullable|date',
            'lokasi' => 'nullable|string',
        ]);

        $k = Kegiatan::create($data);

        return response()->json(['success' => true, 'data' => $k], 201);
    }

    // GET /api/kegiatan/{id}
    public function show($id)
    {
        $k = Kegiatan::findOrFail($id);
        return response()->json($k);
    }

    // PUT /api/kegiatan/{id}
    public function update(Request $r, $id)
    {
        $data = $r->validate([
            'nama' => 'required|string|max:255',
            'kategori' => 'nullable|string|max:100',
            'penanggung_jawab' => 'nullable|string|max:150',
            'biaya' => 'nullable|integer',
            'tanggal' => 'nullable|date',
            'lokasi' => 'nullable|string',
        ]);

        $k = Kegiatan::findOrFail($id);
        $k->update($data);

        return response()->json(['success' => true, 'data' => $k]);
    }

    // DELETE /api/kegiatan/{id}
    public function destroy($id)
    {
        Kegiatan::destroy($id);
        return response()->json(['success' => true]);
    }
}
