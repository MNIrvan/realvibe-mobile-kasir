@php
$page = request('page', 'menu');
@endphp

    <!DOCTYPE html>
    <html lang="id">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Realvibe - Food App</title>
        
        <meta name="csrf-token" content="{{ csrf_token() }}">

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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
                width: 100%;
                padding: 20px;
                text-align: center;
                color: var(--text-brown);
                cursor: pointer;
            }

            .logo-onboard-large { 
                max-width: 300px; 
                width: 80%;
                height: auto;
                margin: auto; 
                animation: fadeIn 1.5s; 
            }

            @keyframes fadeIn { from { opacity: 0; transform: scale(0.9); } to { opacity: 1; transform: scale(1); } }
            .logo-onboard-small { width: 150px; margin-bottom: 20px; }

            .grid-container-onboard {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 8px;
                padding: 10px;
                width: 100%;
                max-width: 400px;
            }

            .grid-container-onboard img {
                width: 100%;
                aspect-ratio: 1/1;
                object-fit: cover;
                border-radius: 12px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }

            .img-tall { grid-row: span 2; aspect-ratio: 1/2 !important; }
            
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

            .title-onboard-new { 
                font-weight: 800; 
                font-size: 1.8rem; 
                margin-bottom: 8px; 
                color: var(--brand-orange); 
                line-height: 1.2;
            }
            
            .desc-onboard-new { 
                font-size: 0.8rem; 
                opacity: 0.9; 
                max-width: 260px; 
                margin: 0 auto;
                line-height: 1.4; 
                color: var(--brand-orange);
            }

            .onboard-nav-new {
                position: absolute; 
                bottom: 40px; 
                width: 100%;
                display: flex; 
                justify-content: space-between; 
                padding: 0 40px; 
                z-index: 10;
            }

            .btn-skip-new, .btn-next-new { 
                background: #E0E0E0; 
                border: none; 
                padding: 8px 30px; 
                border-radius: 10px; 
                font-weight: bold; 
                color: #555; 
                font-size: 0.85rem;
            }

            .btn-get-started-new { 
                background: var(--brand-orange); 
                color: white; 
                border: none; 
                width: 280px; 
                padding: 14px; 
                border-radius: 15px; 
                font-weight: bold; 
                font-size: 1rem; 
                text-transform: none; 
                display: none; 
                box-shadow: 0 8px 20px rgba(179, 46, 0, 0.3);
                margin-top: 150px; 
                margin-bottom: 20px;    
            }

            .swiper-pagination {
                bottom: 180px !important;
            }

            .swiper-pagination-bullet { background: #ccc !important; opacity: 1; width: 10px; height: 10px; }
            .swiper-pagination-bullet-active { background: var(--brand-orange) !important; width: 30px; border-radius: 5px; }

            body { background-color: var(--bg-gray); font-family: 'Segoe UI', sans-serif; padding-bottom: 100px; }
            .header-custom { background-color: var(--primary-red); border-bottom-left-radius: 30px; border-bottom-right-radius: 30px; padding: 40px 20px 80px; color: white; }
            .promo-slider { margin: 20px 10px; border-radius: 20px; overflow: hidden; box-shadow: 0 8px 25px rgba(0,0,0,0.1); border: none; background-color: #fff; }
            .carousel-item { height: 190px; background-color: #ffffff; }
            .carousel-item img { width: 100%; height: 100%; object-fit: contain; display: block; }
            .carousel-indicators { bottom: 10px; }
            .carousel-indicators [data-bs-target] { width: 8px; height: 8px; border-radius: 50%; }
            .carousel-indicators .active { width: 25px; border-radius: 10px; background-color: var(--primary-red); }

            .category-card {
                background: white;
                border-radius: 15px;
                padding: 15px 10px;
                text-align: center;
                border: 2px solid transparent; 
                min-width: 100px;
                transition: all 0.3s ease;
                cursor: pointer;
                box-shadow: 0 4px 10px rgba(0,0,0,0.08);
                display: flex;
                flex-direction: column;
                align-items: center;
                gap: 10px;
            }

            .category-card.active {
                border-color: #B32E00;
                background-color: white;
            }

            .category-icon-wrapper {
                width: 85px; 
                height: 85px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 24px;
                background: #ffffff; 
                box-shadow: 0 10px 20px rgba(0,0,0,0.05), 0 6px 6px rgba(0,0,0,0.02);
                transition: all 0.4s cubic-bezier(0.165, 0.84, 0.44, 1);
                position: relative;
                overflow: hidden;
            }

            .waaaw-icon {
                width: 60%; 
                height: 60%;
                object-fit: contain;
                transition: all 0.4s ease;
                filter: drop-shadow(0 2px 4px rgba(0,0,0,0.1));
            }

            .category-name {
                font-weight: 700;
                font-size: 0.9rem;
                color: #444;
                transition: all 0.3s ease;
            }

            .category-card:hover .category-icon-wrapper {
                transform: translateY(-8px) scale(1.03);
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                background: #fafafa;
            }

            .category-card.active .category-icon-wrapper {
                background: linear-gradient(135deg, #ff9a9e 0%, #fad0c4 99%, #fad0c4 100%);
                box-shadow: 0 15px 30px rgba(255, 154, 158, 0.4);
                animation: iconPulse 1.5s infinite;
            }

            @keyframes iconPulse {
                0% { box-shadow: 0 0 0 0 rgba(255, 154, 158, 0.7); }
                70% { box-shadow: 0 0 0 15px rgba(255, 154, 158, 0); }
                100% { box-shadow: 0 0 0 0 rgba(255, 154, 158, 0); }
            }

            .overflow-auto::-webkit-scrollbar { display: none; }
            
            .menu-card { 
                border-radius: 20px; border: none; box-shadow: 0 5px 15px rgba(0,0,0,0.05); 
                text-align: center; padding: 15px; background: white; height: 100%; 
                transition: 0.3s transform;
            }
            .menu-card img { width: 85px; height: 85px; border-radius: 50%; object-fit: cover; }
            .btn-tambah { background-color: var(--primary-red); color: white; border-radius: 50px; border: none; width: 100%; font-size: 0.8rem; font-weight: bold; }
            
            .bottom-nav { position: fixed; bottom: 20px; left: 50%; transform: translateX(-50%); background: white; border-radius: 20px; box-shadow: 0 5px 20px rgba(0,0,0,0.1); display: flex; padding: 10px 20px; width: 90%; justify-content: space-around; z-index: 1000; }
            .nav-item { text-align: center; color: #888; font-size: 0.7rem; text-decoration: none; }
            .nav-item.active { color: var(--primary-red); font-weight: bold; }
            
            .modal-header-custom { background-color: var(--dark-red); color: white; border-radius: 0 0 30px 30px; padding: 30px 20px; border: none; }
            .cart-item-card { border-radius: 20px; border: none; box-shadow: 0 4px 15px rgba(0,0,0,0.05); margin-bottom: 12px; padding: 12px; background: white; }
            .cart-item-card img { border-radius: 50%; object-fit: cover; width: 60px; height: 60px; }
            .cart-header-curve { background-color: #962519; height: 180px; border-bottom-left-radius: 50%; border-bottom-right-radius: 50%; display: flex; align-items: center; padding: 0 30px; position: relative; color: white; margin-bottom: 20px; }
            .qty-control { display: flex; align-items: center; gap: 10px; background: #F8F9FA; padding: 5px 12px; border-radius: 20px; }
            .btn-qty { background: transparent; border: none; font-weight: bold; font-size: 1.1rem; color: #962519; padding: 0; min-width: 20px; text-align: center; }
            .qty-control { background: #f1f1f1; border-radius: 50px; padding: 2px 8px; display: flex; align-items: center; }
            .btn-qty { border: none; background: none; color: var(--primary-red); font-weight: bold; }
            
            .checkout-summary-box { background: #fff; border-radius: 15px; padding: 15px; border: 1px solid #eee; display: flex; align-items: center; }
            .payment-option { border: 2px solid #eee; border-radius: 12px; padding: 15px; text-align: center; cursor: pointer; flex: 1; transition: 0.3s; }
            .payment-option.active { border-color: var(--primary-red); background: #fff5f5; color: var(--primary-red); }
            
            .sticky-search-container { position: sticky; top: 10px; z-index: 1050; padding: 0 15px; margin-top: -35px; }
            .sticky-search-inner { background-color: white; border-radius: 50px; box-shadow: 0 4px 12px rgba(0,0,0,0.1); overflow: hidden; }

            .wa-float-btn { position: fixed; bottom: 100px; left: 25px; background-color: #25d366; color: white; width: 55px; height: 55px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 28px; box-shadow: 2px 5px 15px rgba(0,0,0,0.2); z-index: 2000; text-decoration: none; transition: 0.3s; }

            .modal-success-content { border-radius: 35px !important; border: 4px solid #A52A2A !important; background: #fdfdfd !important; overflow: visible !important; padding-top: 20px; }
            .success-maskot-container { margin-top: -110px; position: relative; z-index: 10; }

            .maskot-jadwal-wrapper { position: absolute; bottom: -35px; right: 0px; z-index: 100; }
            .maskot-jadwal-img { width: 130px; height: auto; }

            /* ========================================= */
            /* PENYESUAIAN DETAIL MODAL (REVISI KECIL)    */
            /* ========================================= */
            #detailModal .modal-dialog { max-width: 320px; margin: 2.5rem auto; }
            #detailModal .modal-content { border-radius: 25px; overflow: hidden; border: none; background-color: #8B1A1A; color: white; }
            
            .modal-detail-top { background-color: #B22222; position: relative; height: 180px; display: flex; align-items: center; justify-content: center; overflow: hidden; }
            .modal-detail-top::after { content: ""; position: absolute; bottom: -50px; left: -10%; width: 120%; height: 100px; background: #8B1A1A; border-radius: 50%; z-index: 1; }
            
            #gambarDetail { 
                width: 130px; 
                height: auto; 
                z-index: 2; 
                position: relative; 
                filter: drop-shadow(0 8px 15px rgba(0,0,0,0.3)); 
            }
            
            .modal-detail-body { padding: 12px 20px 20px; }
            .detail-title-row { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 8px; }
            
            .detail-name-label { font-size: 1.25rem; font-weight: 800; color: white; margin: 0; line-height: 1.1; }
            .detail-sub-label { font-size: 0.75rem; color: rgba(255,255,255,0.7); font-weight: 500; margin-top: 2px; }
            .detail-price-label { font-size: 1.1rem; font-weight: 800; color: white; margin: 0; }
            
            .btn-deskripsi-tag { 
                background-color: white; 
                color: #8B1A1A; 
                border-radius: 50px; 
                padding: 3px 15px; 
                font-weight: bold; 
                border: none; 
                font-size: 0.75rem; 
                display: inline-block; 
                margin-bottom: 8px; 
            }
            
            #deskripsiDetail { 
                font-size: 0.75rem; 
                color: rgba(255,255,255,0.9); 
                line-height: 1.4; 
                text-align: left;
                margin-bottom: 15px;
            }
            
            .btn-detail-tutup { 
                background: white; 
                color: #8B1A1A; 
                border-radius: 12px; 
                font-weight: 800; 
                border: none; 
                padding: 10px;
                font-size: 0.85rem;
                margin-top: 10px;
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
                        <div class="slide-content justify-content-center">
                            <img src="{{ asset('/images/icon_cafe.png') }}" class="logo-onboard-small" alt="Logo">
                            <h2 class="title-onboard-new">Selamat Datang</h2>
                            <p class="desc-onboard-new">Real Cafe Jatiroto. Temukan setiap sudut, setiap cita, dan cerita yang menunggu untuk kamu rasakan.</p>
                        </div>
                    </div>
                    <div class="swiper-slide">
                        <div class="slide-content">
                            <div class="grid-container-onboard">
                                <div class="d-flex flex-column gap-2"><img src="{{ asset('/images/onion_rings.jpg') }}"><img src="{{ asset('/images/RBakar.png') }}"><img src="{{ asset('/images/Nasigoreng.png') }}"></div>
                                <div class="d-flex flex-column gap-2"><img src="{{ asset('/images/Geprek.png') }}"><img src="{{ asset('/images/ESteh.png') }}" class="img-tall"></div>
                                <div class="d-flex flex-column gap-2"><img src="{{ asset('/images/Burger_sapi.jpg') }}"><img src="{{ asset('/images/naget_goreng.jpg') }}"><img src="{{ asset('/images/Pisang_Goreng.jpg') }}"></div>
                            </div>
                            <h2 class="title-onboard-new">Pesan menu<br>pilihanmu!</h2>
                            <p class="desc-onboard-new">Temukan menu yang akan kamu pesan sekarang dan jelajahi informasi lainnya melalui Real-Vibe.</p>
                            <button class="btn-get-started-new" onclick="finishOnboarding()">Get Started</button>
                        </div>
                    </div>
                </div>
                <div class="swiper-pagination"></div>
                <div class="onboard-nav-new" id="nav-group-new">
                    <button class="btn btn-light rounded-3 px-4 fw-bold text-muted" onclick="finishOnboarding()">Skip</button>
                    <button class="btn btn-light rounded-3 px-4 fw-bold text-muted" onclick="goNext()">Next</button>
                </div>
            </div>
        </div>

        <!-- <a href="https://wa.me/6282144851960" target="_blank" class="wa-float-btn"><i class="fab fa-whatsapp"></i></a> -->

        <div class="header-custom d-flex justify-content-between align-items-center">
            <div><i class="fas fa-user-circle fa-2x"></i> <span class="ms-2 fw-bold">Welcome, Customer</span></div>
            <div class="position-relative" style="cursor: pointer;" onclick="openCartModal()">
                <i class="fas fa-shopping-cart fa-lg"></i>
                <span id="cart-badge" class="badge rounded-pill bg-warning text-dark position-absolute top-0 start-100 translate-middle">0</span>
            </div>
        </div>

        <div class="container">
            @if($page == 'menu')
                <div class="sticky-search-container">
                    <div class="sticky-search-inner">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-0 ps-3"><i class="fas fa-bars"></i></span>
                            <input type="text" id="searchInput" class="form-control border-0 py-2" placeholder="Cari menu...">
                            <button class="btn bg-white border-0 pe-3"><i class="fas fa-search text-muted"></i></button>
                        </div>
                    </div>
                </div>

                <div id="promoCarouselSection">
                <div id="promoCarousel" class="carousel slide promo-slider" data-bs-ride="carousel" data-bs-interval="3000">
                    <div class="carousel-indicators">
                        <button type="button" data-bs-target="#promoCarousel" data-bs-slide-to="0" class="active"></button>
                        <button type="button" data-bs-target="#promoCarousel" data-bs-slide-to="1"></button>
                        <button type="button" data-bs-target="#promoCarousel" data-bs-slide-to="2"></button>
                    </div>
                    <div class="carousel-inner">
                        <div class="carousel-item active"><img src="{{ asset('/images/banner_realvibe (3).png') }}" alt="Banner 1"></div>
                        <div class="carousel-item"><img src="{{ asset('/images/banner_realvibe (2).png') }}" alt="Banner 2"></div>
                        <div class="carousel-item"><img src="{{ asset('/images/banner_realvibe (1).png') }}" alt="Banner 3"></div>
                    </div>
                </div>
                </div>

                <div class="px-2 mb-4">
                    <h3 class="fw-bold mb-3">Kategori</h3>
                    <div id="kategoriContainer" class="d-flex gap-3 overflow-auto pb-2" style="scrollbar-width: none; -ms-overflow-style: none;"></div>
                </div>

                <div class="px-2">
                    <h6 id="menuTitle" class="fw-bold mb-3"></h6>
                    <div id="menuGrid" class="row g-3"></div>
                </div>

            @elseif($page == 'jadwal')
                <div class="header-curve" style="background-color: #8B1A1A; height: 280px; border-bottom-left-radius: 50px; border-bottom-right-radius: 50px; padding: 40px 25px; color: white; position: relative;">
                    <div class="d-flex align-items-center gap-3 mb-4">
                        <a href="?page=menu" style="background: white; color: #8B1A1A; width: 35px; height: 35px; border-radius: 50%; display: flex; align-items: center; justify-content: center; text-decoration: none;"><i class="fas fa-arrow-left"></i></a>
                        <span style="font-weight: 800; font-size: 1.5rem; font-style: italic;">Real-Vibe</span>
                    </div>
                    <h4 class="fw-bold mt-2">Hai, Customer!</h4>
                    <p class="small opacity-75">Yuk cek jadwal kereta terbaru.</p>
                </div>
                <div style="margin-top: -100px; padding: 0 25px; text-align: center; position: relative; z-index: 5;">
                    <div style="background: white; padding: 10px; border-radius: 15px; box-shadow: 0 10px 30px rgba(0,0,0,0.15); display: inline-block; width: 100%; position: relative;">
                        @if(isset($jadwal_gambar) && $jadwal_gambar)
                            <img src="{{ url('api/image/' . $jadwal_gambar->gambar) }}" style="width: 100%; border-radius: 10px; cursor: pointer;" alt="Jadwal Kereta" onerror="this.src='{{ asset('/images/jadwal_kereta.png') }}'" data-bs-toggle="modal" data-bs-target="#zoomJadwalModal">
                        @else
                            <img src="{{ asset('/images/jadwal_kereta.png') }}" style="width: 100%; border-radius: 10px;" alt="Jadwal Kereta">
                        @endif
                        <div class="maskot-jadwal-wrapper"><img src="{{ asset('/images/maskot_realvibe.png') }}" class="maskot-jadwal-img" alt="Maskot"></div>
                    </div>
                </div>

                <!-- Modal Zoom Jadwal -->
                <div class="modal fade" id="zoomJadwalModal" tabindex="-1" aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered modal-lg">
                        <div class="modal-content bg-transparent border-0">
                            <button type="button" class="btn-close btn-close-white position-absolute top-0 end-0 m-3 z-3" data-bs-dismiss="modal" style="filter: invert(1);"></button>
                            <div class="modal-body text-center p-0">
                                @if(isset($jadwal_gambar) && $jadwal_gambar)
                                    <img src="{{ url('api/image/' . $jadwal_gambar->gambar) }}" style="width: 100%; border-radius: 15px;" alt="Jadwal Zoom">
                                @endif
                            </div>
                        </div>
                    </div>
                </div>

            @elseif($page == 'reservasi')
                <div class="p-3">
                    <h5 class="fw-bold mb-3"><i class="fas fa-calendar-alt text-danger me-2"></i>Manajemen Reservasi</h5>
                    <div class="row g-3">
                        <div class="col-6"><div class="card card-custom p-3 text-center"><i class="fas fa-chair text-danger mb-2"></i><h4 class="fw-bold mb-0">12</h4><small class="text-muted" style="font-size: 0.7rem;">Meja Tersedia</small></div></div>
                        <div class="col-6"><div class="card card-custom p-3 text-center"><i class="fas fa-users text-primary mb-2"></i><h4 class="fw-bold mb-0">5</h4><small class="text-muted" style="font-size: 0.7rem;">Booking Hari Ini</small></div></div>
                    </div>
                    <div class="mt-4"><button class="btn w-100 py-3 fw-bold text-white text-uppercase" style="border-radius: 15px; background: #C42F1A;" data-bs-toggle="modal" data-bs-target="#reservasiModal">BUAT RESERVASI MEJA</button></div>
                </div>
            @endif
        </div>

        <!-- Modal Reservasi -->
        <div class="modal fade" id="reservasiModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0" style="border-radius: 25px; background: #FAFAFA;">
                    <div class="modal-header border-0 pb-0 mt-2 ms-2">
                        <h5 class="fw-bold m-0" style="color: #2D1A1A;">Form Reservasi Meja</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <form action="{{ route('booking.meja') }}" method="POST">
                            @csrf
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Nama Lengkap</label>
                                <input type="text" name="nama" class="form-control" style="border-radius: 12px; padding: 12px;" placeholder="Masukkan nama Anda" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Tanggal Kedatangan</label>
                                <input type="date" name="tanggal" class="form-control" style="border-radius: 12px; padding: 12px;" required min="{{ date('Y-m-d') }}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Waktu Kedatangan</label>
                                <input type="time" name="waktu" class="form-control" style="border-radius: 12px; padding: 12px;" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label small fw-bold text-muted">Jumlah Tamu</label>
                                <input type="number" name="jumlah_orang" class="form-control" style="border-radius: 12px; padding: 12px;" min="1" max="10" placeholder="Contoh: 2" required>
                                <div class="form-text small mt-1">Maksimal 10 orang per reservasi.</div>
                            </div>
                            
                            <button type="submit" class="btn w-100 py-3 fw-bold text-white text-uppercase" style="border-radius: 15px; background: #C42F1A;">
                                <i class="fas fa-check-circle me-2"></i> Konfirmasi & Lanjut WA
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="cartModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-fullscreen-sm-down m-0 h-100">
                <div class="modal-content border-0 d-flex flex-column" style="background-color: #F8F9FA; border-radius: 0; height: 100vh; max-height: 100vh;">
                    <div class="cart-header-curve" style="flex-shrink: 0;">
                        <button type="button" class="btn btn-light rounded-circle" style="width: 45px; height: 45px; display: flex; align-items: center; justify-content: center; z-index: 10;" data-bs-dismiss="modal">
                            <i class="fas fa-arrow-left text-danger"></i>
                        </button>
                        <div class="ms-3 z-3">
                            <div style="font-weight: 800; font-size: 1.2rem; font-style: italic;">Real-Vibe</div>
                            <h4 class="fw-bold m-0">Pesananmu</h4>
                        </div>
                    </div>
                    <div id="cartItemsBody" class="p-3" style="flex: 1; overflow-y: auto; -webkit-overflow-scrolling: touch;"></div>
                    
                    <div id="cartFooter" class="p-4" style="flex-shrink: 0; background: white; border-top-left-radius: 30px; border-top-right-radius: 30px; box-shadow: 0 -10px 20px rgba(0,0,0,0.05);"></div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="checkoutModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content border-0" style="border-radius: 25px;">
                    <div class="modal-body p-4">
                        <div class="d-flex justify-content-between align-items-center mb-4"><h5 class="fw-bold m-0">Ringkasan Pesanan</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                        <label class="form-label-small mb-2">Pesanan Saya</label>
                        <div class="checkout-summary-box summary-card-gray mb-3">
                            <img src="https://cdn-icons-png.flaticon.com/512/2276/2276931.png" style="width: 50px;" class="me-3">
                            <div><h5 class="fw-bold mb-0">Rp <span id="checkoutTotal">0</span>,00</h5><small class="text-muted">Total Bayar</small></div>
                        </div>
                        <div id="checkoutItemsList" class="mb-3" style="font-size: 0.85rem;"></div>
                        <div class="mb-3"><label class="form-label-small">Catatan Pesanan</label><input id="inputCatatan" type="text" class="form-control input-gray-custom" placeholder="Contoh: Pedas ya..."></div>
                        <div class="mb-3"><label class="form-label-small">Nama Pemesan</label><input id="inputNamaPemesan" type="text" class="form-control input-gray-custom" placeholder="Masukkan nama Anda"></div>
                        <label class="form-label-small mb-2">Metode Pembayaran</label>
                        <div class="d-flex gap-3 mb-4">
                            <div class="payment-option active" data-metode="tunai" onclick="selectPayment(this)"><i class="fas fa-money-bill-wave d-block mb-1"></i><small>TUNAI</small></div>
                            <div class="payment-option" data-metode="qris" onclick="selectPayment(this)"><i class="fas fa-qrcode d-block mb-1"></i><small>QRIS</small></div>
                        </div>
                        <button class="btn btn-danger w-100 py-3 fw-bold" style="border-radius: 15px; background-color: var(--brand-orange);" id="btn-submit-order">PESAN SEKARANG</button>
                    </div>
                </div>
            </div>
        </div>

        {{-- LAYAR PESANANMU (full-screen setelah checkout) --}}
        <div id="pesananmuScreen" style="display:none; position:fixed; inset:0; z-index:9999; background:#F8F9FA; overflow-y:auto; -webkit-overflow-scrolling:touch;">
            <div style="background: #8B1A1A; padding: 50px 25px 30px; border-bottom-left-radius: 40px; border-bottom-right-radius: 40px; color: white; text-align: center;">
                <div style="font-weight:800; font-size:1.2rem; font-style:italic;">Real-Vibe</div>
                <h4 class="fw-bold">Pesananmu</h4>
            </div>
            <div style="max-width: 420px; margin: -20px auto 0; padding: 0 20px 100px;">
                <div style="background: white; border-radius: 20px; padding: 25px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); text-align: center;">
                    <div id="pesananQrBox" style="width: 140px; height: 140px; margin: 0 auto 10px; border: 3px solid #333; border-radius: 15px; display: flex; align-items: center; justify-content: center; font-size: 0.7rem; color: #999;">
                        <canvas id="pesananQrCanvas"></canvas>
                    </div>
                    <h5 id="pesananNomorAntrian" class="fw-bold" style="color: #2D1A1A;"></h5>
                    <div class="d-flex justify-content-between align-items-center mt-3 mb-2 px-2">
                        <span id="pesananMetodeLabel" class="fw-bold" style="color: #2D1A1A;"></span>
                        <span id="pesananTotalLabel" class="fw-bold" style="color: #2D1A1A; font-size: 1.2rem;"></span>
                    </div>
                </div>

                <div style="background: white; border-radius: 20px; padding: 20px; margin-top: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08);">
                    <h6 class="fw-bold" style="color: #2D1A1A;">Pesanan</h6>
                    <div id="pesananRincianItems"></div>
                    <hr>
                    <div id="pesananCatatanBox" style="display:none;">
                        <h6 class="fw-bold" style="color: #2D1A1A;">Catatan</h6>
                        <p id="pesananCatatanText" class="text-muted small"></p>
                    </div>
                    <h6 class="fw-bold" style="color: #2D1A1A;">Detail Pembayaran</h6>
                    <div class="d-flex justify-content-between"><span class="text-muted">Subtotal</span><span id="pesananSubtotal"></span></div>
                    <div class="d-flex justify-content-between mb-2"><span class="text-muted">Biaya layanan & lainnya</span><span>-</span></div>
                    <div class="d-flex justify-content-between fw-bold" style="font-size:1.1rem;"><span>Total Pembayaran</span><span id="pesananGrandTotal"></span></div>
                </div>

                <div id="pesananStatusBox" style="background: white; border-radius: 20px; padding: 20px; margin-top: 15px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); text-align: center;">
                    <div class="spinner-border text-danger mb-2" role="status" style="width: 2rem; height: 2rem;"></div>
                    <p class="fw-bold mb-0" style="color: #2D1A1A;">Menunggu konfirmasi kasir...</p>
                    <p class="text-muted small mb-0">Sisa waktu: <span id="pesananCountdown" class="fw-bold text-danger">30:00</span></p>
                </div>
            </div>
        </div>

        {{-- POPUP: Pesanan Diterima --}}
        <div class="modal fade" id="pesananDiterimaModal" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center border-0" style="border-radius: 25px;">
                    <div class="modal-body p-5">
                        <div style="width: 80px; height: 80px; background: #28a745; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px;"><i class="fas fa-check fa-2x text-white"></i></div>
                        <h5 class="fw-bold">Pesanan Diterima!</h5>
                        <p class="text-muted small">Pesananmu sedang dimasak, tunggu beberapa menit kemudian pesananmu akan datang. Terima kasih sudah memesan!</p>
                        <button class="btn px-5 py-2 fw-bold text-white" style="border-radius: 12px; background: #28a745;" onclick="closePesananDiterima()">OK</button>
                    </div>
                </div>
            </div>
        </div>

        {{-- POPUP: Pesanan Ditolak --}}
        <div class="modal fade" id="pesananDitolakModal" tabindex="-1" data-bs-backdrop="static" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content text-center border-0" style="border-radius: 25px;">
                    <div class="modal-body p-5">
                        <div style="width: 80px; height: 80px; background: #dc3545; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px;"><i class="fas fa-times fa-2x text-white"></i></div>
                        <h5 class="fw-bold">Pesanan Dibatalkan</h5>
                        <p class="text-muted small">Mohon maaf pesananmu dibatalkan. Silahkan pilih menu lagi sesuai yang kamu inginkan.</p>
                        <button class="btn px-5 py-2 fw-bold text-white" style="border-radius: 12px; background: #dc3545;" onclick="closePesananDitolak()">OK</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered" style="max-width: 380px;">
                <div class="modal-content border-0" style="border-radius: 30px; overflow: hidden; background: #FAFAFA;">
                    <div style="position: relative; background: #962519; height: 200px; border-bottom-left-radius: 50%; border-bottom-right-radius: 50%; display: flex; align-items: flex-end; justify-content: center; padding-bottom: 20px;">
                        <button type="button" class="btn btn-light rounded-circle position-absolute" style="top: 20px; left: 20px; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;" data-bs-dismiss="modal">
                            <i class="fas fa-arrow-left text-danger"></i>
                        </button>
                        <div class="position-absolute" style="top: 20px; right: 20px; color: white;">
                            <i class="fas fa-shopping-cart fa-lg"></i>
                        </div>
                        <img id="gambarDetail" src="" style="width: 180px; height: 180px; object-fit: contain; position: absolute; bottom: -40px; drop-shadow: 0 10px 15px rgba(0,0,0,0.2);" onerror="this.src='https://via.placeholder.com/150'">
                    </div>
                    
                    <div class="px-4" style="margin-top: 60px;">
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <h4 id="namaDetail" class="fw-bold m-0" style="color: #2D1A1A;"></h4>
                            <h5 class="fw-bold m-0" style="color: #962519;">Rp <span id="hargaDetail"></span></h5>
                        </div>
                        <p id="subDetail" class="text-muted small fw-bold mb-3"></p>
                        
                        <div class="d-inline-block px-3 py-1 mb-3" style="background: #D3432F; color: white; border-radius: 20px; font-size: 0.8rem; font-weight: bold;">
                            Deskripsi
                        </div>
                        
                        <p id="deskripsiDetail" class="text-muted small" style="line-height: 1.6; text-align: justify;">
                            Belum ada deskripsi untuk menu ini.
                        </p>
                        
                        <div class="d-flex justify-content-center align-items-center mt-4 mb-4 gap-4">
                            <button class="btn btn-light rounded-circle fw-bold" style="width: 40px; height: 40px; color: #962519;" onclick="updateDetailQty(-1)">-</button>
                            <span id="detailQty" class="fw-bold fs-5">1</span>
                            <button class="btn btn-light rounded-circle fw-bold" style="width: 40px; height: 40px; color: #962519;" onclick="updateDetailQty(1)">+</button>
                        </div>
                        
                        <button class="btn w-100 py-3 mb-4 fw-bold text-white" style="border-radius: 15px; background: #C42F1A;" onclick="addDetailToCart()">
                            Masukkan keranjang
                        </button>
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
        // ========== DATA ==========
        const ALL_MENUS = @json($menus ?? []);
        const ALL_KATEGORIS = @json($kategori_list ?? []);
        const ICON_MAP = {
            'snack':   '{{ asset('images/icons/nachos-color.svg') }}',
            'makanan': '{{ asset('images/icons/rice-bowl-color.svg') }}',
            'minuman': '{{ asset('images/icons/boba-drink-color.svg') }}',
            'camilan': '{{ asset('images/icons/cake-slice-color.svg') }}',
            'dessert': '{{ asset('images/icons/cake-slice-color.svg') }}',
        };
        const API_IMAGE_BASE = '{{ url('api/image') }}';
        let activeKategori = '';
        let searchQuery = '';

        // ========== CART (sessionStorage) ==========
        function getCart() {
            try { return JSON.parse(sessionStorage.getItem('rv_cart') || '[]'); } catch(e) { return []; }
        }
        function saveCart(cart) {
            sessionStorage.setItem('rv_cart', JSON.stringify(cart));
            updateCartBadge();
        }
        function updateCartBadge() {
            const cart = getCart();
            const total = cart.reduce((s, i) => s + i.qty, 0);
            document.getElementById('cart-badge').innerText = total;
        }
        function addToCart(nama, harga, img, qty = 1) {
            let cart = getCart();
            const idx = cart.findIndex(i => i.nama === nama);
            if (idx >= 0) { cart[idx].qty += qty; } else { cart.push({ nama, harga: parseFloat(harga), img, qty }); }
            saveCart(cart);
        }
        function updateCartItemQty(index, delta) {
            let cart = getCart();
            if (!cart[index]) return;
            cart[index].qty += delta;
            if (cart[index].qty < 1) cart.splice(index, 1);
            saveCart(cart);
            renderCartModal();
        }

        // ========== FORMAT ==========
        function formatRp(val) { return new Intl.NumberFormat('id-ID').format(Math.round(val)); }

        // ========== KATEGORI & MENU RENDER ==========
        function setKategori(cat) {
            activeKategori = cat;
            searchQuery = '';
            const searchInput = document.getElementById('searchInput');
            if (searchInput) searchInput.value = '';
            renderKategoriButtons();
            renderMenuGrid();
            const promoSection = document.getElementById('promoCarouselSection');
            if (promoSection) promoSection.style.display = '';
        }

        function renderKategoriButtons() {
            const container = document.getElementById('kategoriContainer');
            if (!container) return;
            container.innerHTML = ALL_KATEGORIS.map(k => {
                const cat = k.nama_kategori.trim().toLowerCase();
                const isActive = activeKategori === cat;
                const icon = ICON_MAP[cat] || ICON_MAP['makanan'];
                return `<div onclick="setKategori('${cat}')" style="cursor:pointer" class="text-decoration-none">
                    <div class="category-card d-flex flex-column align-items-center ${isActive ? 'active' : ''}">
                        <div class="category-icon-wrapper mb-2"><img src="${icon}" alt="${cat}" class="waaaw-icon"></div>
                        <span class="category-name">${cat.charAt(0).toUpperCase() + cat.slice(1)}</span>
                    </div>
                </div>`;
            }).join('');
        }

        function renderMenuGrid() {
            const grid = document.getElementById('menuGrid');
            const title = document.getElementById('menuTitle');
            if (!grid) return;

            let filtered;
            if (searchQuery) {
                filtered = ALL_MENUS.filter(m => m.nama_menu.toLowerCase().includes(searchQuery));
                if (title) title.textContent = `Hasil pencarian: '${searchQuery}'`;
                const promoSection = document.getElementById('promoCarouselSection');
                if (promoSection) promoSection.style.display = 'none';
            } else {
                filtered = ALL_MENUS.filter(m => (m.kategori || '').trim().toLowerCase() === activeKategori);
                if (title) title.textContent = `Menu ${activeKategori.charAt(0).toUpperCase() + activeKategori.slice(1)}`;
            }

            if (filtered.length === 0) {
                grid.innerHTML = '<div class="col-12 text-center text-muted py-5">Menu tidak ditemukan :(</div>';
                return;
            }

            grid.innerHTML = filtered.map(m => {
                const imgUrl = API_IMAGE_BASE + '/' + m.gambar;
                const hargaFormatted = formatRp(m.harga);
                return `<div class="col-6">
                    <div class="card menu-card" onclick="openDetail('${m.nama_menu.replace(/'/g, "\\'")  }', ${m.harga}, '${imgUrl}', 'Stok: ${m.stok}', '${m.stok}')">
                        <img src="${imgUrl}" class="mx-auto mt-2" onerror="this.src='https://via.placeholder.com/150'">
                        <div class="card-body p-2 mt-2">
                            <div class="fw-bold small">${m.nama_menu}</div>
                            <div class="text-muted mb-2" style="font-size: 0.6rem;">Stok: ${m.stok}</div>
                            <div class="text-danger fw-bold mb-2">Rp ${hargaFormatted}</div>
                            <button class="btn btn-tambah py-1" onclick="event.stopPropagation(); quickAdd(this, '${m.nama_menu.replace(/'/g, "\\'") }', ${m.harga}, '${imgUrl}')">+ Tambah</button>
                        </div>
                    </div>
                </div>`;
            }).join('');
        }

        function quickAdd(btn, nama, harga, img) {
            addToCart(nama, harga, img, 1);
            btn.innerHTML = '✓ Berhasil';
            btn.classList.replace('btn-tambah', 'btn-success');
            setTimeout(() => { btn.innerHTML = '+ Tambah'; btn.classList.replace('btn-success', 'btn-tambah'); }, 800);
        }

        // ========== CART MODAL ==========
        function openCartModal() {
            renderCartModal();
            var modal = new bootstrap.Modal(document.getElementById('cartModal'));
            modal.show();
        }

        function renderCartModal() {
            const cart = getCart();
            const body = document.getElementById('cartItemsBody');
            const footer = document.getElementById('cartFooter');
            
            if (cart.length === 0) {
                body.innerHTML = `<div class="text-center d-flex flex-column align-items-center justify-content-center" style="height: 100%;">
                    <div style="width: 120px; height: 120px; background-color: #D3D3D3; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin-bottom: 20px;">
                        <i class="fas fa-cart-arrow-down fa-4x text-white"></i>
                    </div>
                    <h4 class="fw-bold" style="color: #A9A9A9;">Keranjang Kosong</h4>
                    <p class="small" style="color: #A9A9A9;">Silakan pilih menu untuk mulai memesan!</p>
                </div>`;
            } else {
                body.innerHTML = '<div style="padding: 0 10px;">' + cart.map((item, idx) => {
                    const harga = Math.round(item.harga);
                    return `<div class="card cart-item-card">
                        <div class="d-flex align-items-center">
                            <img src="${item.img}" onerror="this.src='https://via.placeholder.com/60'">
                            <div class="ms-3 flex-grow-1">
                                <div class="fw-bold" style="color: #4A2511;">${item.nama}</div>
                                <div class="small text-muted mb-1">Pilihan Menu</div>
                                <div class="fw-bold" style="color: #D3432F; font-size: 0.85rem;">Rp ${formatRp(harga)},00</div>
                            </div>
                            <div class="qty-control">
                                <button class="btn-qty" onclick="updateCartItemQty(${idx}, -1)">-</button>
                                <span class="fw-bold" style="font-size: 1.1rem; color: #2D1A1A;">${item.qty}</span>
                                <button class="btn-qty" onclick="updateCartItemQty(${idx}, 1)">+</button>
                            </div>
                        </div>
                    </div>`;
                }).join('') + '</div>';
            }

            const total = cart.reduce((s, i) => s + Math.round(i.harga) * i.qty, 0);
            footer.innerHTML = `
                <div class="d-flex justify-content-between mb-2 px-2 text-muted" style="font-size: 1.1rem;">
                    <span>Total Item</span>
                    <span style="color: #2D1A1A;">Rp.${formatRp(total)},00</span>
                </div>
                <div class="d-flex justify-content-between mb-4 px-2 text-muted" style="font-size: 1.1rem;">
                    <span>Biaya Admin</span>
                    <span style="color: #4A4A4A;">Free</span>
                </div>
                <div class="d-flex justify-content-between align-items-center mb-4 px-2">
                    <h5 class="fw-bold m-0" style="color: #4A4A4A;">Total Biaya</h5>
                    <h5 class="fw-bold m-0" style="color: #4A4A4A;">Rp.${formatRp(total)},00</h5>
                </div>
                <button class="btn w-100 py-3 fw-bold text-white text-uppercase" style="border-radius: 20px; background: #C42F1A; font-size: 1.1rem;" onclick="konfirmasiPesanan()" ${cart.length === 0 ? 'disabled' : ''}>
                    KONFIRMASI PESANAN
                </button>`;
        }

        function konfirmasiPesanan() {
            const cartModal = bootstrap.Modal.getInstance(document.getElementById('cartModal'));
            if (cartModal) cartModal.hide();
            
            const cart = getCart();
            const total = cart.reduce((s, i) => s + Math.round(i.harga) * i.qty, 0);
            document.getElementById('checkoutTotal').innerText = formatRp(total);

            // Populate item list in checkout modal
            const listEl = document.getElementById('checkoutItemsList');
            listEl.innerHTML = cart.map(i => `<div class="d-flex justify-content-between"><span>${i.qty}x ${i.nama}</span><span>Rp ${formatRp(Math.round(i.harga) * i.qty)}</span></div>`).join('');

            // Reset inputs
            document.getElementById('inputCatatan').value = '';
            document.getElementById('inputNamaPemesan').value = '';

            setTimeout(() => {
                var checkoutModal = new bootstrap.Modal(document.getElementById('checkoutModal'));
                checkoutModal.show();
            }, 300);
        }

        // ========== DETAIL MODAL ==========
        let currentDetailMenu = {};
        function openDetail(nama, harga, img, deskripsi, sub) {
            document.getElementById('namaDetail').innerText = nama;
            document.getElementById('subDetail').innerText = sub;
            document.getElementById('hargaDetail').innerText = formatRp(harga);
            document.getElementById('gambarDetail').src = img;
            document.getElementById('deskripsiDetail').innerText = deskripsi && deskripsi.trim() !== '' ? deskripsi : 'Belum ada deskripsi untuk menu ini.';
            document.getElementById('detailQty').innerText = '1';
            currentDetailMenu = { nama, harga, img };
            var myModal = new bootstrap.Modal(document.getElementById('detailModal'));
            myModal.show();
        }

        function updateDetailQty(change) {
            let qty = parseInt(document.getElementById('detailQty').innerText);
            qty += change;
            if (qty < 1) qty = 1;
            document.getElementById('detailQty').innerText = qty;
        }

        function addDetailToCart() {
            let qty = parseInt(document.getElementById('detailQty').innerText);
            if (!currentDetailMenu.nama) return;
            const btn = document.querySelector('#detailModal .btn.w-100');
            const originalText = btn.innerText;
            btn.innerText = 'Memproses...';
            btn.disabled = true;

            addToCart(currentDetailMenu.nama, currentDetailMenu.harga, currentDetailMenu.img, qty);

            btn.innerText = '✓ Berhasil Ditambahkan';
            btn.style.background = '#28a745';
            setTimeout(() => {
                btn.innerText = originalText;
                btn.style.background = '#C42F1A';
                btn.disabled = false;
                bootstrap.Modal.getInstance(document.getElementById('detailModal')).hide();
            }, 800);
        }

        // ========== ONBOARDING & INIT ==========
        document.addEventListener('DOMContentLoaded', function() {
            const screen = document.getElementById('onboarding-screen');
            const isAppOpen = sessionStorage.getItem('app_session_active');
            if (!isAppOpen) { screen.style.display = 'block'; } else { screen.style.display = 'none'; }

            var promoCarousel = document.getElementById('promoCarousel');
            if (promoCarousel) {
                var carousel = new bootstrap.Carousel(promoCarousel, { interval: 3000, ride: 'carousel' });
                carousel.cycle();
            }

            // Init kategori
            if (ALL_KATEGORIS.length > 0) {
                activeKategori = ALL_KATEGORIS[0].nama_kategori.trim().toLowerCase();
            }
            renderKategoriButtons();
            renderMenuGrid();
            updateCartBadge();

            // Live search
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                let debounce;
                searchInput.addEventListener('input', function() {
                    clearTimeout(debounce);
                    debounce = setTimeout(() => {
                        searchQuery = this.value.trim().toLowerCase();
                        if (searchQuery === '') {
                            renderMenuGrid();
                            const promoSection = document.getElementById('promoCarouselSection');
                            if (promoSection) promoSection.style.display = '';
                        } else {
                            renderMenuGrid();
                        }
                    }, 300);
                });
            }
        });

        const swiper = new Swiper('.mySwiper', {
            pagination: { el: '.swiper-pagination', clickable: true },
            speed: 800, autoplay: { delay: 3000, disableOnInteraction: false },
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

        // ========== CHECKOUT & PESANANMU ==========
        let activePesananId = null;
        let pollingInterval = null;
        let countdownInterval = null;
        let pesananDeadline = null;

        const btnSubmitOrder = document.getElementById('btn-submit-order');
        if (btnSubmitOrder) {
            btnSubmitOrder.addEventListener('click', function() {
                const nama = document.getElementById('inputNamaPemesan').value.trim();
                if (!nama) { alert('Nama pemesan wajib diisi!'); return; }

                const cart = getCart();
                if (cart.length === 0) return;

                const metode = document.querySelector('.payment-option.active')?.getAttribute('data-metode') || 'tunai';
                const catatan = document.getElementById('inputCatatan').value.trim();
                const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

                this.disabled = true;
                this.innerText = 'Memproses...';

                fetch('/api/checkout', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json', 'X-CSRF-TOKEN': token, 'Accept': 'application/json' },
                    body: JSON.stringify({
                        nama_pemesan: nama,
                        metode_pembayaran: metode,
                        catatan: catatan || null,
                        items: cart.map(i => ({ nama: i.nama, harga: i.harga, qty: i.qty }))
                    })
                })
                .then(res => res.json())
                .then(data => {
                    this.disabled = false;
                    this.innerText = 'PESAN SEKARANG';

                    if (!data.success) {
                        alert(data.message || 'Gagal membuat pesanan.');
                        return;
                    }

                    // Close checkout modal
                    const checkoutModal = bootstrap.Modal.getInstance(document.getElementById('checkoutModal'));
                    if (checkoutModal) checkoutModal.hide();

                    // Clear cart
                    sessionStorage.removeItem('rv_cart');
                    updateCartBadge();

                    // Show Pesananmu screen
                    showPesananmuScreen(data, cart, nama, metode, catatan);
                })
                .catch(err => {
                    console.error(err);
                    this.disabled = false;
                    this.innerText = 'PESAN SEKARANG';
                    alert('Terjadi kesalahan jaringan.');
                });
            });
        }

        function showPesananmuScreen(data, cart, nama, metode, catatan) {
            activePesananId = data.pesanan_id;
            pesananDeadline = new Date(data.waktu_batas);

            document.getElementById('pesananNomorAntrian').innerText = data.nomor_antrian;
            document.getElementById('pesananMetodeLabel').innerText = metode === 'qris' ? 'QRIS' : 'Tunai';
            document.getElementById('pesananTotalLabel').innerText = 'Rp ' + formatRp(data.total_bayar) + ',00';
            document.getElementById('pesananSubtotal').innerText = 'Rp ' + formatRp(data.total_bayar) + ',00';
            document.getElementById('pesananGrandTotal').innerText = 'Rp ' + formatRp(data.total_bayar) + ',00';

            // QR code - simple text-based QR placeholder
            const qrCanvas = document.getElementById('pesananQrCanvas');
            const qrBox = document.getElementById('pesananQrBox');
            qrBox.innerHTML = '<div style="font-size:2.5rem; font-weight:900; color:#2D1A1A;">' + data.nomor_antrian + '</div><div style="font-size:0.7rem; color:#999;">Tunjukkan ke kasir</div>';

            // Items list
            document.getElementById('pesananRincianItems').innerHTML = cart.map(i => 
                `<div class="d-flex justify-content-between mb-1"><span>${i.nama}</span><span class="text-muted">${i.qty}</span></div>`
            ).join('');

            // Catatan
            if (catatan) {
                document.getElementById('pesananCatatanBox').style.display = 'block';
                document.getElementById('pesananCatatanText').innerText = catatan;
            } else {
                document.getElementById('pesananCatatanBox').style.display = 'none';
            }

            // Show screen
            document.getElementById('pesananmuScreen').style.display = 'block';

            // Start countdown
            startCountdown();

            // Start polling
            startPolling();
        }

        function startCountdown() {
            if (countdownInterval) clearInterval(countdownInterval);
            countdownInterval = setInterval(() => {
                const now = new Date();
                const diff = Math.max(0, Math.floor((pesananDeadline - now) / 1000));
                const mins = Math.floor(diff / 60).toString().padStart(2, '0');
                const secs = (diff % 60).toString().padStart(2, '0');
                document.getElementById('pesananCountdown').innerText = mins + ':' + secs;

                if (diff <= 0) {
                    clearInterval(countdownInterval);
                    stopPolling();
                    closePesananmuScreen();
                }
            }, 1000);
        }

        function startPolling() {
            if (pollingInterval) clearInterval(pollingInterval);
            pollingInterval = setInterval(() => {
                if (!activePesananId) return;
                fetch('/api/checkout/status/' + activePesananId)
                    .then(r => r.json())
                    .then(d => {
                        if (d.status === 'diproses') {
                            stopPolling();
                            clearInterval(countdownInterval);
                            // Show diterima popup
                            var m = new bootstrap.Modal(document.getElementById('pesananDiterimaModal'));
                            m.show();
                        } else if (d.status === 'batal') {
                            stopPolling();
                            clearInterval(countdownInterval);
                            // Show ditolak popup
                            var m = new bootstrap.Modal(document.getElementById('pesananDitolakModal'));
                            m.show();
                        }
                    }).catch(() => {});
            }, 3000);
        }

        function stopPolling() {
            if (pollingInterval) { clearInterval(pollingInterval); pollingInterval = null; }
        }

        function closePesananmuScreen() {
            document.getElementById('pesananmuScreen').style.display = 'none';
            activePesananId = null;
        }

        function closePesananDiterima() {
            bootstrap.Modal.getInstance(document.getElementById('pesananDiterimaModal'))?.hide();
            // Stay on pesananmu screen - do nothing extra
            document.getElementById('pesananStatusBox').innerHTML = '<div style="color: #28a745;"><i class="fas fa-check-circle fa-2x mb-2"></i><p class="fw-bold mb-0">Pesanan sedang dimasak!</p><p class="text-muted small">Silakan tunggu dan lakukan pembayaran di kasir.</p></div>';
        }

        function closePesananDitolak() {
            bootstrap.Modal.getInstance(document.getElementById('pesananDitolakModal'))?.hide();
            closePesananmuScreen();
            // Redirect ke menu
            window.location.href = '/?page=menu';
        }

        function selectPayment(el) {
            document.querySelectorAll('.payment-option').forEach(opt => opt.classList.remove('active'));
            el.classList.add('active');
        }
        </script>
    </body>
    </html>