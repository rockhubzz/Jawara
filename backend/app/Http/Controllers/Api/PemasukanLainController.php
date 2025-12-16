<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PemasukanLain;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Validator;

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
        \Log::info('PemasukanLain store request', [
            'all' => $request->all(),
            'files' => $request->allFiles(),
            'hasFile_bukti' => $request->hasFile('bukti'),
            'file_bukti' => $request->file('bukti'),
            'input_bukti' => $request->input('bukti'),
            'content_type' => $request->header('Content-Type'),
        ]);

        $v = Validator::make($request->all(), [
            "nama" => "required",
            "jenis" => "required",
            "tanggal" => "required|date",
            "nominal" => "required|numeric",
            "bukti" => "nullable|file|mimes:jpg,jpeg,png|max:5120",
        ]);

        if ($v->fails()) {
            \Log::info('Validation failed', ['errors' => $v->errors()]);
            return response()->json([
                "success" => false,
                "message" => $v->errors()->first()
            ], 422);
        }

        $data = $v->validated();

        // Handle file upload
        if ($request->hasFile('bukti')) {
            \Log::info('File detected, storing...');
            $file = $request->file('bukti');
            \Log::info('File details', [
                'original_name' => $file->getClientOriginalName(),
                'mime_type' => $file->getMimeType(),
                'size' => $file->getSize(),
                'is_valid' => $file->isValid()
            ]);
            $path = $file->store('pemasukan-lain-bukti', 'public');
            \Log::info('File stored at: ' . $path);
            $data['bukti'] = $path;
        } else {
            \Log::info('No file detected in hasFile check');
            // Check if file is in allFiles
            $allFiles = $request->allFiles();
            if (isset($allFiles['bukti'])) {
                \Log::info('File found in allFiles');
                $file = $allFiles['bukti'];
                $path = $file->store('pemasukan-lain-bukti', 'public');
                $data['bukti'] = $path;
            }
        }

        $item = PemasukanLain::create($data);

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

        $v = Validator::make($request->all(), [
            "nama" => "sometimes|required",
            "jenis" => "sometimes|required",
            "tanggal" => "sometimes|required|date",
            "nominal" => "sometimes|required|numeric",
            "bukti" => "nullable|file|mimes:jpg,jpeg,png|max:5120",
        ]);

        if ($v->fails()) {
            return response()->json([
                "success" => false,
                "message" => $v->errors()->first()
            ], 422);
        }

        $data = $v->validated();

        // Handle file upload
        if ($request->hasFile('bukti')) {
            // Delete old file if exists
            if (!empty($item->bukti)) {
                Storage::disk('public')->delete($item->bukti);
            }
            // Store new file
            $path = $request->file('bukti')->store('pemasukan-lain-bukti', 'public');
            $data['bukti'] = $path;
        }

        $item->update($data);

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
