<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use App\Http\Controllers\ReservasiController;
use App\Models\Reservasi;

function getCommonData($page) {
    // Dummy Data Jadwal Kereta
    $jadwal_dummy = [
        ['id' => 1, 'tanggal' => date('Y-m-d'), 'waktu' => '08:00', 'rute' => 'Stasiun A - Stasiun B', 'kuota' => 50, 'sisa' => 5],
        ['id' => 2, 'tanggal' => date('Y-m-d'), 'waktu' => '10:30', 'rute' => 'Stasiun A - Stasiun C', 'kuota' => 40, 'sisa' => 0],
        ['id' => 3, 'tanggal' => date('Y-m-d', strtotime('+1 day')), 'waktu' => '09:00', 'rute' => 'Stasiun B - Stasiun A', 'kuota' => 50, 'sisa' => 50],
    ];

    // Data Reservasi Meja dari Database
    $meja_tersedia = 15 - Reservasi::whereDate('tanggal', date('Y-m-d'))->where('status', '!=', 'Dibatalkan')->sum('jumlah_orang'); 
    // Anda bisa menyesuaikan logika ketersediaan mejanya (di atas diasumsikan per kursi/orang)
    
    $reservasi_history = Reservasi::whereDate('tanggal', date('Y-m-d'))->get()->toArray();

    return [
        'page' => $page,
        'cart' => session()->get('cart', []),
        'jadwal_kereta' => $jadwal_dummy,
        'reservasi_history' => $reservasi_history,
        'meja_tersedia' => $meja_tersedia > 0 ? $meja_tersedia : 0
    ];
}

Route::get('/', function () {
    return view('landing_page', getCommonData('menu'));
});

Route::post('/add-to-cart', function (Request $request) {
    $cart = session()->get('cart', []);
    $nama = $request->input('nama');
    $harga = $request->input('harga');
    $img = $request->input('img');

    $found = false;
    foreach ($cart as $key => $item) {
        if (isset($item['nama']) && $item['nama'] === $nama) {
            $cart[$key]['qty']++;
            $found = true;
            break;
        }
    }

    if (! $found) {
        $cart[] = ['nama' => $nama, 'harga' => $harga, 'qty' => 1, 'img' => $img];
    }

    session()->put('cart', $cart);

    $totalItem = array_sum(array_map(fn($item) => $item['qty'] ?? 0, $cart));

    return response()->json([
        'total_item' => $totalItem
    ]);
})->name('cart.add');

Route::post('/update-cart', function (Request $request) {
    $index = $request->input('index');
    $operasi = $request->input('operasi');
    $cart = session()->get('cart', []);

    if (isset($cart[$index])) {
        if ($operasi == 'tambah') {
            $cart[$index]['qty']++;
        } else {
            $cart[$index]['qty']--;
            if ($cart[$index]['qty'] < 1) {
                array_splice($cart, $index, 1);
            }
        }
        session()->put('cart', $cart);
    }

    return redirect()->back();
})->name('update.cart');

// Logika Checkout Pemesanan Makanan (Simulasi)
Route::post('/checkout', function (Request $request) {
    $cart = session()->get('cart', []);
    if(empty($cart)) return redirect()->back();

    $orderId = 'ORD-' . date('Ymd') . '-' . strtoupper(Str::random(5));
    
    $orderData = [
        'order_id' => $orderId,
        'nama_pemesan' => $request->input('nama_pemesan', 'Guest'),
        'catatan' => $request->input('catatan', ''),
        'metode_pembayaran' => $request->input('metode_pembayaran', 'TUNAI'),
        'items' => $cart,
        'waktu_pesan' => now()
    ];

    $history = session()->get('orders_history', []);
    $history[] = $orderData;
    
    session()->put('orders_history', $history);
    session()->forget('cart'); // Clear cart after checkout

    return response()->json(['status' => 'success', 'order_id' => $orderId]);
})->name('checkout.process');

// Logika Reservasi Meja (Menyimpan ke DB & Redirect ke WA)
Route::post('/booking-meja', [ReservasiController::class, 'store'])->name('booking.meja');
Route::get('/booking-struk/{id}', [ReservasiController::class, 'struk'])->name('booking.struk');

Route::get('/jadwal', function () {
    return view('landing_page', getCommonData('jadwal'));
});

Route::get('/reservasi', function () {
    return view('landing_page', getCommonData('reservasi'));
});

