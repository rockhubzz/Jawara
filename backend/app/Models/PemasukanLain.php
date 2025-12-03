<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PemasukanLain extends Model
{
    protected $table = 'pemasukan_lain';

    protected $fillable = [
        'nama',
        'jenis',
        'tanggal',
        'nominal'
    ];
}
