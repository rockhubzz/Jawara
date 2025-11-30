<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Keluarga;
use App\Models\Warga;

class WargaSeeder extends Seeder
{
    public function run(): void
    {
        $keluargaList = Keluarga::all();

        if ($keluargaList->count() == 0) {
            echo "No keluarga data found!\n";
            return;
        }

        foreach ($keluargaList as $kel) {
            Warga::create([
                'nama' => 'Anggota ' . $kel->nama_keluarga,
                'nik'  => fake()->numerify('################'),
                'keluarga_id' => $kel->id,
                'jenis_kelamin' => 'Laki-laki',
                'status_domisili' => 'Aktif',
                'status_hidup' => 'Hidup',
            ]);
        }
    }
}
