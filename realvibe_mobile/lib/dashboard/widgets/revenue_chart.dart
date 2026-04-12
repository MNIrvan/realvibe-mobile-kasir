import 'package:flutter/material.dart';

class RevenueChart extends StatelessWidget {
  const RevenueChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28, right: 12, bottom: 22, top: 10),
      child: CustomPaint(painter: _RevenueChartPainter(), child: Container()),
    );
  }
}

class _RevenueChartPainter extends CustomPainter {
  @override
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

    final data = [8.0, 18.0, 20.0, 32.0, 36.0];
    final maxValue = 42.0;
    final spacing = contentWidth / (data.length - 1);

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

    final years = ['2021', '2022', '2023', '2024', '2025'];
    for (var i = 0; i < years.length; i++) {
      final x = leftPadding + spacing * i;
      textPainter.text = TextSpan(
        text: years[i],
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
      final value = (i * 10).toString();
      labelPainter.text = TextSpan(text: value, style: labelStyle);
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
