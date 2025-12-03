<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\KategoriIuran;

class KategoriIuranSeeder extends Seeder
{
    public function run(): void
    {
        $items = [
            ['nama' => 'Iuran Bulanan', 'jenis' => 'Rutin', 'nominal' => 5000],
            ['nama' => 'Iuran Harian', 'jenis' => 'Khusus', 'nominal' => 2000],
            ['nama' => 'Iuran Kerja Bakti', 'jenis' => 'Khusus', 'nominal' => 5000],
            ['nama' => 'Iuran Bersih Desa', 'jenis' => 'Khusus', 'nominal' => 200000],
            ['nama' => 'Iuran Mingguan', 'jenis' => 'Khusus', 'nominal' => 12000],
            ['nama' => 'Iuran Agustusan', 'jenis' => 'Khusus', 'nominal' => 15000],
        ];

        foreach ($items as $i) {
            KategoriIuran::create($i);
        }
    }
}
