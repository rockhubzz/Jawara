<?php

namespace Database\Seeders;

use App\Models\Keluarga;
use App\Models\TagihanIuran;
use App\Models\KategoriIuran;
use Illuminate\Database\Seeder;

class TagihanIuranSeeder extends Seeder
{
    public function run()
    {
        $keluargas = Keluarga::all();
        $KategoriIurans = KategoriIuran::find(1);

        foreach ($keluargas as $keluarga) {

            TagihanIuran::create([
                'keluarga_id'      => $keluarga->id,
                'kategori_iuran_id'   => 1,
                'jumlah'           => $KategoriIurans->nominal,
                'tanggal_tagihan'  => now(),
                'status'           => 'belum_bayar',
            ]);
        }
    }
}
