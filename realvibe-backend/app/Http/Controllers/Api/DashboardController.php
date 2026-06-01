<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pesanan;
use App\Models\Menu;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function summary()
    {
        $today = now()->format('Y-m-d');

        $totalPenjualan = Pesanan::whereDate('waktu_pesan', $today)
            ->whereIn('status', ['diproses', 'selesai'])
            ->count();
            
        $totalPendapatan = DB::table('pesanan')
            ->join('detail_pesanan', 'pesanan.id', '=', 'detail_pesanan.pesanan_id')
            ->whereDate('pesanan.waktu_pesan', $today)
            ->whereIn('pesanan.status', ['diproses', 'selesai'])
            ->sum(DB::raw('detail_pesanan.jumlah * detail_pesanan.harga_satuan'));

        $totalMenu = Menu::count();

        return response()->json([
            'total_penjualan' => $totalPenjualan,
            'total_pendapatan' => (int) $totalPendapatan,
            'total_menu' => $totalMenu
        ]);
    }

    public function chart(Request $request)
    {
        $filter = $request->query('filter', 'hari');
        
        $query = DB::table('pesanan')
            ->join('detail_pesanan', 'pesanan.id', '=', 'detail_pesanan.pesanan_id')
            ->whereIn('pesanan.status', ['diproses', 'selesai']);

        if ($filter === 'tahun') {
            $chartData = $query->selectRaw('YEAR(pesanan.waktu_pesan) as date, SUM(detail_pesanan.jumlah * detail_pesanan.harga_satuan) as total')
                ->groupBy('date')
                ->orderBy('date', 'asc')
                ->get();
        } elseif ($filter === 'bulan') {
            $currentYear = now()->year;
            $chartData = $query->selectRaw('DATE_FORMAT(pesanan.waktu_pesan, "%Y-%m") as date, SUM(detail_pesanan.jumlah * detail_pesanan.harga_satuan) as total')
                ->whereYear('pesanan.waktu_pesan', $currentYear)
                ->groupBy('date')
                ->orderBy('date', 'asc')
                ->get();
        } else {
            $last7Days = now()->subDays(6)->format('Y-m-d');
            $chartData = $query->selectRaw('DATE(pesanan.waktu_pesan) as date, SUM(detail_pesanan.jumlah * detail_pesanan.harga_satuan) as total')
                ->whereDate('pesanan.waktu_pesan', '>=', $last7Days)
                ->groupBy('date')
                ->orderBy('date', 'asc')
                ->get();
        }

        return response()->json($chartData);
    }

    public function trending()
    {
        $today = now()->format('Y-m-d');

        $trending = DB::table('detail_pesanan')
            ->join('pesanan', 'pesanan.id', '=', 'detail_pesanan.pesanan_id')
            ->join('menu', 'menu.id', '=', 'detail_pesanan.menu_id')
            ->select('menu.id', 'menu.nama_menu', 'menu.harga', 'menu.gambar', DB::raw('SUM(detail_pesanan.jumlah) as total_terjual'))
            ->whereDate('pesanan.waktu_pesan', $today)
            ->whereIn('pesanan.status', ['diproses', 'selesai'])
            ->groupBy('menu.id', 'menu.nama_menu', 'menu.harga', 'menu.gambar')
            ->orderBy('total_terjual', 'desc')
            ->take(3)
            ->get();

        return response()->json($trending);
    }

    public function notifications()
    {
        $notifications = Pesanan::whereIn('status', ['diproses', 'batal'])
            ->orderBy('updated_at', 'desc')
            ->take(5)
            ->get()
            ->map(function ($p) {
                $statusText = $p->status === 'diproses' ? 'disetujui' : 'ditolak';
                return [
                    'text' => "Pesanan {$p->nomor_antrian} telah {$statusText} oleh Kasir.",
                    'date' => $p->updated_at->format('d/m/Y H:i')
                ];
            });

        return response()->json($notifications);
    }
}
