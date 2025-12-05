<?php
namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class BroadcastSeeder extends Seeder
{
    public function run(): void
    {
        $now = Carbon::now();
        DB::table('broadcasts')->insert([
            [
                'sender' => 'Admin Jawara',
                'title' => 'Gotong Royong di Kampus Polinema',
                'body' => 'Ajak seluruh warga untuk bergotong royong membersihkan kampus.',
                'date' => $now->copy()->subDays(7)->toDateString(),
                'created_at' => $now,
                'updated_at' => $now,
            ],
            [
                'sender' => 'Admin Jawara',
                'title' => 'Kerja Bakti Bersama Masyarakat Sekitar',
                'body' => 'Undangan kerja bakti minggu depan di halaman RT.',
                'date' => $now->copy()->subDays(10)->toDateString(),
                'created_at' => $now,
                'updated_at' => $now,
            ],
        ]);
    }
}
