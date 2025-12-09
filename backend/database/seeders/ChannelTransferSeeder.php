<?php

namespace Database\Seeders;

use App\Models\ChannelTransfer;
use Illuminate\Database\Seeder;
use App\Models\PaymentChannel;
use Illuminate\Support\Facades\Storage;

class ChannelTransferSeeder extends Seeder
{
    public function run()
    {
        // Example entries
        ChannelTransfer::create([
            'nama' => 'QRIS Resmi RT 08',
            'tipe' => 'qris',
            'an' => 'RW 08 Karangploso',
            'nomor' => null,
            'thumbnail' => null,
            'notes' => 'QRIS resmi RT 08 untuk donasi',
        ]);

        ChannelTransfer::create([
            'nama' => 'BCA',
            'tipe' => 'bank',
            'an' => 'Jose',
            'nomor' => '1234567890',
            'thumbnail' => null,
            'notes' => 'Rekening BCA RW 08',
        ]);
    }
}
