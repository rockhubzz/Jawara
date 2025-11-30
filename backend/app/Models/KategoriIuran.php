<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class KategoriIuran extends Model
{
    protected $table = 'kategori_iuran';

    protected $fillable = [
        'nama',
        'jenis',
        'nominal',
    ];
}
