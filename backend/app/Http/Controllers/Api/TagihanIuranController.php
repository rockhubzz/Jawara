<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\TagihanIuran;
use Illuminate\Http\Request;

class TagihanIuranController extends Controller
{
    public function index()
    {
        return TagihanIuran::with(['keluarga', 'kategoriIuran'])
            ->orderBy('id', 'DESC')
            ->get();
    }

    public function store(Request $r)
    {
        $data = $r->validate([
            'keluarga_id'      => 'required|exists:keluarga,id',
            'kategori_iuran_id'   => 'required|exists:kategori_iuran,id',
            'tanggal_tagihan'  => 'required|date',
            'status'           => 'nullable|in:belum_bayar,sudah_bayar',
        ]);

        // default status
        if (!isset($data['status'])) {
            $data['status'] = 'belum_bayar';
        }

        $tagihan = TagihanIuran::create($data);

        return response()->json(['success' => true, 'data' => $tagihan]);
    }

    public function storeAll(Request $r)
{
    // Validate only fields that apply to all tagihan
    $data = $r->validate([
        'kategori_iuran_id'   => 'required|exists:kategori_iuran,id',
        'tanggal_tagihan'  => 'required|date',
        'status'           => 'nullable|in:belum_bayar,sudah_bayar',
    ]);

    // default status
    if (!isset($data['status'])) {
        $data['status'] = 'belum_bayar';
    }

    // Ambil semua keluarga aktif (atau semua keluarga, terserah kebutuhan)
    $keluargaList = \App\Models\Keluarga::where('status', 'Aktif')->get();

    if ($keluargaList->count() == 0) {
        return response()->json([
            'success' => false,
            'message' => 'Tidak ada keluarga aktif.',
        ], 400);
    }

    $created = [];

    foreach ($keluargaList as $keluarga) {
        $created[] = TagihanIuran::create([
            'keluarga_id'      => $keluarga->id,
            'kategori_iuran_id'   => $data['kategori_iuran_id'],
            'tanggal_tagihan'  => $data['tanggal_tagihan'],
            'status'           => $data['status'],
        ]);
    }

    return response()->json([
        'success' => true,
        'count'   => count($created),
        'data'    => $created,
    ]);
}


    public function show($id)
    {
        return TagihanIuran::with(['keluarga', 'jenisIuran'])->findOrFail($id);
    }

    public function update(Request $r, $id)
    {
        $data = $r->validate([
            'keluarga_id'      => 'required|exists:keluarga,id',
            'kategori_iuran_id'   => 'required|exists:kategori_iuran,id',
            'jumlah'           => 'required|integer|min:0',
            'tanggal_tagihan'  => 'required|date',
            'status'           => 'required|in:belum_bayar,sudah_bayar',
        ]);

        $tagihan = TagihanIuran::findOrFail($id);
        $tagihan->update($data);

        return ['success' => true, 'data' => $tagihan];
    }

    public function destroy($id)
    {
        TagihanIuran::destroy($id);
        return ['success' => true];
    }
}
