<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Informasi;
use Illuminate\Http\Request;

class InformasiController extends Controller
{
    public function index()
    {
        return response()->json(Informasi::all());
    }

    public function store(Request $request)
    {
        $info = Informasi::create($request->all());
        return response()->json($info);
    }

    public function toggle($id)
    {
        $info = Informasi::findOrFail($id);
        $info->is_active = !$info->is_active;
        $info->save();
        
        return response()->json($info);
    }
}
