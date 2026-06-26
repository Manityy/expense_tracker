import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

enum TunisianMotifIntensity { subtle, medium }

/// Shared decorative layers — palm shadow, painted Tunisia stickers, zellige, door.
class _TunisiaBackdropLayers extends StatelessWidget {
  final double scale;
  final bool showStickers;
  final bool showPalmShadow;
  final bool showZellige;
  final bool showPottery;
  final bool showMinaret;
  final bool showDoor;
  final bool showGuilloche;

  const _TunisiaBackdropLayers({
    required this.scale,
    this.showStickers = true,
    this.showPalmShadow = true,
    this.showZellige = true,
    this.showPottery = true,
    this.showMinaret = true,
    this.showDoor = true,
    this.showGuilloche = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (showGuilloche)
          CustomPaint(
            painter: _GuillochePainter(
              color: AppColors.sidiBlue,
              opacity: 0.035 * scale,
            ),
          ),
        if (showZellige)
          CustomPaint(
            painter: _ZelligeTilePainter(
              color: AppColors.motifInk,
              opacity: 0.04 * scale,
            ),
          ),
        if (showPalmShadow)
          CustomPaint(
            painter: _LargePalmShadowPainter(opacity: 0.11 * scale),
          ),
        if (showPottery)
          CustomPaint(
            painter: _SejnanPotteryPainter(
              color: AppColors.terracottaDeep,
              opacity: 0.045 * scale,
            ),
          ),
        if (showMinaret)
          Positioned(
            top: 0,
            left: 0,
            width: 100,
            height: 150,
            child: CustomPaint(
              painter: _MinaretOutlinePainter(
                color: AppColors.sidiBlue,
                opacity: 0.07 * scale,
              ),
            ),
          ),
        if (showDoor)
          Positioned(
            left: -6,
            top: MediaQuery.sizeOf(context).height * 0.22,
            width: 88,
            height: 130,
            child: CustomPaint(
              painter: _BlueDoorSilhouettePainter(opacity: 0.09 * scale),
            ),
          ),
        Positioned(
          top: 40,
          right: 8,
          width: 76,
          height: 112,
          child: CustomPaint(
            painter: _DoorStudsPainter(
              color: AppColors.sidiBlue,
              opacity: 0.06 * scale,
            ),
          ),
        ),
        if (showStickers) ...[
          _TunisiaSticker(
            painter: _BrassCoinStickerPainter(opacity: 0.22 * scale),
            alignment: const Alignment(-0.92, 0.68),
            size: 74,
            rotation: -0.28,
          ),
          _TunisiaSticker(
            painter: _SilverCoinStickerPainter(opacity: 0.2 * scale),
            alignment: const Alignment(0.94, -0.58),
            size: 70,
            rotation: 0.2,
          ),
          _TunisiaSticker(
            painter: _HarissaChiliPainter(opacity: 0.2 * scale),
            alignment: const Alignment(0.88, 0.38),
            size: 54,
            rotation: 0.45,
          ),
          _TunisiaSticker(
            painter: _OliveBranchStickerPainter(opacity: 0.18 * scale),
            alignment: const Alignment(-0.86, -0.38),
            size: 66,
            rotation: -0.15,
          ),
          _TunisiaSticker(
            painter: _HamsaStickerPainter(opacity: 0.17 * scale),
            alignment: const Alignment(0.72, -0.78),
            size: 58,
            rotation: 0.08,
          ),
          _TunisiaSticker(
            painter: _FlagBadgePainter(opacity: 0.19 * scale),
            alignment: const Alignment(-0.68, 0.12),
            size: 50,
            rotation: -0.1,
          ),
          _TunisiaSticker(
            painter: _TunisiaMapStickerPainter(opacity: 0.15 * scale),
            alignment: const Alignment(0.58, 0.82),
            size: 58,
            rotation: 0.06,
          ),
          _TunisiaSticker(
            painter: _BrikPastryPainter(opacity: 0.18 * scale),
            alignment: const Alignment(-0.52, -0.74),
            size: 52,
            rotation: -0.32,
          ),
          _TunisiaSticker(
            painter: _ChechiaHatPainter(opacity: 0.17 * scale),
            alignment: const Alignment(0.38, -0.9),
            size: 48,
            rotation: 0.12,
          ),
          _TunisiaSticker(
            painter: _WheatStalksPainter(opacity: 0.16 * scale),
            alignment: const Alignment(-0.38, 0.9),
            size: 56,
            rotation: 0.18,
          ),
          _TunisiaSticker(
            painter: _MintTeaGlassPainter(opacity: 0.16 * scale),
            alignment: const Alignment(0.15, 0.55),
            size: 44,
            rotation: -0.08,
          ),
          _TunisiaSticker(
            painter: _JasmineClusterPainter(opacity: 0.14 * scale),
            alignment: const Alignment(0.92, 0.88),
            size: 48,
            rotation: 0.25,
          ),
        ],
      ],
    );
  }
}

