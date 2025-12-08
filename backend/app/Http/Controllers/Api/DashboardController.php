<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\Keluarga;

class DashboardController extends Controller
{
    public function getSaldo()
{
    $pemasukanLain = DB::table('pemasukan_lain')->sum('nominal');

    $iuran = DB::table('kategori_iuran as k')
        ->join('tagihan_iuran as t', 'k.id', '=', 't.kategori_iuran_id')
        ->where('t.status', 'sudah_bayar')
        ->sum('k.nominal');

    $pengeluaran = DB::table('kegiatan')->sum('biaya');

    $saldo = ($pemasukanLain + $iuran) - $pengeluaran;



    return response()->json([
        'pemasukan_lain' => $pemasukanLain,
        'iuran' => $iuran,
        'pengeluaran' => $pengeluaran,
        'saldo' => $saldo,
    ]);
}

 public function getKeluarga()
    {
        $total = Keluarga::count('id');

        return response()->json([
            'status' => 'success',
            'total_keluarga' => $total
        ]);
    }

    public function getKegiatan()
    {
        $total = DB::table('kegiatan')
            ->where('tanggal', '>', now()->toDateString())
            ->count('id');

        return response()->json([
            'total_kegiatan' => $total
        ]);
    }

    public function getKeuangan()
    {
        $total = DB::table('kegiatan')
            ->where('tanggal', '>', now()->toDateString())
            ->count('id');

        return response()->json([
            'total_kegiatan' => $total
        ]);
    }

    public function rekapBulanan()
    {
        $data = DB::select("
            SELECT 
                bulan,
                SUM(pemasukan) AS total_pemasukan,
                SUM(pengeluaran) AS total_pengeluaran
            FROM (
                -- PEMASUKAN dari pemasukan_lain
                SELECT 
                    DATE_FORMAT(tanggal, '%Y-%m') AS bulan,
                    SUM(nominal) AS pemasukan,
                    0 AS pengeluaran
                FROM pemasukan_lain
                GROUP BY DATE_FORMAT(tanggal, '%Y-%m')

                UNION ALL

                -- PEMASUKAN dari iuran yang sudah dibayar
                SELECT 
                    DATE_FORMAT(t.tanggal_tagihan, '%Y-%m') AS bulan,
                    SUM(k.nominal) AS pemasukan,
                    0 AS pengeluaran
                FROM tagihan_iuran t
                INNER JOIN kategori_iuran k 
                    ON k.id = t.kategori_iuran_id
                WHERE t.status = 'sudah_bayar'
                GROUP BY DATE_FORMAT(t.tanggal_tagihan, '%Y-%m')

                UNION ALL

                -- PENGELUARAN dari kegiatan
                SELECT 
                    DATE_FORMAT(tanggal, '%Y-%m') AS bulan,
                    0 AS pemasukan,
                    SUM(biaya) AS pengeluaran
                FROM kegiatan
                GROUP BY DATE_FORMAT(tanggal, '%Y-%m')
            ) AS data
            GROUP BY bulan
            ORDER BY bulan ASC
        ");

        return response()->json([
            'success' => true,
            'data' => $data
        ]);
    }

}
