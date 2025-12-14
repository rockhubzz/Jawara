<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Keluarga extends Model
{
    protected $table = 'keluarga';

    protected $fillable = [
        'nama_keluarga',
        'kepala_keluarga',
        'kepemilikan',
        'status',
        'rumah_id',
    ];

    protected $appends = ['alamat'];

    public function rumah()
    {
        return $this->belongsTo(Rumah::class);
    }

    public function getAlamatAttribute()
    {
        return $this->rumah?->alamat;
    }
}
