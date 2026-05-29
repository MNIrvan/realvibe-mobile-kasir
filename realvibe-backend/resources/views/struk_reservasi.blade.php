<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Struk Reservasi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- html2canvas -->
    <script src="https://cdn.jsdelivr.net/npm/html2canvas@1.4.1/dist/html2canvas.min.js"></script>

    <style>
        body {
            background-color: #f0f2f5;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            padding: 20px;
            font-family: 'Courier New', Courier, monospace;
        }

        .receipt-container {
            width: 100%;
            max-width: 380px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .receipt-paper {
            background-color: #fffaf0; /* Cream color */
            width: 100%;
            padding: 30px 25px;
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
            position: relative;
            color: #3B1F1B;
        }

        /* Jagged edges for receipt effect */
        .receipt-paper::before,
        .receipt-paper::after {
            content: "";
            position: absolute;
            left: 0;
            right: 0;
            height: 10px;
            background-size: 20px 20px;
        }

        .receipt-paper::before {
            top: -10px;
            background-image: radial-gradient(circle at 10px 0, transparent 10px, #fffaf0 11px);
        }

        .receipt-paper::after {
            bottom: -10px;
            background-image: radial-gradient(circle at 10px 20px, transparent 10px, #fffaf0 11px);
        }

        .cafe-name {
            font-size: 24px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .cafe-subtitle {
            font-size: 12px;
            text-align: center;
            margin-bottom: 20px;
            color: #7A6E6A;
        }

        .divider {
            border-top: 2px dashed #B88478;
            margin: 15px 0;
        }

        .receipt-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: bold;
        }

        .receipt-label {
            color: #7A6E6A;
            font-weight: normal;
        }

        .barcode-container {
            text-align: center;
            margin-top: 25px;
        }

        .barcode {
            font-family: 'Libre Barcode 39', cursive;
            font-size: 40px;
            letter-spacing: 2px;
        }

        .btn-action {
            background-color: #8B1A1A;
            color: white;
            border: none;
            border-radius: 12px;
            padding: 15px;
            width: 100%;
            font-weight: bold;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin-top: 30px;
            box-shadow: 0 4px 10px rgba(139, 26, 26, 0.3);
            transition: 0.3s;
        }

        .btn-action:hover {
            background-color: #a32222;
            color: white;
        }
    </style>
</head>
<body>

    <div class="receipt-container">
        <!-- Elemen struk yang akan di-screenshot -->
        <div class="receipt-paper" id="struk">
            <div class="cafe-name">REAL VIBE CAFE</div>
            <div class="cafe-subtitle">Jatiroto, Jawa Timur<br>Telp: 0821-4485-1960</div>

            <div class="divider"></div>
            
            <div style="text-align: center; margin-bottom: 15px; font-weight: bold; font-size: 18px;">
                STRUK RESERVASI
            </div>

            <div class="receipt-row">
                <span class="receipt-label">Booking ID:</span>
                <span>{{ $reservasi->booking_id }}</span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Tgl Cetak:</span>
                <span>{{ date('d/m/Y H:i') }}</span>
            </div>

            <div class="divider"></div>

            <div class="receipt-row">
                <span class="receipt-label">Nama:</span>
                <span style="text-align: right;">{{ $reservasi->nama }}</span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Tgl Kedatangan:</span>
                <span>{{ date('d M Y', strtotime($reservasi->tanggal)) }}</span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Jam:</span>
                <span>{{ $reservasi->waktu }} WIB</span>
            </div>
            <div class="receipt-row">
                <span class="receipt-label">Jumlah Tamu:</span>
                <span>{{ $reservasi->jumlah_orang }} Orang</span>
            </div>

            <div class="divider"></div>
            
            <div class="receipt-row" style="font-size: 16px;">
                <span>STATUS:</span>
                <span style="color: #8B1A1A;">MENUNGGU KONFIRMASI</span>
            </div>

            <div class="barcode-container">
                <div style="font-size: 10px; color: #7A6E6A; margin-bottom: 5px;">Tunjukkan struk ini kepada staf kami</div>
                <!-- Simulasi Barcode text -->
                <div style="font-family: monospace; font-size: 18px; letter-spacing: 3px;">|||| ||| ||||| |||</div>
                <div style="font-size: 10px; margin-top: 3px;">{{ $reservasi->booking_id }}</div>
            </div>
        </div>

        <!-- Tombol Aksi -->
        <button class="btn-action" id="btnDownload" onclick="downloadStruk()">
            <i class="fas fa-download me-2"></i> Simpan Struk & Hubungi WA
        </button>
        <button class="btn btn-light mt-3 w-100" style="border-radius: 12px; font-family: 'Segoe UI', Tahoma;" onclick="window.location.href='/'">
            Kembali ke Beranda
        </button>
    </div>

    <script>
        function downloadStruk() {
            const btn = document.getElementById('btnDownload');
            btn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i> Memproses...';
            btn.disabled = true;

            const strukElement = document.getElementById('struk');

            html2canvas(strukElement, {
                scale: 2, // Kualitas HD
                backgroundColor: "#fffaf0"
            }).then(canvas => {
                // 1. Download Gambar
                const link = document.createElement('a');
                link.download = 'Struk_{{ $reservasi->booking_id }}.png';
                link.href = canvas.toDataURL("image/png");
                link.click();

                // 2. Redirect ke WhatsApp
                const textWa = "Halo Admin, saya ingin mengkonfirmasi reservasi meja saya. Terlampir struk reservasinya ya!";
                const waUrl = "https://wa.me/6282144851960?text=" + encodeURIComponent(textWa);
                
                setTimeout(() => {
                    btn.innerHTML = '<i class="fas fa-check me-2"></i> Selesai';
                    window.location.href = waUrl;
                }, 1500);
            }).catch(err => {
                alert("Terjadi kesalahan saat memproses gambar.");
                btn.disabled = false;
                btn.innerHTML = '<i class="fas fa-download me-2"></i> Simpan Struk & Hubungi WA';
            });
        }
    </script>
</body>
</html>
