<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PemasukanLain;
use App\Models\TagihanIuran;
use Illuminate\Http\Request;

class SemuaPemasukanController extends Controller
{
        public function index()
    {
    $tagihanIuran = TagihanIuran::with(['kategoriIuran', 'keluarga'])
        ->where('status', 'sudah_bayar')
        ->get()
        ->map(function ($item) {
            return [
                'nama_keluarga' => $item->keluarga->nama_keluarga,
                'nama_iuran'    => $item->kategoriIuran->nama,
                'nominal'       => $item->kategoriIuran->nominal,
                'tanggal_bayar' => $item->updated_at->format('Y-m-d'),
            ];
        });
        return response()->json([   
            'tagihan_iuran' => $tagihanIuran,
            'pemasukan_lain' => PemasukanLain::all(),
        ]);
    }

}
