import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RevenueChart extends StatefulWidget {
  const RevenueChart({super.key, this.filter = 'hari'});
  final String filter;

  @override
  State<RevenueChart> createState() => _RevenueChartState();
}

class _RevenueChartState extends State<RevenueChart> {
  List<double> _data = [];
  List<String> _labels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  @override
  void didUpdateWidget(RevenueChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filter != widget.filter) {
      _fetchChartData();
    }
  }

  Future<void> _fetchChartData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final host = kIsWeb
          ? '127.0.0.1'
          : defaultTargetPlatform == TargetPlatform.android
              ? '10.0.2.2'
              : '127.0.0.1';
      final url = Uri.parse('http://$host:8000/api/admin/dashboard/chart?filter=${widget.filter}');
      final response = await http.get(url, headers: {
        'Accept': 'application/json',
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        List<double> parsedData = [];
        List<String> parsedLabels = [];

        for (var item in jsonList) {
          final total = double.tryParse(item['total'].toString()) ?? 0.0;
          parsedData.add(total);
          
          final dateStr = item['date'].toString();
          if (widget.filter == 'bulan' && dateStr.length >= 7) {
            // "2026-05" -> "05-26" or "May"
            parsedLabels.add(dateStr.substring(5, 7)); // Just month number for simplicity
          } else if (widget.filter == 'tahun') {
            parsedLabels.add(dateStr);
          } else if (dateStr.length >= 10) {
            parsedLabels.add(dateStr.substring(5, 10)); // e.g. "05-23"
          } else {
            parsedLabels.add(dateStr);
          }
        }

        if (mounted) {
          setState(() {
            _data = parsedData.isNotEmpty ? parsedData : [0.0];
            _labels = parsedLabels.isNotEmpty ? parsedLabels : ['-'];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.only(left: 28, right: 12, bottom: 22, top: 10),
      child: CustomPaint(
        painter: _RevenueChartPainter(data: _data, labels: _labels), 
        child: Container(),
      ),
    );
  }
}

class _RevenueChartPainter extends CustomPainter {
  _RevenueChartPainter({required this.data, required this.labels});
  final List<double> data;
  final List<String> labels;
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width;
    final chartHeight = size.height;
    final background = Paint()
      ..color = const Color(0xFFF8F2EE)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = const Color(0xFFDCD3CE)
      ..strokeWidth = 1;

    canvas.drawRect(Offset.zero & size, background);

    const leftPadding = 24.0;
    const bottomPadding = 24.0;
    final contentWidth = chartWidth - leftPadding - 12;
    final contentHeight = chartHeight - bottomPadding - 8;

    final steps = 5;
    final stepY = contentHeight / steps;
    for (int i = 0; i <= steps; i++) {
      final y = stepY * i;
      canvas.drawLine(
        Offset(leftPadding, y),
        Offset(leftPadding + contentWidth, y),
        gridPaint,
      );
    }

    double maxValue = 0;
    for (var d in data) {
      if (d > maxValue) maxValue = d;
    }
    if (maxValue == 0) maxValue = 100000; // avoid div by 0

    // Adjust maxValue to a nice round number if necessary, but keep it simple
    maxValue = (maxValue * 1.2); 

    final spacing = data.length > 1 ? contentWidth / (data.length - 1) : contentWidth;

    final linePaint = Paint()
      ..color = const Color(0xFFB11D1D)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()..color = const Color(0xFFB11D1D);

    final path = Path();
    for (var i = 0; i < data.length; i++) {
      final x = leftPadding + spacing * i;
      final y = contentHeight - (data[i] / maxValue) * contentHeight;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      canvas.drawCircle(Offset(x, y), 6, dotPaint);
    }
    canvas.drawPath(path, linePaint);

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    for (var i = 0; i < labels.length; i++) {
      final x = data.length > 1 ? leftPadding + spacing * i : leftPadding + contentWidth / 2;
      textPainter.text = TextSpan(
        text: labels[i],
        style: const TextStyle(color: Color(0xFF8A7F7A), fontSize: 12),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, contentHeight + 8),
      );
    }

    final labelPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );
    const labelStyle = TextStyle(color: Color(0xFF8A7F7A), fontSize: 12);
    for (var i = 0; i <= 4; i++) {
      final val = (maxValue / 4 * i);
      String valueText = '';
      if (val >= 1000000) {
        valueText = '${(val / 1000000).toStringAsFixed(1)}M';
      } else if (val >= 1000) {
        valueText = '${(val / 1000).toStringAsFixed(0)}K';
      } else {
        valueText = val.toStringAsFixed(0);
      }
      
      labelPainter.text = TextSpan(text: valueText, style: labelStyle);
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(
          leftPadding - labelPainter.width - 8,
          contentHeight - stepY * i - 6,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _RevenueChartPainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.labels != labels;
  }
}
