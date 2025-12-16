<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MutasiKeluarga extends Model
{
    protected $table = 'mutasi_keluarga';

    protected $fillable = [
        'keluarga_id',
        'jenis_mutasi',
        'tanggal',
        'alasan',
        'nama_keluarga',
        'kepala_keluarga',
        'alamat',
        'kepemilikan',
        'status_keluarga',
        'rumah_id',
    ];

    public function keluarga()
    {
        return $this->belongsTo(\App\Models\Keluarga::class, 'keluarga_id');
    }
}