/// Painted sticker — no image assets, transparent background.
class _TunisiaSticker extends StatelessWidget {
  final CustomPainter painter;
  final Alignment alignment;
  final double size;
  final double rotation;

  const _TunisiaSticker({
    required this.painter,
    required this.alignment,
    required this.size,
    required this.rotation,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: IgnorePointer(
        child: Transform.rotate(
          angle: rotation,
          child: CustomPaint(
            size: Size(size, size),
            painter: painter,
          ),
        ),
      ),
    );
  }
}

/// App-wide warm gradient + layered Tunisia motifs.
class FlousiBackground extends StatelessWidget {
  final Widget child;
  final TunisianMotifIntensity intensity;

  const FlousiBackground({
    super.key,
    required this.child,
    this.intensity = TunisianMotifIntensity.subtle,
  });

  @override
  Widget build(BuildContext context) {
    final scale = intensity == TunisianMotifIntensity.subtle ? 1.0 : 1.35;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkSurfaceGradient : AppColors.surfaceGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _TunisiaBackdropLayers(scale: scale),
          child,
        ],
      ),
    );
  }
}

class TunisianMotifBackground extends StatelessWidget {
  final Widget child;
  final bool showZellige;
  final bool showPottery;
  final bool showPalm;
  final bool showMinaret;
  final bool showGuilloche;

  const TunisianMotifBackground({
    super.key,
    required this.child,
    this.showZellige = true,
    this.showPottery = true,
    this.showPalm = true,
    this.showMinaret = true,
    this.showGuilloche = true,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkSurfaceGradient
            : AppColors.surfaceGradient,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _TunisiaBackdropLayers(
            scale: 1.15,
            showPalmShadow: showPalm,
            showMinaret: showMinaret,
            showZellige: showZellige,
            showPottery: showPottery,
            showGuilloche: showGuilloche,
            showDoor: showMinaret,
          ),
          child,
        ],
      ),
    );
  }
}

/// Sidi Bou Said–inspired welcome header with arched blue frame.
class TunisianWelcomeHeader extends StatelessWidget {
  final String greeting;
  final String subtitle;

  const TunisianWelcomeHeader({
    super.key,
    required this.greeting,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.sidiBlue.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            Container(
              height: 148,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.sidiBlue,
                    Color(0xFF4A9FD4),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: CustomPaint(
                painter: _DoorStudsPainter(
                  color: Colors.white,
                  opacity: 0.08,
                  dense: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'فلوسي',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '🇹🇳 DT',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withValues(alpha: 0.95),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    greeting,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.88),
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TunisianEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? action;
  final bool showMinaret;
  final bool showPalm;
  final bool embedded;

  const TunisianEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.showMinaret = false,
    this.showPalm = true,
    this.embedded = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: AppColors.saffron.withValues(alpha: 0.5),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.sidiBlue.withValues(alpha: 0.15),
                  width: 2,
                ),
              ),
              child: Icon(icon, size: 44, color: AppColors.sidiBlue),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
                height: 1.4,
              ),
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );

