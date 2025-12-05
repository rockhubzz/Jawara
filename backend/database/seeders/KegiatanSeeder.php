<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Kegiatan;

class KegiatanSeeder extends Seeder
{
    public function run()
    {
        Kegiatan::create([
            'nama' => 'Pelatihan Flutter',
            'kategori' => 'Workshop',
            'penanggung_jawab' => 'Budi Santoso',
            'tanggal' => now()->addDays(10)->format('Y-m-d'),
            'lokasi' => 'Aula RW 05',
        ]);
    }
}
