<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class TagihanIuran extends Model
{
    protected $table = 'tagihan_iuran';

    protected $fillable = [
        'keluarga_id',
        'kategori_iuran_id',
        'jumlah',
        'tanggal_tagihan',
        'status',
    ];

    public function keluarga()
    {
        return $this->belongsTo(Keluarga::class);
    }
    
    public function kategoriIuran()
    {
        return $this->belongsTo(KategoriIuran::class);
    }
}
