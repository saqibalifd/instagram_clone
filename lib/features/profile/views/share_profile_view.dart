import 'dart:math';
import 'package:flutter/material.dart';

class ShareProfileView extends StatelessWidget {
  const ShareProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Emoji background
          const EmojiBackground(),
          // Centered QR card
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 32,
                      spreadRadius: 4,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 36,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // QR Code
                    CustomPaint(
                      size: const Size(240, 240),
                      painter: InstagramQRPainter(),
                    ),
                    const SizedBox(height: 20),
                    // Username
                    Text(
                      '@SAQIBALI.FD',
                      style: TextStyle(
                        color: const Color(0xFFC07A1A),
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Emoji Background ───────────────────────────────────────────────────────

class EmojiBackground extends StatelessWidget {
  const EmojiBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final positions = _generatePositions(size);

    return SizedBox.expand(
      child: Stack(
        children: positions
            .map(
              (pos) => Positioned(
                left: pos.dx,
                top: pos.dy,
                child: Transform.rotate(
                  angle: pos.angle,
                  child: Text('😄', style: TextStyle(fontSize: pos.size)),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<_EmojiPos> _generatePositions(Size size) {
    final random = Random(42); // fixed seed for consistent layout
    final List<_EmojiPos> positions = [];

    // Grid-based placement with jitter (mimics Instagram's layout)
    const cols = 3;
    const rows = 8;
    final cellW = size.width / cols;
    final cellH = size.height / rows;

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        final cx = c * cellW + cellW / 2;
        final cy = r * cellH + cellH / 2;

        // Skip center area (where the card will be)
        final cardLeft = size.width * 0.12;
        final cardRight = size.width * 0.88;
        final cardTop = size.height * 0.25;
        final cardBottom = size.height * 0.75;

        if (cx > cardLeft &&
            cx < cardRight &&
            cy > cardTop &&
            cy < cardBottom) {
          continue;
        }

        final jitterX = (random.nextDouble() - 0.5) * cellW * 0.5;
        final jitterY = (random.nextDouble() - 0.5) * cellH * 0.5;
        final emojiSize = 48.0 + random.nextDouble() * 20;
        final angle = (random.nextDouble() - 0.5) * 0.4;

        positions.add(
          _EmojiPos(
            dx: cx + jitterX - emojiSize / 2,
            dy: cy + jitterY - emojiSize / 2,
            size: emojiSize,
            angle: angle,
          ),
        );
      }
    }

    return positions;
  }
}

class _EmojiPos {
  final double dx, dy, size, angle;
  const _EmojiPos({
    required this.dx,
    required this.dy,
    required this.size,
    required this.angle,
  });
}

// ─── QR Code Painter ────────────────────────────────────────────────────────

class InstagramQRPainter extends CustomPainter {
  static const Color _qrColor = Color(0xFFC07A1A);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _qrColor
      ..style = PaintingStyle.fill;

    final double cellSize = size.width / 33;
    final Random rng = Random(1337);

    // Draw random QR-like dots in the data area (excluding finder patterns)
    for (int row = 0; row < 33; row++) {
      for (int col = 0; col < 33; col++) {
        if (_isFinderArea(row, col)) continue;
        if (_isInstagramLogoArea(row, col, size)) continue;

        if (rng.nextDouble() > 0.48) {
          final rect = RRect.fromRectAndRadius(
            Rect.fromLTWH(
              col * cellSize + cellSize * 0.1,
              row * cellSize + cellSize * 0.1,
              cellSize * 0.8,
              cellSize * 0.8,
            ),
            Radius.circular(cellSize * 0.3),
          );
          canvas.drawRRect(rect, paint);
        }
      }
    }

    // Draw 3 finder pattern squares
    _drawFinderPattern(canvas, paint, cellSize, 0, 0); // top-left
    _drawFinderPattern(canvas, paint, cellSize, 26, 0); // top-right
    _drawFinderPattern(canvas, paint, cellSize, 0, 26); // bottom-left

    // Draw Instagram logo in center
    _drawInstagramLogo(canvas, size);
  }

  bool _isFinderArea(int row, int col) {
    // Top-left 7x7
    if (row < 8 && col < 8) return true;
    // Top-right 7x7
    if (row < 8 && col >= 26) return true;
    // Bottom-left 7x7
    if (row >= 26 && col < 8) return true;
    return false;
  }

  bool _isInstagramLogoArea(int row, int col, Size size) {
    // Center 7x7 cells
    return row >= 13 && row < 20 && col >= 13 && col < 20;
  }

  void _drawFinderPattern(
    Canvas canvas,
    Paint paint,
    double cs,
    int startCol,
    int startRow,
  ) {
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(startCol * cs, startRow * cs, cs * 7, cs * 7),
      Radius.circular(cs * 1.2),
    );

    // Outer ring
    final borderPaint = Paint()
      ..color = _qrColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = cs;
    canvas.drawRRect(outerRect, borderPaint);

    // Inner dot
    final innerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        startCol * cs + cs * 2,
        startRow * cs + cs * 2,
        cs * 3,
        cs * 3,
      ),
      Radius.circular(cs * 0.6),
    );
    canvas.drawRRect(innerRect, paint);
  }

  void _drawInstagramLogo(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const double logoSize = 52.0;

    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // White background circle
    canvas.drawCircle(center, logoSize * 0.72, bgPaint);

    final logoPaint = Paint()
      ..color = _qrColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    // Outer rounded square
    final outerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: center, width: logoSize, height: logoSize),
      Radius.circular(logoSize * 0.28),
    );
    canvas.drawRRect(outerRect, logoPaint);

    // Center circle
    canvas.drawCircle(center, logoSize * 0.22, logoPaint);

    // Top-right dot
    final dotPaint = Paint()
      ..color = _qrColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(center.dx + logoSize * 0.28, center.dy - logoSize * 0.28),
      3.5,
      dotPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
