<?php
namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Broadcast;
use Illuminate\Support\Facades\Validator;

class BroadcastController extends Controller
{
    public function index()
    {
        // return all broadcasts, newest first
        $data = Broadcast::orderBy('id', 'DESC')->get();
        return response()->json(['success' => true, 'data' => $data], 200);
    }

    public function store(Request $r)
    {
        $v = Validator::make($r->all(), [
            'title' => 'required|string|max:255',
            'body' => 'nullable|string',
            'sender' => 'nullable|string|max:255',
            'date' => 'nullable|date',
        ]);

        if ($v->fails()) {
            return response()->json(['success' => false, 'errors' => $v->errors()], 422);
        }

        $b = Broadcast::create($v->validated());
        return response()->json(['success' => true, 'data' => $b], 201);
    }

    public function show($id)
    {
        $b = Broadcast::find($id);
        if (!$b) return response()->json(['success'=>false,'message'=>'Not found'],404);
        return response()->json(['success'=>true,'data'=>$b],200);
    }

    public function update(Request $r, $id)
    {
        $b = Broadcast::find($id);
        if (!$b) return response()->json(['success'=>false,'message'=>'Not found'],404);

        $v = Validator::make($r->all(), [
            'title' => 'required|string|max:255',
            'body' => 'nullable|string',
            'sender' => 'nullable|string|max:255',
            'date' => 'nullable|date',
        ]);

        if ($v->fails()) {
            return response()->json(['success' => false, 'errors' => $v->errors()], 422);
        }

        $b->update($v->validated());
        return response()->json(['success' => true, 'data' => $b], 200);
    }

    public function destroy($id)
    {
        $b = Broadcast::find($id);
        if (!$b) return response()->json(['success'=>false,'message'=>'Not found'],404);
        $b->delete();
        return response()->json(['success' => true], 200);
    }
}
