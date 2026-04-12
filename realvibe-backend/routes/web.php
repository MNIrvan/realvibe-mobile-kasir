<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Http\Request;

function getCommonData($page) {
    return [
        'page' => $page,
        'menus' => [
            ["nama" => "Ayam geprek", "sub" => "Spicy Smashed Chicken", "harga" => 15000, "img" => "image/icon_cafe.png"],
            ["nama" => "Tahu crispy", "sub" => "Crispy Tofu", "harga" => 10000, "img" => "image/icon_cafe.png"],
            ["nama" => "Mie goreng", "sub" => "Fried Noodles", "harga" => 15000, "img" => "image/icon_cafe.png"],
        ],
        'cart' => session()->get('cart', [])
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

    // Menghitung total jumlah item di keranjang
    $totalItem = array_sum(array_map(fn($item) => $item['qty'] ?? 0, $cart));

    // PERBAIKAN: Mengirim respon dalam bentuk JSON agar tidak muncul "undefined"
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

Route::get('/jadwal', function () {
    return view('landing_page', getCommonData('jadwal'));
});

Route::get('/reservasi', function () {
    return view('landing_page', getCommonData('reservasi'));
});