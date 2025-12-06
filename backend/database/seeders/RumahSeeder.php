<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Rumah;

class RumahSeeder extends Seeder
{
    public function run(): void
    {
        $items = [
            ['alamat' => 'Jl. Melati No. 12, Malang', 'kode' => 'A1', 'status' => 'Tersedia'],
            ['alamat' => 'Jl. Sukarno Hatta No. 45, Malang', 'kode' => 'A2', 'status' => 'Ditempati'],
            ['alamat' => 'Jl. Ijen No. 8, Malang', 'kode' => 'A3', 'status' => 'Ditempati'],
            ['alamat' => 'Komplek Graha Cempaka Lantai 2, Malang', 'kode' => 'A4', 'status' => 'Nonaktif'],
            ['alamat' => 'Jl. Merbabu No. 23, Malang', 'kode' => 'A5', 'status' => 'Tersedia'],
        ];

        foreach ($items as $i) {
            Rumah::create($i);
        }
    }
}
