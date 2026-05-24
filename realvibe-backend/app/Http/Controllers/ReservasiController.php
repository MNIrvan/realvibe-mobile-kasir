<?php

namespace App\Http\Controllers;

use App\Models\Reservasi;
use Illuminate\Http\Request;
use Illuminate\Support\Str;

class ReservasiController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'nama' => 'required|string|max:255',
            'tanggal' => 'required|date',
            'waktu' => 'required',
            'jumlah_orang' => 'required|integer|min:1|max:10',
        ]);

        $bookingId = 'RES-' . date('Ymd') . '-' . strtoupper(Str::random(4));

        Reservasi::create([
            'booking_id' => $bookingId,
            'nama' => $request->nama,
            'tanggal' => $request->tanggal,
            'waktu' => $request->waktu,
            'jumlah_orang' => $request->jumlah_orang,
            'status' => 'Menunggu Konfirmasi',
        ]);

        // Redirect ke halaman struk
        return redirect()->route('booking.struk', ['id' => $bookingId]);
    }

    public function struk($id)
    {
        $reservasi = Reservasi::where('booking_id', $id)->firstOrFail();
        return view('struk_reservasi', compact('reservasi'));
    }
}
