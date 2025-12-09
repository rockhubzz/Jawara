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

        $data = [
            ["nama" => "Andi", "jenis_kelamin" => "Laki-laki", "status_hidup" => "Hidup", "nik" => "3201010000010001"],
            ["nama" => "Budi", "jenis_kelamin" => "Laki-laki", "status_hidup" => "Hidup", "nik" => "3201010000020002"],
            ["nama" => "Citra", "jenis_kelamin" => "Perempuan", "status_hidup" => "Hidup", "nik" => "3201010000030003"],
            ["nama" => "Dewi", "jenis_kelamin" => "Perempuan", "status_hidup" => "Hidup", "nik" => "3201010000040004"],
            ["nama" => "Eko", "jenis_kelamin" => "Laki-laki", "status_hidup" => "Hidup", "nik" => "3201010000050005"],
            ["nama" => "Fajar", "jenis_kelamin" => "Laki-laki", "status_hidup" => "Hidup", "nik" => "3201010000060006"],
            ["nama" => "Gita", "jenis_kelamin" => "Perempuan", "status_hidup" => "Hidup", "nik" => "3201010000070007"],
            ["nama" => "Hendra", "jenis_kelamin" => "Laki-laki", "status_hidup" => "Hidup", "nik" => "3201010000080008"],
            ["nama" => "Intan", "jenis_kelamin" => "Perempuan", "status_hidup" => "Hidup", "nik" => "3201010000090009"],
            ["nama" => "Joko", "jenis_kelamin" => "Laki-laki", "status_hidup" => "Hidup", "nik" => "3201010000100010"],
            ["nama" => "Kiki", "jenis_kelamin" => "Perempuan", "status_hidup" => "Hidup", "nik" => "3201010000110011"],
            ["nama" => "Lia", "jenis_kelamin" => "Perempuan", "status_hidup" => "Hidup", "nik" => "3201010000120012"],
            ["nama" => "Maya", "jenis_kelamin" => "Perempuan", "status_hidup" => "Hidup", "nik" => "3201010000130013"],
            ["nama" => "Niko", "jenis_kelamin" => "Laki-laki", "status_hidup" => "Hidup", "nik" => "3201010000140014"],
            ["nama" => "Oki", "jenis_kelamin" => "Laki-laki", "status_hidup" => "Hidup", "nik" => "3201010000150015"],
        ];

        foreach ($data as $item) {
            // random status domisili, 70% Aktif, 30% Tidak Aktif
            $statusDomisili = rand(1, 100) <= 70 ? "Aktif" : "Tidak Aktif";

            Warga::firstOrCreate(
                [
                    'nik' => $item['nik'], // unik berdasarkan NIK
                ],
                [
                    'nama' => $item['nama'],
                    'keluarga_id' => $keluargaList->random()->id, // random keluarga dari 5 keluarga
                    'jenis_kelamin' => $item['jenis_kelamin'],
                    'status_domisili' => $statusDomisili,
                    'status_hidup' => $item['status_hidup'],
                ]
            );
        }
    }
}
