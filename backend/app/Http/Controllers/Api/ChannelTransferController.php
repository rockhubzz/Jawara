<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\ChannelTransfer;
use Illuminate\Broadcasting\Channel;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Validator;

class ChannelTransferController extends Controller
{
    // GET /api/payment-channels
    public function index()
    {
        $channels = ChannelTransfer::orderBy('created_at', 'desc')->get();
        return response()->json(['success' => true, 'data' => $channels], 200);
    }

    // GET /api/payment-channels/{id}
    public function show($id)
    {
        $channel = ChannelTransfer::find($id);
        if (!$channel) {
            return response()->json(['success' => false, 'message' => 'Not found'], 404);
        }
        return response()->json(['success' => true, 'data' => $channel], 200);
    }

    // POST /api/payment-channels
public function store(Request $request)
    {
        $v = Validator::make($request->all(), [
            'nama' => 'required|string|max:255',
            'tipe' => 'required|string|in:bank,ewallet,qris,other',
            'an' => 'nullable|string|max:255',
            'nomor' => 'nullable|string|max:255',
            'notes' => 'nullable|string',
            'thumbnail' => 'nullable|file|mimes:jpg,jpeg,png|max:5120',
        ]);

        if ($v->fails()) {
            return response()->json([
                'success' => false,
                'message' => $v->errors()->first()
            ], 422);
        }

        $data = $v->validated();

        // Handle file upload
        if ($request->hasFile('thumbnail')) {
            $path = $request->file('thumbnail')->store('channel-thumbnails', 'public');
            $data['thumbnail'] = $path;
        }

        $channel = ChannelTransfer::create($data);

        return response()->json([
            'success' => true,
            'message' => 'Channel berhasil ditambahkan',
            'data' => $channel
        ]);
    }
    // PUT/PATCH /api/payment-channels/{id}
public function update(Request $request, $id)
{
    $channel = ChannelTransfer::find($id);

    if (!$channel) {
        return response()->json([
            'success' => false,
            'message' => 'Not found'
        ], 404);
    }

    $v = Validator::make($request->all(), [
        'nama' => 'sometimes|required|string|max:255',
        'tipe' => 'sometimes|required|string|in:bank,ewallet,qris,other',
        'an' => 'nullable|string|max:255',
        'nomor' => 'nullable|string|max:255',
        'notes' => 'nullable|string',
        'thumbnail' => 'nullable|file|mimes:jpg,jpeg,png|max:5120',
    ]);

    if ($v->fails()) {
        return response()->json([
            'success' => false,
            'message' => $v->errors()->first()
        ], 422);
    }

    $data = $v->validated();

    // ==== Handle thumbnail (same as store) ====
    if ($request->hasFile('thumbnail')) {

        // Hapus file lama jika ada
        if (!empty($channel->thumbnail)) {
            Storage::disk('public')->delete($channel->thumbnail);
        }

        // Simpan file baru ke folder yang sama
        $path = $request->file('thumbnail')->store('channel-thumbnails', 'public');
        $data['thumbnail'] = $path;
    }

    $channel->update($data);

    return response()->json([
        'success' => true,
        'message' => 'Channel berhasil diperbarui',
        'data' => $channel
    ], 200);
}

    // DELETE /api/payment-channels/{id}
    public function destroy($id)
    {
        $channel = ChannelTransfer::find($id);
        if (!$channel) {
            return response()->json(['success' => false, 'message' => 'Not found'], 404);
        }

        // delete file if exists in storage
        if ($channel->thumbnail && Str::startsWith($channel->thumbnail, '/storage/')) {
            $oldPath = str_replace('/storage/', 'public/', $channel->thumbnail);
            Storage::delete($oldPath);
        }

        $channel->delete();

        return response()->json(['success' => true, 'message' => 'Deleted'], 200);
    }
}
