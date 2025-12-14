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
                'kepemilikan'      => 'Pemilik',
                'status'           => 'Aktif',
                'rumah_id'         => 1,
            ],
            [
                'nama_keluarga'    => 'Keluarga Rizky Ananda',
                'kepala_keluarga'  => 'Rizky Ananda',
                'kepemilikan'      => 'Penyewa',
                'status'           => 'Aktif',
                'rumah_id'         => 2,
            ],
            [
                'nama_keluarga'    => 'Keluarga Dewi Lestari',
                'kepala_keluarga'  => 'Dewi Lestari',
                'kepemilikan'      => 'Pemilik',
                'status'           => 'Aktif',
                'rumah_id'         => 3,
            ],
            [
                'nama_keluarga'    => 'Keluarga Rudi Hartono',
                'kepala_keluarga'  => 'Rudi Hartono',
                'kepemilikan'      => 'Penyewa',
                'status'           => 'Nonaktif',
                'rumah_id'         => 4,
            ],
            [
                'nama_keluarga'    => 'Keluarga Siti Maesaroh',
                'kepala_keluarga'  => 'Siti Maesaroh',
                'kepemilikan'      => 'Pemilik',
                'status'           => 'Aktif',
                'rumah_id'         => 5,
            ],
        ]);
    }
}
