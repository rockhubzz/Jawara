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
    ];

    public function keluarga()
    {
        return $this->belongsTo(\App\Models\Keluarga::class, 'keluarga_id');
    }
}
