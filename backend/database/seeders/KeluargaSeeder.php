<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class KeluargaSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        DB::table('keluarga')->insert([
            [
                'nama_keluarga'    => 'Keluarga Andika Pratama',
                'kepala_keluarga'  => 'Andika Pratama',
                'alamat'           => 'Jl. Mawar No. 12, Kelurahan Sukun, Malang',
                'kepemilikan'      => 'Pemilik',
                'status'           => 'Aktif',
            ],
            [
                'nama_keluarga'    => 'Keluarga Rizky Ananda',
                'kepala_keluarga'  => 'Rizky Ananda',
                'alamat'           => 'Jl. Melati No. 8, Kelurahan Lowokwaru, Malang',
                'kepemilikan'      => 'Penyewa',
                'status'           => 'Aktif',
            ],
            [
                'nama_keluarga'    => 'Keluarga Dewi Lestari',
                'kepala_keluarga'  => 'Dewi Lestari',
                'alamat'           => 'Jl. Anggrek No. 3, Kelurahan Blimbing, Malang',
                'kepemilikan'      => 'Pemilik',
                'status'           => 'Aktif',
            ],
            [
                'nama_keluarga'    => 'Keluarga Rudi Hartono',
                'kepala_keluarga'  => 'Rudi Hartono',
                'alamat'           => 'Jl. Cendana No. 21, Kelurahan Tlogomas, Malang',
                'kepemilikan'      => 'Penyewa',
                'status'           => 'Nonaktif',
            ],
            [
                'nama_keluarga'    => 'Keluarga Siti Maesaroh',
                'kepala_keluarga'  => 'Siti Maesaroh',
                'alamat'           => 'Jl. Kenanga No. 5, Kelurahan Dinoyo, Malang',
                'kepemilikan'      => 'Pemilik',
                'status'           => 'Aktif',
            ],
        ]);
    }
}
