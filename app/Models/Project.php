<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Project extends Model
{
    protected $fillable = ['title', 'description', 'url', 'image_path', 'tech_stack'];

    protected $casts = ['tech_stack' => 'array'];
}
