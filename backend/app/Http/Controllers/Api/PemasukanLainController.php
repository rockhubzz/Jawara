<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PemasukanLain;
use Illuminate\Http\Request;

class PemasukanLainController extends Controller
{
    public function index(Request $request)
    {
        $data = PemasukanLain::orderBy('id', 'asc')
            ->paginate(10);

        return response()->json([
            "success" => true,
            "message" => "List Pemasukan",
            "data" => $data
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            "nama" => "required",
            "jenis" => "required",
            "tanggal" => "required|date",
            "nominal" => "required|numeric",
        ]);

        $item = PemasukanLain::create($request->all());

        return response()->json([
            "success" => true,
            "message" => "Pemasukan berhasil ditambah",
            "data" => $item
        ]);
    }

    public function show($id)
    {
        $item = PemasukanLain::findOrFail($id);

        return response()->json([
            "success" => true,
            "data" => $item
        ]);
    }

    public function update(Request $request, $id)
    {
        $item = PemasukanLain::findOrFail($id);

        $request->validate([
            "nama" => "required",
            "jenis" => "required",
            "tanggal" => "required|date",
            "nominal" => "required|numeric",
        ]);

        $item->update($request->all());

        return response()->json([
            "success" => true,
            "message" => "Pemasukan berhasil diupdate",
        ]);
    }

    public function destroy($id)
    {
        PemasukanLain::findOrFail($id)->delete();

        return response()->json([
            "success" => true,
            "message" => "Pemasukan berhasil dihapus",
        ]);
    }
}
