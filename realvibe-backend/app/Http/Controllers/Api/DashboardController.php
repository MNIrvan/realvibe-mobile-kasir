<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Transaction;
use App\Models\Menu;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function summary()
    {
        $today = now()->format('Y-m-d');

        $totalPenjualan = Transaction::whereDate('created_at', $today)->count();
        $totalPendapatan = Transaction::whereDate('created_at', $today)->sum('grand_total');
        // Anggap tabel Menu ada
        $totalMenu = 25; 

        return response()->json([
            'total_penjualan' => $totalPenjualan,
            'total_pendapatan' => (int) $totalPendapatan,
            'total_menu' => $totalMenu
        ]);
    }

    public function chart()
    {
        $last7Days = now()->subDays(6)->format('Y-m-d');
        
        $chartData = Transaction::selectRaw('DATE(created_at) as date, SUM(grand_total) as total')
            ->whereDate('created_at', '>=', $last7Days)
            ->groupBy('date')
            ->orderBy('date', 'asc')
            ->get();

        return response()->json($chartData);
    }
}