    if (embedded) return content;

    return TunisianMotifBackground(
      showMinaret: showMinaret,
      showPalm: showPalm,
      child: content,
    );
  }
}

/// White card with optional zellige corner accent.
BoxDecoration tunisianCardDecoration({Color? tint}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(24),
    border: Border.all(
      color: (tint ?? AppColors.sidiBlue).withValues(alpha: 0.08),
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.terracottaDeep.withValues(alpha: 0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

class _GuillochePainter extends CustomPainter {
  final Color color;
  final double opacity;

  _GuillochePainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.6;

    for (var y = 0.0; y < size.height; y += 28) {
      final path = Path();
      for (var x = 0.0; x <= size.width; x += 4) {
        final wave = math.sin((x + y) * 0.04) * 6;
        if (x == 0) {
          path.moveTo(x, y + wave);
        } else {
          path.lineTo(x, y + wave);
        }
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GuillochePainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _ZelligeTilePainter extends CustomPainter {
  final Color color;
  final double opacity;

  _ZelligeTilePainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.75;

    const tile = 44.0;
    for (var y = -tile; y < size.height + tile; y += tile * 0.85) {
      final row = (y / (tile * 0.85)).round();
      final shift = row.isOdd ? tile / 2 : 0.0;
      for (var x = -tile; x < size.width + tile; x += tile) {
        _drawStar(canvas, Offset(x + shift, y), tile * 0.38, paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset c, double r, Paint paint) {
    final diamond = Path()
      ..moveTo(c.dx, c.dy - r)
      ..lineTo(c.dx + r, c.dy)
      ..lineTo(c.dx, c.dy + r)
      ..lineTo(c.dx - r, c.dy)
      ..close();
    canvas.drawPath(diamond, paint);

    final s = r * 0.55;
    final square = Path()
      ..moveTo(c.dx - s, c.dy - s)
      ..lineTo(c.dx + s, c.dy - s)
      ..lineTo(c.dx + s, c.dy + s)
      ..lineTo(c.dx - s, c.dy + s)
      ..close();
    canvas.drawPath(square, paint);
  }

  @override
  bool shouldRepaint(covariant _ZelligeTilePainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _SejnanPotteryPainter extends CustomPainter {
  final Color color;
  final double opacity;

  _SejnanPotteryPainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()..style = PaintingStyle.fill;
    const clusters = [
      (0.18, 0.22, 1.0),
      (0.72, 0.15, 0.85),
      (0.55, 0.62, 1.1),
      (0.25, 0.78, 0.9),
      (0.85, 0.72, 0.75),
    ];

    for (final (fx, fy, scale) in clusters) {
      final cx = size.width * fx;
      final cy = size.height * fy;
      for (var i = 0; i < 14; i++) {
        final angle = i * 0.9 + fx * 6;
        final dist = (8 + (i % 4) * 5) * scale;
        fill.color = color.withValues(alpha: opacity * (0.6 + (i % 3) * 0.15));
        canvas.drawCircle(
          Offset(cx + math.cos(angle) * dist, cy + math.sin(angle) * dist),
          (1.8 + (i % 3)) * scale,
          fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SejnanPotteryPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _MinaretOutlinePainter extends CustomPainter {
  final Color color;
  final double opacity;

  _MinaretOutlinePainter({required this.color, required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    final w = size.width;
    final h = size.height;

    final tower = Path()
      ..moveTo(w * 0.35, h * 0.95)
      ..lineTo(w * 0.38, h * 0.42)
      ..lineTo(w * 0.62, h * 0.42)
      ..lineTo(w * 0.65, h * 0.95)
      ..close();
    canvas.drawPath(tower, stroke);

    canvas.drawLine(
      Offset(w * 0.34, h * 0.48),
      Offset(w * 0.66, h * 0.48),
      stroke,
    );

    final dome = Path()
      ..moveTo(w * 0.36, h * 0.42)
      ..quadraticBezierTo(w * 0.5, h * 0.22, w * 0.64, h * 0.42);
    canvas.drawPath(dome, stroke);
  }

  @override
  bool shouldRepaint(covariant _MinaretOutlinePainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

/// Sidi Bou Said door nail stud pattern.
class _DoorStudsPainter extends CustomPainter {
  final Color color;
  final double opacity;
  final bool dense;

  _DoorStudsPainter({
    required this.color,
    required this.opacity,
    this.dense = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final fill = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final cols = dense ? 5 : 3;
    final rows = dense ? 8 : 5;
    final padX = size.width * 0.15;
    final padY = size.height * 0.12;
    final stepX = (size.width - padX * 2) / (cols - 1);
    final stepY = (size.height - padY * 2) / (rows - 1);

    for (var r = 0; r < rows; r++) {
      for (var c = 0; c < cols; c++) {
        canvas.drawCircle(
          Offset(padX + c * stepX, padY + r * stepY),
          dense ? 3.5 : 4.5,
          fill,
        );
      }
    }

    if (!dense) {
      final arch = Paint()
        ..color = color.withValues(alpha: opacity * 1.2)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2;
      canvas.drawArc(
        Rect.fromLTWH(
          size.width * 0.08,
          size.height * 0.02,
          size.width * 0.84,
          size.height * 0.55,
        ),
        math.pi,
        math.pi,
        false,
        arch,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DoorStudsPainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.dense != dense;
}

/// Large palm tree + ground shadow spanning the screen (like sun through a window).
class _LargePalmShadowPainter extends CustomPainter {
  final double opacity;

  _LargePalmShadowPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final groundShadow = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.5, 1.0),
        radius: 0.65,
        colors: [
          AppColors.oliveDeep.withValues(alpha: opacity * 0.9),
          AppColors.oliveDeep.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromLTWH(0, size.height * 0.45, size.width, size.height * 0.55));

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.52, size.height * 0.92),
        width: size.width * 1.05,
        height: size.height * 0.38,
      ),
      groundShadow,
    );

    final palm = Paint()
      ..color = AppColors.oliveDeep.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    final cx = size.width * 0.5;
    final baseY = size.height * 0.98;

    final trunk = Path()
      ..moveTo(cx - 14, baseY)
      ..quadraticBezierTo(cx - 10, size.height * 0.62, cx - 6, size.height * 0.38)
      ..lineTo(cx + 6, size.height * 0.38)
      ..quadraticBezierTo(cx + 10, size.height * 0.62, cx + 14, baseY)
      ..close();
    canvas.drawPath(trunk, palm);

    for (var i = 0; i < 9; i++) {
      final t = i / 8;
      final frond = Path();
      final bx = cx + (t - 0.5) * 20;
      final by = size.height * 0.36;
      final tipX = size.width * (0.02 + t * 0.96);
      final tipY = size.height * (0.04 + (i % 3) * 0.04);
      final ctrlX = size.width * (0.15 + t * 0.7);
      final ctrlY = size.height * (0.12 + (i % 2) * 0.06);

      frond.moveTo(bx, by);
      frond.quadraticBezierTo(ctrlX, ctrlY, tipX, tipY);
      frond.quadraticBezierTo(ctrlX, ctrlY + size.height * 0.08, bx + 10, by);
      frond.close();
      canvas.drawPath(frond, palm);
    }

    final castShadow = Paint()
      ..color = Colors.black.withValues(alpha: opacity * 0.35)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 28);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.78),
        width: size.width * 0.72,
        height: size.height * 0.14,
      ),
      castShadow,
    );
  }

  @override
  bool shouldRepaint(covariant _LargePalmShadowPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

/// Sidi Bou Said blue arched door silhouette.
class _BlueDoorSilhouettePainter extends CustomPainter {
  final double opacity;

  _BlueDoorSilhouettePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final doorFill = Paint()
      ..color = AppColors.sidiBlue.withValues(alpha: opacity * 0.55)
      ..style = PaintingStyle.fill;

    final door = Path()
      ..moveTo(w * 0.12, h * 0.98)
      ..lineTo(w * 0.12, h * 0.38)
      ..arcToPoint(
        Offset(w * 0.88, h * 0.38),
        radius: Radius.circular(w * 0.38),
        clockwise: false,
      )
      ..lineTo(w * 0.88, h * 0.98)
      ..close();
    canvas.drawPath(door, doorFill);

    final studs = Paint()
      ..color = Colors.black.withValues(alpha: opacity * 0.5)
      ..style = PaintingStyle.fill;

    for (var r = 0; r < 5; r++) {
      for (var c = 0; c < 3; c++) {
        canvas.drawCircle(
          Offset(w * (0.28 + c * 0.22), h * (0.48 + r * 0.1)),
          2.8,
          studs,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BlueDoorSilhouettePainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

/// White jasmine cluster (machmoum hint).
class _JasmineClusterPainter extends CustomPainter {
  final double opacity;

  _JasmineClusterPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final petal = Paint()
      ..color = Colors.white.withValues(alpha: opacity * 2.2)
      ..style = PaintingStyle.fill;

    const dots = [
      Offset(24, 18),
      Offset(18, 26),
      Offset(30, 28),
      Offset(22, 34),
      Offset(28, 14),
    ];

    for (final d in dots) {
      canvas.drawCircle(d, 3.2, petal);
    }

    final stem = Paint()
      ..color = AppColors.oliveDeep.withValues(alpha: opacity * 1.5)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(24, 36), const Offset(24, 46), stem);
  }

  @override
  bool shouldRepaint(covariant _JasmineClusterPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

/// Fallback coin illustration — transparent background, brass 100 millimes style.
class _BrassCoinStickerPainter extends CustomPainter {
  final double opacity;

  _BrassCoinStickerPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    final fill = Paint()
      ..color = AppColors.saffronDeep.withValues(alpha: opacity * 0.65)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, r * 0.88, fill);

    final ring = Paint()
      ..color = AppColors.motifInk.withValues(alpha: opacity * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, r * 0.88, ring);
    canvas.drawCircle(center, r * 0.72, ring);

    for (var i = 0; i < 12; i++) {
      final a = i * math.pi / 6;
      final p1 = center + Offset(math.cos(a) * r * 0.74, math.sin(a) * r * 0.74);
      final p2 = center + Offset(math.cos(a) * r * 0.84, math.sin(a) * r * 0.84);
      canvas.drawLine(p1, p2, ring);
    }

    final tp = TextPainter(
      text: TextSpan(
        text: '100',
        style: TextStyle(
          color: AppColors.motifInk.withValues(alpha: opacity * 0.75),
          fontWeight: FontWeight.bold,
          fontSize: r * 0.42,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2 + 2));
  }

  @override
  bool shouldRepaint(covariant _BrassCoinStickerPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

/// Silver 1 dinar coin — transparent background.
class _SilverCoinStickerPainter extends CustomPainter {
  final double opacity;

  _SilverCoinStickerPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    final fill = Paint()
      ..color = Colors.grey.shade400.withValues(alpha: opacity * 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, r * 0.88, fill);

    final ring = Paint()
      ..color = Colors.grey.shade600.withValues(alpha: opacity * 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, r * 0.88, ring);

    final tp = TextPainter(
      text: TextSpan(
        text: '1',
        style: TextStyle(
          color: Colors.grey.shade700.withValues(alpha: opacity * 0.8),
          fontWeight: FontWeight.bold,
          fontSize: r * 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, center - Offset(tp.width / 2, tp.height / 2));

    final palmHint = Paint()
      ..color = Colors.grey.shade600.withValues(alpha: opacity * 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(center.dx - r * 0.3, center.dy + r * 0.5),
      Offset(center.dx - r * 0.3, center.dy + r * 0.2),
      palmHint,
    );
  }

  @override
  bool shouldRepaint(covariant _SilverCoinStickerPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _HarissaChiliPainter extends CustomPainter {
  final double opacity;
  _HarissaChiliPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final red = Paint()
      ..color = AppColors.harissa.withValues(alpha: opacity * 0.85)
      ..style = PaintingStyle.fill;

    final chili = Path()
      ..moveTo(w * 0.5, h * 0.05)
      ..quadraticBezierTo(w * 0.72, h * 0.35, w * 0.55, h * 0.92)
      ..quadraticBezierTo(w * 0.48, h * 0.95, w * 0.42, h * 0.92)
      ..quadraticBezierTo(w * 0.28, h * 0.35, w * 0.5, h * 0.05)
      ..close();
    canvas.drawPath(chili, red);

    final stem = Paint()
      ..color = AppColors.oliveDeep.withValues(alpha: opacity * 0.7)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(w * 0.5, h * 0.05), Offset(w * 0.58, h * 0.0), stem);
  }

  @override
  bool shouldRepaint(covariant _HarissaChiliPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _OliveBranchStickerPainter extends CustomPainter {
  final double opacity;
  _OliveBranchStickerPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final stem = Paint()
      ..color = AppColors.oliveDeep.withValues(alpha: opacity * 0.65)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.9),
      Offset(size.width * 0.8, size.height * 0.15),
      stem,
    );

    final olive = Paint()
      ..color = AppColors.oliveDeep.withValues(alpha: opacity * 0.55)
      ..style = PaintingStyle.fill;

    for (var i = 0; i < 5; i++) {
      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(size.width * (0.25 + i * 0.12), size.height * (0.75 - i * 0.14)),
          width: 10,
          height: 14,
        ),
        olive,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _OliveBranchStickerPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _HamsaStickerPainter extends CustomPainter {
  final double opacity;
  _HamsaStickerPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fill = Paint()
      ..color = AppColors.sidiBlue.withValues(alpha: opacity * 0.45)
      ..style = PaintingStyle.fill;

    final hand = Path()
      ..moveTo(w * 0.5, h * 0.08)
      ..lineTo(w * 0.78, h * 0.35)
      ..lineTo(w * 0.72, h * 0.88)
      ..quadraticBezierTo(w * 0.5, h * 0.95, w * 0.28, h * 0.88)
      ..lineTo(w * 0.22, h * 0.35)
      ..close();
    canvas.drawPath(hand, fill);

    final eye = Paint()
      ..color = AppColors.mediterraneanDeep.withValues(alpha: opacity * 0.6)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(w * 0.5, h * 0.48), w * 0.1, eye);
  }

  @override
  bool shouldRepaint(covariant _HamsaStickerPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _FlagBadgePainter extends CustomPainter {
  final double opacity;
  _FlagBadgePainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2;

    canvas.drawCircle(
      center,
      r * 0.9,
      Paint()
        ..color = AppColors.harissa.withValues(alpha: opacity * 0.75)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      r * 0.38,
      Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.85)
        ..style = PaintingStyle.fill,
    );

    // Crescent on white disk
    canvas.drawCircle(
      Offset(center.dx + r * 0.1, center.dy),
      r * 0.24,
      Paint()
        ..color = AppColors.harissa.withValues(alpha: opacity * 0.85)
        ..style = PaintingStyle.fill,
    );
    canvas.drawCircle(
      Offset(center.dx + r * 0.16, center.dy),
      r * 0.2,
      Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.85)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      Offset(center.dx - r * 0.08, center.dy - r * 0.12),
      r * 0.05,
      Paint()
        ..color = AppColors.harissa.withValues(alpha: opacity * 0.85)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _FlagBadgePainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _TunisiaMapStickerPainter extends CustomPainter {
  final double opacity;
  _TunisiaMapStickerPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final map = Path()
      ..moveTo(w * 0.35, h * 0.05)
      ..lineTo(w * 0.55, h * 0.08)
      ..lineTo(w * 0.62, h * 0.25)
      ..lineTo(w * 0.58, h * 0.55)
      ..lineTo(w * 0.52, h * 0.75)
      ..lineTo(w * 0.45, h * 0.92)
      ..lineTo(w * 0.38, h * 0.7)
      ..lineTo(w * 0.32, h * 0.45)
      ..lineTo(w * 0.3, h * 0.2)
      ..close();

    canvas.drawPath(
      map,
      Paint()
        ..color = AppColors.sidiBlue.withValues(alpha: opacity * 0.4)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      map,
      Paint()
        ..color = AppColors.sidiBlue.withValues(alpha: opacity * 0.55)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _TunisiaMapStickerPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _BrikPastryPainter extends CustomPainter {
  final double opacity;
  _BrikPastryPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final tri = Path()
      ..moveTo(w * 0.5, h * 0.08)
      ..lineTo(w * 0.88, h * 0.88)
      ..lineTo(w * 0.12, h * 0.88)
      ..close();

    canvas.drawPath(
      tri,
      Paint()
        ..color = AppColors.saffronDeep.withValues(alpha: opacity * 0.55)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      tri,
      Paint()
        ..color = AppColors.motifInk.withValues(alpha: opacity * 0.35)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );
  }

  @override
  bool shouldRepaint(covariant _BrikPastryPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _ChechiaHatPainter extends CustomPainter {
  final double opacity;
  _ChechiaHatPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.55),
        width: w * 0.85,
        height: h * 0.45,
      ),
      Paint()
        ..color = AppColors.harissa.withValues(alpha: opacity * 0.7)
        ..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.38),
        width: w * 0.7,
        height: h * 0.35,
      ),
      Paint()
        ..color = AppColors.harissa.withValues(alpha: opacity * 0.85)
        ..style = PaintingStyle.fill,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(w * 0.5, h * 0.82),
        width: w * 0.9,
        height: h * 0.12,
      ),
      Paint()
        ..color = Colors.black.withValues(alpha: opacity * 0.25)
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(covariant _ChechiaHatPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _WheatStalksPainter extends CustomPainter {
  final double opacity;
  _WheatStalksPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final stalk = Paint()
      ..color = AppColors.saffronDeep.withValues(alpha: opacity * 0.55)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    for (var i = 0; i < 4; i++) {
      final x = w * (0.25 + i * 0.18);
      canvas.drawLine(Offset(x, h * 0.9), Offset(x, h * 0.15), stalk);
      for (var j = 0; j < 4; j++) {
        final y = h * (0.25 + j * 0.15);
        canvas.drawLine(Offset(x - 4, y), Offset(x + 4, y - 6), stalk);
        canvas.drawLine(Offset(x + 4, y), Offset(x - 4, y - 6), stalk);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _WheatStalksPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}

class _MintTeaGlassPainter extends CustomPainter {
  final double opacity;
  _MintTeaGlassPainter({required this.opacity});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final glass = Path()
      ..moveTo(w * 0.3, h * 0.15)
      ..lineTo(w * 0.25, h * 0.85)
      ..lineTo(w * 0.75, h * 0.85)
      ..lineTo(w * 0.7, h * 0.15)
      ..close();

    canvas.drawPath(
      glass,
      Paint()
        ..color = AppColors.saffronDeep.withValues(alpha: opacity * 0.35)
        ..style = PaintingStyle.fill,
    );
    canvas.drawPath(
      glass,
      Paint()
        ..color = AppColors.motifInk.withValues(alpha: opacity * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );

    final mint = Paint()
      ..color = AppColors.oliveDeep.withValues(alpha: opacity * 0.5)
      ..style = PaintingStyle.fill;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(w * 0.5, h * 0.35), width: w * 0.35, height: h * 0.12),
      mint,
    );
  }

  @override
  bool shouldRepaint(covariant _MintTeaGlassPainter oldDelegate) =>
      oldDelegate.opacity != opacity;
}
