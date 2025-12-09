<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class MutasiKeluargaSeeder extends Seeder
{
    public function run()
    {
        // Make sure keluarga table has data; here we insert example if exists
        $kel = DB::table('keluarga')->first();

        $now = Carbon::now();

        DB::table('mutasi_keluarga')->insert([
            [
                'keluarga_id' => $kel ? $kel->id : null,
                'jenis_mutasi' => 'Pindah Masuk',
                'tanggal' => $now->subDays(10)->toDateString(),
                'alasan' => 'Pindah dari luar kota',
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'keluarga_id' => $kel ? $kel->id : null,
                'jenis_mutasi' => 'Pindah Keluar',
                'tanggal' => $now->subDays(3)->toDateString(),
                'alasan' => 'Pindah kerja',
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);
    }
}
