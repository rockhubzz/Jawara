<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\PemasukanLain;

class PemasukanLainSeeder extends Seeder
{
    public function run(): void
    {
        PemasukanLain::insert([
            [
                "nama" => "Sungcheol",
                "jenis" => "Uang Sumbangan",
                "tanggal" => "2025-10-19",
                "nominal" => 1000000,
            ],
            [
                "nama" => "Haechan",
                "jenis" => "Danus Warga",
                "tanggal" => "2025-10-19",
                "nominal" => 500000,
            ],
            [
                "nama" => "Yeri",
                "jenis" => "Iuran Warga",
                "tanggal" => "2025-10-17",
                "nominal" => 6000000,
            ],
        ]);
    }
}
