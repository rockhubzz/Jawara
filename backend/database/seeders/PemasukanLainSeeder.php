<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\PemasukanLain;

class PemasukanLainSeeder extends Seeder
{
    public function run(): void
    {
        $data = [
            ["nama" => "Sungcheol", "jenis" => "Uang Sumbangan", "tanggal" => "2025-10-19", "nominal" => 1000000],
            ["nama" => "Haechan", "jenis" => "Danus Warga", "tanggal" => "2025-10-19", "nominal" => 500000],
            ["nama" => "Yeri", "jenis" => "Iuran Warga", "tanggal" => "2025-10-17", "nominal" => 6000000],
            ["nama" => "Ahmad", "jenis" => "Iuran Warga", "tanggal" => "2025-01-15", "nominal" => 150000],
            ["nama" => "Bella", "jenis" => "Uang Sumbangan", "tanggal" => "2025-02-12", "nominal" => 200000],
            ["nama" => "Cahya", "jenis" => "Iuran Warga", "tanggal" => "2025-03-20", "nominal" => 175000],
            ["nama" => "Dina", "jenis" => "Danus Warga", "tanggal" => "2025-04-08", "nominal" => 300000],
            ["nama" => "Eka", "jenis" => "Iuran Warga", "tanggal" => "2025-05-22", "nominal" => 250000],
            ["nama" => "Fajar", "jenis" => "Uang Sumbangan", "tanggal" => "2025-06-11", "nominal" => 180000],
            ["nama" => "Gita", "jenis" => "Danus Warga", "tanggal" => "2025-07-05", "nominal" => 220000],
            ["nama" => "Hendra", "jenis" => "Iuran Warga", "tanggal" => "2025-08-18", "nominal" => 160000],
            ["nama" => "Intan", "jenis" => "Uang Sumbangan", "tanggal" => "2025-09-09", "nominal" => 270000],
            ["nama" => "Joko", "jenis" => "Danus Warga", "tanggal" => "2025-10-21", "nominal" => 190000],
            ["nama" => "Kiki", "jenis" => "Iuran Warga", "tanggal" => "2025-11-03", "nominal" => 210000],
            ["nama" => "Lia", "jenis" => "Uang Sumbangan", "tanggal" => "2025-12-14", "nominal" => 230000],
            ["nama" => "Maya", "jenis" => "Danus Warga", "tanggal" => "2025-01-28", "nominal" => 200000],
            ["nama" => "Niko", "jenis" => "Iuran Warga", "tanggal" => "2025-02-17", "nominal" => 240000],
            ["nama" => "Oki", "jenis" => "Uang Sumbangan", "tanggal" => "2025-03-30", "nominal" => 260000],
        ];

        foreach ($data as $item) {
            // Cek dulu berdasarkan nama + jenis + tanggal
            PemasukanLain::firstOrCreate(
                [
                    'nama' => $item['nama'],
                    'jenis' => $item['jenis'],
                    'tanggal' => $item['tanggal'],
                ],
                [
                    'nominal' => $item['nominal'],
                ]
            );
        }
    }
}
