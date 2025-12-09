<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Kegiatan;

class KegiatanSeeder extends Seeder
{
    public function run()
    {
        $data = [
            ['nama' => 'Pelatihan Flutter', 'kategori' => 'Workshop', 'biaya' => 1000000, 'penanggung_jawab' => 'Budi Santoso', 'bulan' => 1, 'lokasi' => 'Aula RW 05'],
            ['nama' => 'Workshop UI/UX', 'kategori' => 'Workshop', 'biaya' => 1200000, 'penanggung_jawab' => 'Siti Aminah', 'bulan' => 2, 'lokasi' => 'Gedung Serbaguna'],
            ['nama' => 'Seminar Laravel', 'kategori' => 'Seminar', 'biaya' => 900000, 'penanggung_jawab' => 'Andi Wijaya', 'bulan' => 3, 'lokasi' => 'Aula RW 01'],
            ['nama' => 'Pelatihan React', 'kategori' => 'Workshop', 'biaya' => 1100000, 'penanggung_jawab' => 'Rina Lestari', 'bulan' => 4, 'lokasi' => 'Aula RW 03'],
            ['nama' => 'Workshop Python', 'kategori' => 'Workshop', 'biaya' => 950000, 'penanggung_jawab' => 'Tono Saputra', 'bulan' => 5, 'lokasi' => 'Lab Komputer'],
            ['nama' => 'Seminar AI', 'kategori' => 'Seminar', 'biaya' => 1500000, 'penanggung_jawab' => 'Dewi Anggraeni', 'bulan' => 6, 'lokasi' => 'Gedung Serbaguna'],
            ['nama' => 'Pelatihan Java', 'kategori' => 'Workshop', 'biaya' => 1000000, 'penanggung_jawab' => 'Ahmad Fauzi', 'bulan' => 7, 'lokasi' => 'Lab Komputer'],
            ['nama' => 'Workshop Data Science', 'kategori' => 'Workshop', 'biaya' => 1300000, 'penanggung_jawab' => 'Rini Putri', 'bulan' => 8, 'lokasi' => 'Aula RW 02'],
            ['nama' => 'Seminar Networking', 'kategori' => 'Seminar', 'biaya' => 900000, 'penanggung_jawab' => 'Bambang Setiawan', 'bulan' => 9, 'lokasi' => 'Aula RW 04'],
            ['nama' => 'Pelatihan Kotlin', 'kategori' => 'Workshop', 'biaya' => 1050000, 'penanggung_jawab' => 'Sari Dewi', 'bulan' => 10, 'lokasi' => 'Lab Komputer'],
            ['nama' => 'Workshop PHP', 'kategori' => 'Workshop', 'biaya' => 950000, 'penanggung_jawab' => 'Rudi Hartono', 'bulan' => 11, 'lokasi' => 'Gedung Serbaguna'],
            ['nama' => 'Seminar Cloud Computing', 'kategori' => 'Seminar', 'biaya' => 1400000, 'penanggung_jawab' => 'Maya Safitri', 'bulan' => 12, 'lokasi' => 'Aula RW 06'],
            ['nama' => 'Pelatihan C#', 'kategori' => 'Workshop', 'biaya' => 1000000, 'penanggung_jawab' => 'Hendra Gunawan', 'bulan' => 1, 'lokasi' => 'Lab Komputer'],
            ['nama' => 'Workshop JavaScript', 'kategori' => 'Workshop', 'biaya' => 1100000, 'penanggung_jawab' => 'Tia Handayani', 'bulan' => 2, 'lokasi' => 'Aula RW 03'],
            ['nama' => 'Seminar DevOps', 'kategori' => 'Seminar', 'biaya' => 1250000, 'penanggung_jawab' => 'Agus Santoso', 'bulan' => 3, 'lokasi' => 'Gedung Serbaguna'],
        ];

        foreach ($data as $item) {
            // buat tanggal 15 di bulan tertentu, tahun 2025
            $tanggal = '2025-' . str_pad($item['bulan'], 2, '0', STR_PAD_LEFT) . '-15';

            // firstOrCreate untuk mencegah duplikasi
            Kegiatan::firstOrCreate(
                [
                    'nama' => $item['nama'],
                    'kategori' => $item['kategori'],
                    'tanggal' => $tanggal,
                ],
                [
                    'biaya' => $item['biaya'],
                    'penanggung_jawab' => $item['penanggung_jawab'],
                    'lokasi' => $item['lokasi'],
                ]
            );
        }
    }
}
