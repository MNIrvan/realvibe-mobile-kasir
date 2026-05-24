<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use Illuminate\Http\Request;

class TransactionController extends Controller
{
    public function index(Request $request)
    {
        $query = Transaction::with('kasir');
        
        if ($request->has('start_date') && $request->has('end_date')) {
            $query->whereBetween('created_at', [$request->start_date, $request->end_date]);
        }

        return response()->json($query->latest()->get());
    }

    public function export(Request $request)
    {
        // Simulasi export data laporan
        return response()->json([
            'message' => 'Fungsi export dijalankan. Di sini Anda bisa mengunduh PDF/Excel.',
            'url' => 'http://example.com/download/laporan.pdf'
        ]);
    }
}
