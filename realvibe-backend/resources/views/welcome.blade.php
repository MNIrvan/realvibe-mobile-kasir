@php
    // HAPUS session_start() karena Laravel mengelolanya secara otomatis
    // Logika PHP dipindahkan ke sintaks Blade agar lebih bersih

    $page = request('page', 'menu');
    $kategori_aktif = request('kategori', 'snack');
    $search_query = strtolower(request('search', ''));

    $semua_menu = [
        "snack" => [
            ["nama" => "Burger ayam", "sub" => "FriedOnions ", "harga" => "12.000", "img" => "/images/Burger_ayam .jpg", "desc" => "Burger ayam krispi dengan topping bawang bombay goreng renyah dan saus spesial."],
            ["nama" => "Burger sapi", "sub" => "Crispy Tofu", "harga" => "15.000", "img" => "/images/Burger_sapi.jpg", "desc" => "Daging sapi juicy dengan keju lumer dan roti lembut yang dipanggang sempurna."],
            ["nama" => "Brokoli crispy", "sub" => "French Fries", "harga" => "10.000", "img" => "/images/Brokoli_crispy.png", "desc" => "Brokoli segar yang dibalut tepung bumbu premium dan digoreng hingga sangat renyah."],
            ["nama" => "Cilok", "sub" => "Fried Tapioca", "harga" => "10.000", "img" => "/images/Cilok.jpg", "desc" => "Bola tapioka kenyal dengan bumbu kacang gurih khas resep tradisional."],
            ["nama" => "Cireng", "sub" => "Sweet Banana Roll", "harga" => "10.000", "img" => "/images/cireng.jpg", "desc" => "Aci digoreng garing di luar dan kenyal di dalam, disajikan hangat."],
            ["nama" => "Jamur krispy", "sub" => "Chicken Dimsum", "harga" => "10.000", "img" => "/images/jamur_krispy .jpg", "desc" => "Jamur tiram pilihan yang digoreng dengan tepung bumbu rahasia."],
            ["nama" => "Kentang goreng", "sub" => "Chicken Dimsum", "harga" => "12.000", "img" => "/images/Kentang_Goreng.jpg", "desc" => "Kentang pilihan yang dipotong dan digoreng hingga keemasan, menghasilkan tekstur renyah."],
            ["nama" => "Naget goreng", "sub" => "Chicken Dimsum", "harga" => "15.000", "img" => "/images/naget_goreng.jpg", "desc" => "Nugget ayam goreng hangat yang krispi dan gurih."],
            ["nama" => "Onion Rings", "sub" => "Sweet Banana Roll", "harga" => "10.000", "img" => "/images/onion_rings.jpg", "desc" => "Bawang bombay potong cincin yang dibalut tepung roti renyah."],
            ["nama" => "Pisang Goreng", "sub" => "Sweet Banana Roll", "harga" => "10.000", "img" => "/images/Pisang_Goreng.jpg", "desc" => "Pisang manis goreng hangat, teman santai yang paling pas."],
            ["nama" => "Roti Maryam", "sub" => "Sweet Banana Roll", "harga" => "10.000", "img" => "/images/roti_canai.jpg", "desc" => "Roti pipih gurih yang nikmat disantap dengan berbagai topping."],
            ["nama" => "Roti Bakar", "sub" => "Roti Bakar", "harga" => "10.000", "img" => "/images/RotiBakar.png", "desc" => "Roti pipih gurih yang nikmat disantap dengan berbagai topping."],
            ["nama" => "Tahu Cryspy", "sub" => "Sweet Banana Roll", "harga" => "10.000", "img" => "/images/Tahu_Cryspy.jpg", "desc" => "Tahu goreng dengan kremesan tepung yang sangat krispi."],
            ["nama" => "Sosil Bakar", "sub" => "Sosil Bakaar", "harga" => "13.000", "img" => "/images/SosisBakar.png", "desc" => "Tahu goreng dengan kremesan tepung yang sangat krispi."],
            ["nama" => "Tempe mendoan", "sub" => "Sweet Banana Roll", "harga" => "10.000", "img" => "/images/TEMPE_MENDOAN.jpg", "desc" => "Tempe goreng tepung setengah matang yang lembut dan kaya rasa."],
            ["nama" => "Nugget", "sub" => "Nugget", "harga" => "12.000", "img" => "/images/Nugget.png", "desc" => "Tempe goreng tepung setengah matang yang lembut dan kaya rasa."],
        ],
        "makanan" => [
            ["nama" => "Nasi Goreng Reguler", "sub" => "Fried Noodles", "harga" => "13.000", "img" => "resources/image/mie.jpg", "desc" => "Mie goreng spesial dengan bumbu rempah autentik."],
            ["nama" => "Nasi Goreng Spesial", "sub" => "Special Fried Rice", "harga" => "18.000", "img" => "/images/Nasigoreng.png", "desc" => "Nasi goreng spesial dengan telur dan racikan bumbu khas cafe."],
            ["nama" => "Nasi Goreng Ikan Asin", "sub" => "Grilled Chicken", "harga" => "19.000", "img" => "resources/image/ayambakar.jpg", "desc" => "Ayam bakar bumbu kecap meresap yang dibakar sempurna."],
            ["nama" => "Nasi Goreng Seafood", "sub" => "Chicken Soup", "harga" => "20.000", "img" => "resources/image/soto.jpg", "desc" => "Kuah soto kuning yang segar dengan suwiran ayam melimpah."],
            ["nama" => "Lalapan Ayam Laos", "sub" => "Meatball Soup", "harga" => "19.000", "img" => "resources/image/bakso.jpg", "desc" => "Bakso urat sapi asli dengan kuah kaldu yang gurih dan hangat."],
            ["nama" => "Lalapan Ayam Kampung", "sub" => "Chicken Noodle", "harga" => "35.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Lalapan Bebek Sinjay", "sub" => "Chicken Noodle", "harga" => "35.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Lalapan Ayam Kremes", "sub" => "Chicken Noodle", "harga" => "19.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Lalapan T3", "sub" => "Chicken Noodle", "harga" => "15.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Ayam Geprek", "sub" => "Chicken Noodle", "harga" => "15.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Chicken Mozarella", "sub" => "Chicken Noodle", "harga" => "25.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Telur Geprek", "sub" => "Chicken Noodle", "harga" => "15.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Fuyunghai", "sub" => "Chicken Noodle", "harga" => "20.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Capcay", "sub" => "Chicken Noodle", "harga" => "22.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Mie Goreng", "sub" => "Chicken Noodle", "harga" => "15.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Mie Kuah", "sub" => "Chicken Noodle", "harga" => "15.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Cah Kangkung", "sub" => "Chicken Noodle", "harga" => "15.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Cah Tauge", "sub" => "Chicken Noodle", "harga" => "15.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Sup Iga", "sub" => "Chicken Noodle", "harga" => "40.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Sup Buntut", "sub" => "Chicken Noodle", "harga" => "40.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Bistik Ayam", "sub" => "Chicken Noodle", "harga" => "25.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Rawon", "sub" => "Chicken Noodle", "harga" => "25.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
            ["nama" => "Pecel   ", "sub" => "Chicken Noodle", "harga" => "15.000", "img" => "resources/image/mieayam.jpg", "desc" => "Mie kenyal dengan topping ayam bumbu kecap yang manis gurih."],
        ],
        "minuman" => [
            ["nama" => "Lemon Tea (Panas/Dingin)", "sub" => "Lemon Tea", "harga" => "8.000", "img" => "/images/ESteh.png", "desc" => "Teh seduh segar yang disajikan dingin dengan es batu."],
            ["nama" => "Jeruk Manis (Panas/Dingin)", "sub" => "Milk Coffee", "harga" => "10.000", "img" => "/images/Kopisusu.png", "desc" => "Perpaduan kopi robusta dan susu kental manis yang mantap."],
            ["nama" => "Jeruk Nipis (Panas/Dingin)", "sub" => "Avocado Juice", "harga" => "12.000", "img" => "/images/alpukat.jpg", "desc" => "Jus alpukat kental dengan siraman cokelat yang nikmat."],
            ["nama" => "Cappucino (Panas/Dingin)", "sub" => "Chocolate Milkshake", "harga" => "15.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Milo (Panas/Dingin)", "sub" => "Chocolate Milkshake", "harga" => "15.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Susu Uht (Panas/Dingin)", "sub" => "Chocolate Milkshake", "harga" => "15.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Lemon Jahe", "sub" => "Orange Juice", "harga" => "7.000", "img" => "/images/ESjeruk.png", "desc" => "Perasan jeruk asli yang menyegarkan dahaga."],
            ["nama" => "Jahe", "sub" => "Coconut Ice", "harga" => "10.000", "img" => "/images/kelapa.jpg", "desc" => "Air kelapa muda murni untuk kesegaran maksimal."],
            ["nama" => "Teh Manis ", "sub" => "Chocolate Milkshake", "harga" => "5.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Teh Susu ", "sub" => "Chocolate Milkshake", "harga" => "15.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Susu Jahe ", "sub" => "Chocolate Milkshake", "harga" => "15.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Coklat ", "sub" => "Chocolate Milkshake", "harga" => "15.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Susu Coklat Panas  ", "sub" => "Chocolate Milkshake", "harga" => "15.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Es Susu Coklat", "sub" => "Chocolate Milkshake", "harga" => "15.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Es Joshua ", "sub" => "Chocolate Milkshake", "harga" => "8.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Es Susu Soda", "sub" => "Chocolate Milkshake", "harga" => "15.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Es Teh Susu", "sub" => "Chocolate Milkshake", "harga" => "10.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Es Teh Manis/Tawar", "sub" => "Chocolate Milkshake", "harga" => "6.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Es Dalgona", "sub" => "Chocolate Milkshake", "harga" => "12.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Es Matcha", "sub" => "Chocolate Milkshake", "harga" => "10.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Air Mineral", "sub" => "Chocolate Milkshake", "harga" => "5.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
            ["nama" => "Es Batu", "sub" => "Chocolate Milkshake", "harga" => "2.000", "img" => "/images/milkshake.jpg", "desc" => "Susu kocok cokelat dengan tekstur yang creamy dan manis."],
        ],
        "dessert" => [
            ["nama" => "Roti Bakar", "sub" => "Toast", "harga" => "8.000", "img" => "/images/RBakar.png", "desc" => "Roti panggang hangat dengan berbagai pilihan selai manis."],
            ["nama" => "Salad Buah", "sub" => "Fruit Salad", "harga" => "15.000", "img" => "/images/salad.jpg", "desc" => "Buah segar dengan saus mayo manis dan keju melimpah."],
            ["nama" => "Ice Cream Scoop", "sub" => "Vanilla / Choco", "harga" => "10.000", "img" => "/images/icecream.jpg", "desc" => "Es krim lembut dengan pilihan rasa cokelat atau vanilla."],
            ["nama" => "Roti Bakar Keju", "sub" => "Cheese Toast", "harga" => "12.000", "img" => "/images/rotibakar.jpg", "desc" => "Roti bakar spesial dengan taburan keju parut melimpah."],
            ["nama" => "Mochi Es Krim", "sub" => "Ice Cream Mochi", "harga" => "12.000", "img" => "/images/mochi.jpg", "desc" => "Mochi kenyal isi es krim dingin berbagai rasa."],
            ["nama" => "Waffle Honey", "sub" => "Sweet Waffle", "harga" => "18.000", "img" => "/images/waffle.jpg", "desc" => "Waffle renyah yang disajikan dengan madu murni."],
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
            .cart-item-card { border-radius: 20px; border: none; box-shadow: 0 2px 10px rgba(0,0,0,0.05); margin-bottom: 12px; padding: 10px; background: white; }
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

        <a href="https://wa.me/6282144851960" target="_blank" class="wa-float-btn"><i class="fab fa-whatsapp"></i></a>

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
                        <div class="carousel-item active"><img src="{{ asset('/images/banner_realvibe (3).png') }}" alt="Banner 1"></div>
                        <div class="carousel-item"><img src="{{ asset('/images/banner_realvibe (2).png') }}" alt="Banner 2"></div>
                        <div class="carousel-item"><img src="{{ asset('/images/banner_realvibe (1).png') }}" alt="Banner 3"></div>
                    </div>
                </div>
                @endif

                <div class="px-2 mb-4">
                    <h3 class="fw-bold mb-3">Kategori</h3>
                    <div class="d-flex gap-3 overflow-auto pb-2" style="scrollbar-width: none; -ms-overflow-style: none;">
                        @php
                        $icon_kategori = [
                            'snack'   => asset('images/icons/nachos-color.svg'),
                            'makanan' => asset('images/icons/rice-bowl-color.svg'),
                            'minuman' => asset('images/icons/boba-drink-color.svg'),
                            'dessert' => asset('images/icons/cake-slice-color.svg'),
                        ];
                        @endphp
                        @foreach(['snack', 'makanan', 'minuman', 'dessert'] as $cat)
                        <a href="?page=menu&kategori={{ $cat }}" class="text-decoration-none">
                            <div class="category-card d-flex flex-column align-items-center {{ ($kategori_aktif == $cat && empty($search_query)) ? 'active' : '' }}">
                                <div class="category-icon-wrapper mb-2"><img src="{{ $icon_kategori[$cat] }}" alt="{{ $cat }}" class="waaaw-icon"></div>
                                <span class="category-name">{{ ucfirst($cat) }}</span>
                            </div>
                        </a>
                        @endforeach
                    </div>
                </div>

                <div class="px-2">
                    <h6 class="fw-bold mb-3">{{ !empty($search_query) ? "Hasil pencarian: '$search_query'" : "Menu ".ucfirst($kategori_aktif) }}</h6>
                    <div class="row g-3">
                        @forelse($menu_tampil as $m)
                        <div class="col-6">
                            <div class="card menu-card" onclick="openDetail('{{ $m['nama'] }}', '{{ $m['harga'] }}', '{{ asset($m['img']) }}', '{{ $m['desc'] }}', '{{ $m['sub'] }}')">
                                <img src="{{ asset($m['img']) }}" class="mx-auto mt-2" onerror="this.src='https://via.placeholder.com/150'">
                                <div class="card-body p-2 mt-2">
                                    <div class="fw-bold small">{{ $m['nama'] }}</div>
                                    <div class="text-muted mb-2" style="font-size: 0.6rem;">{{ $m['sub'] }}</div>
                                    <div class="text-danger fw-bold mb-2">Rp {{ $m['harga'] }}</div>
                                    <button class="btn btn-tambah py-1 btn-beli" onclick="event.stopPropagation();" data-nama="{{ $m['nama'] }}" data-harga="{{ $m['harga'] }}">+ Tambah</button>
                                </div>
                            </div>
                        </div>
                        @empty
                        <div class="col-12 text-center text-muted py-5">Menu tidak ditemukan :(</div>
                        @endforelse
                    </div>
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
                        <img src="{{ asset('/images/jadwal_kereta.png') }}" style="width: 100%; border-radius: 10px;" alt="Jadwal Kereta" onerror="this.src='https://via.placeholder.com/600x800?text=Gambar+Jadwal+Kereta'">
                        <div class="maskot-jadwal-wrapper"><img src="{{ asset('/images/maskot_realvibe.png') }}" class="maskot-jadwal-img" alt="Maskot"></div>
                    </div>
                </div>

            @elseif($page == 'reservasi')
                <div class="p-3">
                    <h5 class="fw-bold mb-3"><i class="fas fa-calendar-alt text-danger me-2"></i>Manajemen Reservasi</h5>
                    <div class="row g-3">
                        <div class="col-6"><div class="card card-custom p-3 text-center"><i class="fas fa-chair text-danger mb-2"></i><h4 class="fw-bold mb-0">12</h4><small class="text-muted" style="font-size: 0.7rem;">Meja Tersedia</small></div></div>
                        <div class="col-6"><div class="card card-custom p-3 text-center"><i class="fas fa-users text-primary mb-2"></i><h4 class="fw-bold mb-0">5</h4><small class="text-muted" style="font-size: 0.7rem;">Booking Hari Ini</small></div></div>
                    </div>
                    <div class="mt-4"><button class="btn btn-danger w-100 py-3 fw-bold shadow-sm" style="border-radius: 15px;">BUAT RESERVASI MEJA</button></div>
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
                                        <form action="{{ route('update.cart') }}" method="POST" class="m-0">@csrf<input type="hidden" name="index" value="{{ $index }}"><button name="operasi" value="kurang" class="btn-qty">-</button></form>
                                        <span class="small fw-bold mx-2">{{ $item['qty'] }}</span>
                                        <form action="{{ route('update.cart') }}" method="POST" class="m-0">@csrf<input type="hidden" name="index" value="{{ $index }}"><button name="operasi" value="tambah" class="btn-qty">+</button></form>
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
                        <div class="d-flex justify-content-between align-items-center mb-4"><h5 class="fw-bold m-0">Ringkasan Pesanan</h5><button type="button" class="btn-close" data-bs-dismiss="modal"></button></div>
                        <label class="form-label-small mb-2">Pesanan Saya</label>
                        <div class="checkout-summary-box summary-card-gray mb-3">
                            <img src="https://cdn-icons-png.flaticon.com/512/2276/2276931.png" style="width: 50px;" class="me-3">
                            <div><h5 class="fw-bold mb-0">Rp {{ number_format($total_bayar, 0, ',', '.') }},00</h5><small class="text-muted">Total Bayar</small></div>
                        </div>
                        <div class="mb-3"><label class="form-label-small">Catatan Pesanan</label><input type="text" class="form-control input-gray-custom" placeholder="Contoh: Pedas ya..."></div>
                        <div class="mb-3"><label class="form-label-small">Nama Pemesan</label><input type="text" class="form-control input-gray-custom" placeholder="Masukkan nama Anda"></div>
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
                <div class="modal-content text-center modal-success-content">
                    <div class="modal-body p-5">
                        <div class="success-maskot-container">
                            <img src="{{ asset('/images/maskot_realvibe.png') }}" style="width: 150px;" onerror="this.src='https://via.placeholder.com/150?text=Maskot'">
                        </div>
                        <h4 class="fw-bold mt-3">Terimakasih !</h4>
                        <p class="text-muted small">Pesanan Anda berhasil dibuat. Silakan lakukan pembayaran di kasir dan berikan penilaian Anda.</p>
                        <button class="btn btn-danger px-5 py-2 mt-3 fw-bold" style="border-radius: 10px; background-color: #801a1a;" onclick="location.reload()">Oke</button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="detailModal" tabindex="-1" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <button type="button" class="btn-close z-3 position-absolute top-0 end-0 m-3 btn-close-white" data-bs-dismiss="modal"></button>
                    <div class="modal-detail-top">
                        <img id="gambarDetail" src="" alt="Food">
                    </div>
                    <div class="modal-detail-body">
                        <div class="detail-title-row text-start">
                            <div>
                                <h2 id="namaDetail" class="detail-name-label"></h2>
                                <p id="subDetail" class="detail-sub-label"></p>
                            </div>
                            <div class="text-end">
                                <p class="detail-price-label">Rp <span id="hargaDetail"></span>,00</p>
                            </div>
                        </div>
                        <div class="text-start">
                            <div class="btn-deskripsi-tag">Deskripsi</div>
                            <p id="deskripsiDetail"></p>
                        </div>
                        <button class="btn btn-detail-tutup w-100" data-bs-dismiss="modal">Tutup</button>
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
        document.addEventListener("DOMContentLoaded", function() {
            const screen = document.getElementById('onboarding-screen');
            const isAppOpen = sessionStorage.getItem('app_session_active');
            if (!isAppOpen) { screen.style.display = 'block'; } else { screen.style.display = 'none'; }

            var promoCarousel = document.getElementById('promoCarousel');
            if (promoCarousel) {
                var carousel = new bootstrap.Carousel(promoCarousel, { interval: 3000, ride: 'carousel' });
                carousel.cycle(); 
            }

            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('search')) {
                const input = document.getElementsByName('search')[0];
                if(input) { input.focus(); input.setSelectionRange(input.value.length, input.value.length); }
            }
        });

        const swiper = new Swiper(".mySwiper", {
            pagination: { el: ".swiper-pagination", clickable: true },
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

        function openDetail(nama, harga, img, deskripsi, sub) {
            document.getElementById('namaDetail').innerText = nama;
            document.getElementById('subDetail').innerText = sub;
            document.getElementById('hargaDetail').innerText = harga;
            document.getElementById('gambarDetail').src = img;
            document.getElementById('deskripsiDetail').innerText = deskripsi;
            var myModal = new bootstrap.Modal(document.getElementById('detailModal'));
            myModal.show();
        }

        document.querySelectorAll('.btn-beli').forEach(button => {
            button.addEventListener('click', function() {
                const nama = this.getAttribute('data-nama');
                const harga = this.getAttribute('data-harga');
                const img = this.closest('.menu-card').querySelector('img').getAttribute('src'); 
                const formData = new FormData();
                formData.append('nama', nama); formData.append('harga', harga); formData.append('img', img);
                const token = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

                fetch('/add-to-cart', { method: 'POST', body: formData, headers: { 'X-CSRF-TOKEN': token } })
                .then(res => res.json())
                .then(data => {
                    document.getElementById('cart-badge').innerText = data.total_item;
                    this.innerHTML = "✓ Berhasil";
                    this.classList.replace('btn-tambah', 'btn-success');
                    setTimeout(() => { this.innerHTML = "+ Tambah"; this.classList.replace('btn-success', 'btn-tambah'); }, 800);
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