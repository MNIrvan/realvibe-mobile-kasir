<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Feedback;
use Illuminate\Http\Request;

class FeedbackController extends Controller
{
    public function index()
    {
        return response()->json(Feedback::latest()->get());
    }

    public function markAsRead($id)
    {
        $feedback = Feedback::findOrFail($id);
        $feedback->is_read = true;
        $feedback->save();

        return response()->json(['message' => 'Feedback marked as read.']);
    }
}
