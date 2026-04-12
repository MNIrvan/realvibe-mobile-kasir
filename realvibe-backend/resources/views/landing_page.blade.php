@php
// HAPUS session_start() karena Laravel mengelolanya secara otomatis
// Logika PHP dipindahkan ke sintaks Blade agar lebih bersih

$page = request('page', 'menu');
$kategori_aktif = request('kategori', 'snack');
$search_query = strtolower(request('search', ''));

$semua_menu = [
    "snack" => [
        // PERBAIKAN: Ubah gambar di sini dengan foto makanan yang besar (memanjang).
        // Pastikan Daniel sudah memasukkan file foto besarnya ke dalam folder 'public/image/' dengan nama 'banner_makanan.jpg' (sebagai contoh).
        ["nama" => "Ayam geprek", "sub" => "Spicy Smashed Chicken", "harga" => "15.000,00", "img" => "resources/image/WWW.jpg"],
        ["nama" => "Tahu crispy", "sub" => "Crispy Tofu", "harga" => "10.000,00", "img" => "resources/image/tahu.jpg"],
    ],
    "makanan" => [
        ["nama" => "Mie Goreng", "sub" => "Fried Noodles", "harga" => "15.000,00", "img" => "resources/image/mie.jpg"],
    ],
    "minuman" => [
        ["nama" => "Es Teh", "sub" => "Iced Tea", "harga" => "5.000,00", "img" => "resources/image/teh.jpg"],
    ],
    "dessert" => [
        ["nama" => "Pudding Coklat", "sub" => "Chocolate", "harga" => "8.000,00", "img" => "resources/image/pudding.jpg"],
    ]
];

$menu_tampil = $semua_menu[$kategori_aktif] ?? [];

if (!empty($search_query)) {
    $menu_tampil = [];
    foreach ($semua_menu as $cat => $items) {
        foreach ($items as $item) {
            if (strpos(strtolower($item['nama']), $search_query) !== false) {
                $menu_tampil[] = $item;
            }
        }
    }
}

