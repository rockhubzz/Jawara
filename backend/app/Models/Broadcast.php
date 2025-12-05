<?php
namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Broadcast extends Model
{
    protected $table = 'broadcasts';
    protected $fillable = ['sender', 'title', 'body', 'date'];
}
