<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Warga extends Model
{
    protected $table = 'warga';

    protected $fillable = [
        'nama',
        'nik',
        'keluarga_id',
        'jenis_kelamin',
        'status_domisili',
        'status_hidup',
    ];

    public function keluarga()
    {
        return $this->belongsTo(Keluarga::class);
    }
}