// Ambil cart dari session Laravel
$cart = session('cart', []);
@endphp

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Realvibe - Food App</title>
    
    <meta name="csrf-token" content="{{ csrf_token() }}">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.css" />

    <style>
        :root { 
            --primary-red: #D32F2F; 
            --dark-red: #801a1a; 
            --bg-gray: #f8f9fa; 
            --cream-bg: #FFF5E1; 
            --text-brown: #5D2A18;
            --brand-orange: #B32E00;
        }
        
        #onboarding-screen {
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background-color: #FDF5ED;
            z-index: 10000;
            display: none; 
            transition: transform 0.8s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .swiper { width: 100%; height: 100%; }

        .slide-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100%;
            padding: 40px;
            text-align: center;
            color: var(--text-brown);
            cursor: pointer;
        }

        .logo-onboard-large { width: 350px; margin-bottom: 20px; animation: fadeIn 1.5s; }
        @keyframes fadeIn { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }
        .logo-onboard-small { width: 180px; margin-bottom: 40px; }
        
        .grid-menu-onboard {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 40px;
            max-width: 900px;
        }
        .grid-menu-onboard img {
            width: 100%;
            aspect-ratio: 1/1;
            object-fit: cover;
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }

        .title-onboard-new { font-weight: 800; font-size: 3rem; margin-bottom: 15px; color: var(--brand-orange); }
        .desc-onboard-new { font-size: 1.2rem; opacity: 0.8; max-width: 600px; line-height: 1.6; color: #7A6E6A; }

        .onboard-nav-new {
            position: absolute;
            bottom: 50px;
            width: 100%;
            padding: 0 100px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            z-index: 10;
        }

        .btn-skip-new, .btn-next-new { background: #E0E0E0; border: none; padding: 12px 40px; border-radius: 12px; font-weight: bold; color: #555; }
        .btn-get-started-new { 
            background: var(--brand-orange); color: white; border: none; width: 350px; 
            padding: 20px; border-radius: 15px; font-weight: bold; font-size: 1.3rem; 
            text-transform: uppercase; display: none; box-shadow: 0 8px 20px rgba(179, 46, 0, 0.3);
        }

        .swiper-pagination-bullet { background: #ccc !important; opacity: 1; width: 12px; height: 12px; }
        .swiper-pagination-bullet-active { background: var(--brand-orange) !important; width: 40px; border-radius: 5px; }

        body { background-color: var(--bg-gray); font-family: 'Segoe UI', sans-serif; padding-bottom: 100px; }
        .header-custom { background-color: var(--primary-red); border-bottom-left-radius: 30px; border-bottom-right-radius: 30px; padding: 40px 20px 80px; color: white; }
        .promo-slider { margin: 20px 10px; border-radius: 20px; overflow: hidden; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        .carousel-item { background: linear-gradient(45deg, #7B1F1F, #D32F2F); padding: 30px 20px; min-height: 160px; color: white; }
        .category-card { background: white; border-radius: 15px; padding: 10px; text-align: center; border: 1px solid #eee; min-width: 80px; transition: 0.3s; cursor: pointer; }
        .category-card.active { border: 2px solid var(--primary-red); box-shadow: 0 4px 8px rgba(211, 47, 47, 0.2); }
        .menu-card { border-radius: 20px; border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.05); text-align: center; padding: 15px; background: white; height: 100%; }
        .menu-card img { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; }
        .btn-tambah { background-color: var(--primary-red); color: white; border-radius: 50px; border: none; width: 100%; font-size: 0.8rem; }
        
        .bottom-nav { position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); background: white; border-radius: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); display: flex; padding: 10px 20px; width: 90%; justify-content: space-around; z-index: 1000; }
        .nav-item { text-align: center; color: #888; font-size: 0.7rem; text-decoration: none; }
        .nav-item.active { color: var(--primary-red); font-weight: bold; }
        
        .modal-header-custom { background-color: var(--dark-red); color: white; border-radius: 0 0 30px 30px; padding: 30px 20px; border: none; }
        .cart-item-card { border-radius: 20px; border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 12px; padding: 10px; background: white; }
        .qty-control { background: #f1f1f1; border-radius: 50px; padding: 2px 8px; display: flex; align-items: center; }
        .btn-qty { border: none; background: none; color: var(--primary-red); font-weight: bold; }
        
        .checkout-summary-box { background: #fff; border-radius: 15px; padding: 15px; border: 1px solid #eee; display: flex; align-items: center; }
        .payment-option { border: 2px solid #eee; border-radius: 12px; padding: 15px; text-align: center; cursor: pointer; flex: 1; transition: 0.3s; }
        .payment-option.active { border-color: var(--primary-red); background: #fff5f5; color: var(--primary-red); }
        .form-label-small { font-size: 0.8rem; font-weight: bold; color: #555; }
        .input-checkout { border-radius: 10px; background: #f8f9fa; border: 1px solid #eee; padding: 10px; font-size: 0.9rem; }
        
        .success-icon { width: 100px; height: 100px; background: #fff; border-radius: 20px; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.1); }
        .card-custom { border-radius: 15px; border: none; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }
        .table-custom thead { background-color: var(--primary-red); color: white; }

        .summary-card-gray { background: #F5F5F5 !important; border: none !important; border-radius: 20px !important; }
        .input-gray-custom { background: #F1F1F1 !important; border: none !important; border-radius: 12px !important; padding: 12px !important; }

        .sticky-search-container {
            position: sticky;
            top: 10px; 
            z-index: 1050;
            padding: 0 15px; 
            margin-top: -35px; 
        }

        .sticky-search-inner {
            background-color: white;
            border-radius: 50px; 
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            overflow: hidden;
        }
    </style>
</head>
<body>

    <div id="onboarding-screen">
        <div class="swiper mySwiper">
            <div class="swiper-wrapper">
                <div class="swiper-slide" onclick="goNext()">
                    <div class="slide-content">
                        <img src="{{ asset('/images/icon_cafe.png') }}" class="logo-onboard-large" alt="Logo">
                    </div>
                </div>
                <div class="swiper-slide" onclick="goNext()">
                    <div class="slide-content">
                        <img src="{{ asset('/images/icon_cafe.png') }}" class="logo-onboard-small" alt="Logo">
                        <h2 class="title-onboard-new">Selamat Datang</h2>
                        <p class="desc-onboard-new">Real Cafe Jatiroto. Temukan setiap sudut, setiap cita, dan cerita yang menunggu untuk kamu rasakan.</p>
                    </div>
                </div>
                <div class="swiper-slide">
                    <div class="slide-content">
                        <div class="grid-menu-onboard">
                            <img src="{{ asset('/image/icon_cafe.png') }}"><img src="{{ asset('/image/icon_cafe.png') }}">
                            <img src="{{ asset('/image/icon_cafe.png') }}"><img src="{{ asset('/image/icon_cafe.png') }}">
                            <img src="{{ asset('/image/icon_cafe.png') }}"><img src="{{ asset('/image/icon_cafe.png') }}">
                            <img src="{{ asset('/image/icon_cafe.png') }}"><img src="{{ asset('/image/icon_cafe.png') }}">
                        </div>
                        <h2 class="title-onboard-new">Pesan menu pilihanmu!</h2>
                        <button class="btn-get-started-new" onclick="finishOnboarding()">Get Started</button>
                    </div>
                </div>
            </div>
            <div class="swiper-pagination"></div>
            <div class="onboard-nav-new" id="nav-group-new">
                <button class="btn-skip-new" onclick="finishOnboarding()">Skip</button>
                <button class="btn-next-new" onclick="goNext()">Next</button>
            </div>
        </div>
    </div>

    <div class="header-custom d-flex justify-content-between align-items-center">
        <div><i class="fas fa-user-circle fa-2x"></i> <span class="ms-2 fw-bold">Welcome, Customer</span></div>
        <div class="position-relative" style="cursor: pointer;" data-bs-toggle="modal" data-bs-target="#cartModal">
            <i class="fas fa-shopping-cart fa-lg"></i>
            <span id="cart-badge" class="badge rounded-pill bg-warning text-dark position-absolute top-0 start-100 translate-middle">
                {{ array_sum(array_column(session('cart', []), 'qty')) }}
            </span>
        </div>
    </div>

    <div class="container">
        @if($page == 'menu')
            <div class="sticky-search-container">
                <div class="sticky-search-inner">
                    <form id="searchForm" action="" method="GET" class="m-0">
                        <input type="hidden" name="page" value="menu">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-0 ps-3"><i class="fas fa-bars"></i></span>
                            <input type="text" name="search" class="form-control border-0 py-2" placeholder="Cari menu..." value="{{ $search_query }}" onkeyup="this.form.submit()">
                            <button type="submit" class="btn bg-white border-0 pe-3"><i class="fas fa-search text-muted"></i></button>
                        </div>
                    </form>
                </div>
            </div>

            @if(empty($search_query))
            <div id="promoCarousel" class="carousel slide promo-slider" data-bs-ride="carousel" data-bs-interval="3000">
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#promoCarousel" data-bs-slide-to="0" class="active"></button>
                    <button type="button" data-bs-target="#promoCarousel" data-bs-slide-to="1"></button>
                    <button type="button" data-bs-target="#promoCarousel" data-bs-slide-to="2"></button>
                </div>
                <div class="carousel-inner">
                    <div class="carousel-item active">
                        <div class="d-flex justify-content-between align-items-center p-0"> <div class="p-4 flex-grow-1"> <small class="d-block mb-1">BURGERS REAL</small>
                                <h3 class="fw-bold mb-2">10% OFF</h3>
                                <button class="btn btn-light btn-sm rounded-pill px-3 fw-bold text-danger">Pesan Sekarang</button>
                            </div>
                           <img src="{{ asset('/images/banner_realvibe (3).png') }}" style="width: 200px;" alt="Burger">
                        </div>
                    </div>
                    <div class="carousel-item">
                        <div class="d-flex justify-content-between align-items-center p-0"> <div class="p-4 flex-grow-1"> <small class="d-block mb-1">FRESH DRINK</small>
                                <h3 class="fw-bold mb-2">BUY 1 GET 1</h3>
                                <button class="btn btn-light btn-sm rounded-pill px-3 fw-bold text-danger">Ambil Promo</button>
                            </div>
                             <img src="{{ asset('/images/banner_realvibe (2).png') }}" style="width: 200px;" alt="Burger">
                        </div>
                    </div>
                    <div class="carousel-item">
                        <div class="d-flex justify-content-between align-items-center p-0"> <div class="p-4 flex-grow-1"> <small class="d-block mb-1">DISKON KHUSUS</small>
                                <h3 class="fw-bold mb-2">FREE ONGKIR</h3>
                                <button class="btn btn-light btn-sm rounded-pill px-3 fw-bold text-danger">Cek Lokasi</button>
                            </div>
                             <img src="{{ asset('/images/banner_realvibe (1).png') }}" style="width: 200px;" alt="Burger">
                        </div>
                    </div>
                </div>
            </div>
            @endif

            <div class="px-2 mb-4">
                <h6 class="fw-bold">Kategori</h6>
                <div class="d-flex gap-3 overflow-auto pb-2">
                    @foreach(['snack', 'makanan', 'minuman', 'dessert'] as $cat)
                    <a href="?page=menu&kategori={{ $cat }}" class="text-decoration-none text-dark">
                        <div class="category-card {{ ($kategori_aktif == $cat && empty($search_query)) ? 'active' : '' }}">
                            <i class="fas fa-utensils text-danger d-block mb-1"></i>
                            <small>{{ ucfirst($cat) }}</small>
                        </div>
                    </a>
                    @endforeach
                </div>
            </div>

            <div class="px-2">
                <h6 class="fw-bold mb-3">{{ !empty($search_query) ? "Hasil pencarian: '$search_query'" : "Menu ".ucfirst($kategori_aktif) }}</h6>
                <div class="row g-3">
                    @if(empty($menu_tampil))
                        <div class="col-12 text-center text-muted py-5">Menu tidak ditemukan :(</div>
                    @else
                        @foreach($menu_tampil as $m)
                        <div class="col-6">
                            <div class="card menu-card">
                                <img src="{{ asset($m['img']) }}" class="mx-auto mt-2" onerror="this.src='https://via.placeholder.com/150?text=Menu'">
                                <div class="card-body p-2 mt-2">
                                    <div class="fw-bold small">{{ $m['nama'] }}</div>
                                    <div class="text-muted mb-2" style="font-size: 0.6rem;">{{ $m['sub'] }}</div>
                                    <div class="text-danger fw-bold mb-2">Rp {{ $m['harga'] }}</div>
                                    <button class="btn btn-tambah py-1 btn-beli" data-nama="{{ $m['nama'] }}" data-harga="{{ $m['harga'] }}">+ Tambah</button>
                                </div>
                            </div>
                        </div>
                        @endforeach
                    @endif
                </div>
            </div>

        @elseif($page == 'jadwal')
            <div class="p-3">
                <h5 class="fw-bold mb-3"><i class="fas fa-train text-danger me-2"></i>Jadwal Keberangkatan</h5>
                <div class="card card-custom overflow-hidden">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0 table-custom">
                            <thead>
                                <tr><th>Kereta</th><th>Tujuan</th><th>Jam</th><th>Status</th></tr>
                            </thead>
                            <tbody class="small">
                                <tr><td>Realvibe Express</td><td>Lumajang</td><td>08:00</td><td><span class="badge bg-success">On Time</span></td></tr>
                                <tr><td>PSDKU Liner</td><td>Malang</td><td>10:30</td><td><span class="badge bg-success">On Time</span></td></tr>
                                <tr><td>Mutiara Timur</td><td>Surabaya</td><td>13:45</td><td><span class="badge bg-warning">Delayed</span></td></tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

        @elseif($page == 'reservasi')
            <div class="p-3">
                <h5 class="fw-bold mb-3"><i class="fas fa-calendar-alt text-danger me-2"></i>Manajemen Reservasi</h5>
                <div class="row g-3">
                    <div class="col-6">
                        <div class="card card-custom p-3 text-center">
                            <i class="fas fa-chair text-danger mb-2"></i>
                            <h4 class="fw-bold mb-0">12</h4>
                            <small class="text-muted" style="font-size: 0.7rem;">Meja Tersedia</small>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="card card-custom p-3 text-center">
                            <i class="fas fa-users text-primary mb-2"></i>
                            <h4 class="fw-bold mb-0">5</h4>
                            <small class="text-muted" style="font-size: 0.7rem;">Booking Hari Ini</small>
                        </div>
                    </div>
                </div>
                <div class="mt-4">
                    <button class="btn btn-danger w-100 py-3 fw-bold shadow-sm" style="border-radius: 15px;">BUAT RESERVASI MEJA</button>
                </div>
            </div>
        @endif
    </div>

    <div class="modal fade" id="cartModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-fullscreen-sm-down">
            <div class="modal-content" style="background-color: #f8f9fa;">
                <div class="modal-header modal-header-custom">
                    <button type="button" class="btn text-white p-0" data-bs-dismiss="modal"><i class="fas fa-arrow-left fa-lg"></i></button>
                    <h5 class="modal-title fw-bold ms-3">Pesananmu</h5>
                </div>
                <div class="modal-body p-3">
                    @php $total_bayar = 0; @endphp
                    @if(empty($cart))
                        <div class="text-center py-5"><p class="text-muted">Belum ada pesanan.</p></div>
                    @else
                        @foreach($cart as $index => $item)
                        @php 
                            $harga_clean = (int)str_replace(['.', ',00'], '', $item['harga'] ?? '0');
                            $subtotal = $harga_clean * ($item['qty'] ?? 0);
                            $total_bayar += $subtotal;
                        @endphp
                        <div class="card cart-item-card">
                            <div class="d-flex align-items-center">
                                <img src="{{ asset($item['img'] ?? '') }}" style="width: 50px; height: 50px; border-radius: 10px; object-fit: cover;" onerror="this.src='https://via.placeholder.com/60'">
                                <div class="ms-3 flex-grow-1">
                                    <div class="fw-bold small">{{ $item['nama'] ?? 'Menu' }}</div>
                                    <div class="text-danger fw-bold small">Rp {{ $item['harga'] ?? '0' }}</div>
                                </div>
                                <div class="qty-control">
                                    <form action="{{ route('update.cart') }}" method="POST" class="m-0">
                                        @csrf
                                        <input type="hidden" name="index" value="{{ $index }}">
                                        <button name="operasi" value="kurang" class="btn-qty">-</button>
                                    </form>
                                    <span class="small fw-bold mx-2">{{ $item['qty'] }}</span>
                                    <form action="{{ route('update.cart') }}" method="POST" class="m-0">
                                        @csrf
                                        <input type="hidden" name="index" value="{{ $index }}">
                                        <button name="operasi" value="tambah" class="btn-qty">+</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                        @endforeach
                        <div class="mt-4 px-2">
                            <div class="d-flex justify-content-between small mb-1"><span>Total Item</span><span>Rp {{ number_format($total_bayar, 0, ',', '.') }},00</span></div>
                            <div class="d-flex justify-content-between small mb-3"><span>Biaya Admin</span><span class="text-success">Free</span></div>
                            <div class="d-flex justify-content-between align-items-center border-top pt-3">
                                <h6 class="fw-bold">Total Biaya</h6>
                                <h5 class="fw-bold text-danger">Rp {{ number_format($total_bayar, 0, ',', '.') }},00</h5>
                            </div>
                            <button class="btn btn-danger w-100 py-3 mt-3 fw-bold" style="border-radius: 15px;" data-bs-toggle="modal" data-bs-target="#checkoutModal">KONFIRMASI PESANAN</button>
                        </div>
                    @endif
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="checkoutModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0" style="border-radius: 25px;">
                <div class="modal-body p-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h5 class="fw-bold m-0">Ringkasan Pesanan</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <label class="form-label-small mb-2">Pesanan Saya</label>
                    <div class="checkout-summary-box summary-card-gray mb-3">
                        <img src="https://cdn-icons-png.flaticon.com/512/2276/2276931.png" style="width: 50px;" class="me-3">
                        <div>
                            <h5 class="fw-bold mb-0">Rp {{ number_format($total_bayar, 0, ',', '.') }},00</h5>
                            <small class="text-muted">Total Bayar</small>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label-small">Catatan Pesanan</label>
                        <input type="text" class="form-control input-gray-custom" placeholder="Contoh: Pedas ya...">
                    </div>
                    <div class="mb-3">
                        <label class="form-label-small">Nama Pemesan</label>
                        <input type="text" class="form-control input-gray-custom" placeholder="Masukkan nama Anda">
                    </div>
                    <label class="form-label-small mb-2">Metode Pembayaran</label>
                    <div class="d-flex gap-3 mb-4">
                        <div class="payment-option active" onclick="selectPayment(this)"><i class="fas fa-money-bill-wave d-block mb-1"></i><small>TUNAI</small></div>
                        <div class="payment-option" onclick="selectPayment(this)"><i class="fas fa-qrcode d-block mb-1"></i><small>QRIS</small></div>
                    </div>
                    <button class="btn btn-danger w-100 py-3 fw-bold" style="border-radius: 15px; background-color: var(--brand-orange);" id="btn-submit-order">PESAN SEKARANG</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="successModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content text-center border-0" style="border-radius: 25px; background: #f8f9fa;">
                <div class="modal-body p-5">
                    <div class="success-icon">
                        <img src="https://cdn-icons-png.flaticon.com/512/3135/3135715.png" style="width: 80px;">
                    </div>
                    <h4 class="fw-bold">Terimakasih !</h4>
                    <p class="text-muted small">Pesanan Anda berhasil dibuat. Silakan lakukan pembayaran di kasir dan berikan penilaian Anda.</p>
                    <button class="btn btn-danger px-5 py-2 mt-3 fw-bold" style="border-radius: 10px; background-color: #801a1a;" onclick="location.reload()">Oke</button>
                </div>
            </div>
        </div>
    </div>

    <div class="bottom-nav">
        <a href="?page=menu" class="nav-item {{ $page == 'menu' ? 'active' : '' }}"><i class="fas fa-utensils d-block fa-lg mb-1"></i>Menu</a>
        <a href="?page=jadwal" class="nav-item {{ $page == 'jadwal' ? 'active' : '' }}"><i class="fas fa-train d-block fa-lg mb-1"></i>Jadwal</a>
        <a href="?page=reservasi" class="nav-item {{ $page == 'reservasi' ? 'active' : '' }}"><i class="fas fa-clipboard-list d-block fa-lg mb-1"></i>Reservasi</a>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/swiper@11/swiper-bundle.min.js"></script>
    
    <script>
    // 1. LOGIKA ONBOARDING
    document.addEventListener("DOMContentLoaded", function() {
        const screen = document.getElementById('onboarding-screen');
        const isAppOpen = sessionStorage.getItem('app_session_active');
        if (!isAppOpen) {
            screen.style.display = 'block';
        } else {
            screen.style.display = 'none';
        }

        var promoCarousel = document.getElementById('promoCarousel');
        if (promoCarousel) {
            var carousel = new bootstrap.Carousel(promoCarousel, {
                interval: 3000, 
                ride: 'carousel'
            });
            carousel.cycle(); 
        }

        // FOKUSKAN KURSOR KE INPUT SETELAH AUTO-SUBMIT (BIAR NYAMAN)
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.has('search')) {
            const input = document.getElementsByName('search')[0];
            if(input) {
                input.focus();
                input.setSelectionRange(input.value.length, input.value.length);
            }
        }
    });

    // 2. SWIPER CONFIG
    const swiper = new Swiper(".mySwiper", {
        pagination: { el: ".swiper-pagination", clickable: true },
        speed: 800, 
        autoplay: {
            delay: 3000,
            disableOnInteraction: false,
        },
        on: {
            slideChange: function () {
                const navGroup = document.getElementById('nav-group-new');
                const startBtn = document.querySelector('.btn-get-started-new');
                if (this.activeIndex === 2) {
                    navGroup.style.display = 'none';
                    if(startBtn) startBtn.style.display = 'block';
                    this.autoplay.stop(); 
                } else {
                    navGroup.style.display = 'flex';
                    if(startBtn) startBtn.style.display = 'none';
                }
            },
        },
    });

    function goNext() { if (swiper.activeIndex < 2) swiper.slideNext(); }
    function finishOnboarding() {
        const screen = document.getElementById('onboarding-screen');
        screen.style.transform = 'translateY(-100%)';
        sessionStorage.setItem('app_session_active', 'true');
        setTimeout(() => { screen.style.display = 'none'; }, 800);
    }

    // 3. LOGIKA KERANJANG
    document.querySelectorAll('.btn-beli').forEach(button => {
        button.addEventListener('click', function() {
            const nama = this.getAttribute('data-nama');
            const harga = this.getAttribute('data-harga');
            const img = this.closest('.menu-card').querySelector('img').getAttribute('src'); 
            
            const formData = new FormData();
            formData.append('nama', nama);
            formData.append('harga', harga);
            formData.append('img', img);
            
            const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

            fetch('/add-to-cart', { 
                method: 'POST', 
                body: formData,
                headers: { 'X-CSRF-TOKEN': token }
            })
            .then(res => res.json())
            .then(data => {
                document.getElementById('cart-badge').innerText = data.total_item;
                this.innerHTML = "✓ Berhasil";
                this.classList.replace('btn-tambah', 'btn-success');
                setTimeout(() => {
                    this.innerHTML = "+ Tambah";    
                    this.classList.replace('btn-success', 'btn-tambah');
                }, 800);
            });
        });
    });

    document.getElementById('btn-submit-order').addEventListener('click', function() {
        const checkoutModal = bootstrap.Modal.getInstance(document.getElementById('checkoutModal'));
        if(checkoutModal) checkoutModal.hide();
        setTimeout(() => {
            const successModal = new bootstrap.Modal(document.getElementById('successModal'));
            successModal.show();
        }, 500);
    });

    function selectPayment(el) {
        document.querySelectorAll('.payment-option').forEach(opt => opt.classList.remove('active'));
        el.classList.add('active');
    }
    </script>
</body>
</html>