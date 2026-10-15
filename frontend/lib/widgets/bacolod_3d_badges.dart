import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 3D Toasted Bacolod Piaya Badge
class Piaya3DBadge extends StatelessWidget {
  final double size;
  const Piaya3DBadge({super.key, this.size = 105});

  @override
  Widget build(BuildContext context) {
    final scale = size / 78.0;
    return SizedBox(
      width: size,
      height: size,
      child: Transform.scale(
        scale: scale,
        child: const CustomPaint(painter: _PiayaPainter()),
      ),
    );
  }
}

class _PiayaPainter extends CustomPainter {
  const _PiayaPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-0.24);

    // Drop Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x441E3A8A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 8), width: 64, height: 44),
      shadowPaint,
    );

    // 3D Crust Rim (Deep Ube Purple)
    final rimPaint = Paint()..color = const Color(0xFF4A0E4E);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 4), width: 64, height: 44),
      rimPaint,
    );

    // Flaky Top Disc (Rich Ube Purple Radial Gradient)
    final topRect =
        Rect.fromCenter(center: Offset.zero, width: 64, height: 44);
    final crustPaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.4),
        radius: 0.9,
        colors: [
          Color(0xFFF5E8FF), // Light lavender highlight
          Color(0xFFD8B4FE), // Vibrant ube pastel
          Color(0xFFA855F7), // Rich purple yam
          Color(0xFF581C87), // Deep baked ube crust
        ],
      ).createShader(topRect);
    canvas.drawOval(topRect, crustPaint);

    // Muscovado / Toasted Ube Griddle Spots
    final spotPaint = Paint()..color = const Color(0x993B0764);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(-7, -3), width: 22, height: 13),
      spotPaint,
    );
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(9, 4), width: 17, height: 10),
      spotPaint,
    );

    // Sesame Seeds
    final seedPaint = Paint()..color = const Color(0xFFFFFBEB);
    const seeds = [
      Offset(-12, -5),
      Offset(-1, -9),
      Offset(8, -3),
      Offset(-4, 4),
      Offset(12, 3),
      Offset(-14, 3),
    ];
    for (final pos in seeds) {
      canvas.drawOval(
        Rect.fromCenter(center: pos, width: 4.2, height: 2.2),
        seedPaint,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Iced Bacolod Kape Cup Badge
class Coffee3DBadge extends StatelessWidget {
  final double size;
  const Coffee3DBadge({super.key, this.size = 112});

  @override
  Widget build(BuildContext context) {
    final scale = size / 84.0;
    return SizedBox(
      width: size * (76 / 84),
      height: size,
      child: Transform.scale(
        scale: scale,
        child: const CustomPaint(painter: _CoffeePainter()),
      ),
    );
  }
}

class _CoffeePainter extends CustomPainter {
  const _CoffeePainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(0.2);

    // Straw
    final strawPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(6, -32), const Offset(0, -10), strawPaint);

    // Cup Body
    final cupPath = Path()
      ..moveTo(-18, -8)
      ..lineTo(18, -8)
      ..lineTo(13, 28)
      ..quadraticBezierTo(12, 32, 8, 32)
      ..lineTo(-8, 32)
      ..quadraticBezierTo(-12, 32, -13, 28)
      ..close();
    canvas.drawShadow(cupPath, const Color(0x551E3A8A), 8, true);
    final cupPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFF59E0B), Color(0xFFB45309), Color(0xFF451A03)],
      ).createShader(const Rect.fromLTWH(-20, -10, 40, 45));
    canvas.drawPath(cupPath, cupPaint);

    // Sleeve
    final sleevePath = Path()
      ..moveTo(-16, 3)
      ..lineTo(16, 3)
      ..lineTo(14, 17)
      ..lineTo(-14, 17)
      ..close();
    canvas.drawPath(sleevePath, Paint()..color = const Color(0xFFFEF3C7));
    canvas.drawCircle(
      const Offset(0, 10),
      4,
      Paint()..color = const Color(0xFF92400E),
    );

    // Dome Lid
    final lidRect =
        Rect.fromCenter(center: const Offset(0, -8), width: 38, height: 22);
    canvas.drawArc(
      lidRect,
      math.pi,
      math.pi,
      true,
      Paint()..color = const Color(0xE6FFFFFF),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: const Offset(0, -8), width: 42, height: 5),
        const Radius.circular(3),
      ),
      Paint()..color = Colors.white,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D San Sebastian Cathedral Heritage Badge (Bacolod Landmark)
class Cathedral3DBadge extends StatelessWidget {
  final double size;
  const Cathedral3DBadge({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    final scale = size / 80.0;
    return SizedBox(
      width: size,
      height: size,
      child: Transform.scale(
        scale: scale,
        child: const CustomPaint(painter: _CathedralPainter()),
      ),
    );
  }
}

class _CathedralPainter extends CustomPainter {
  const _CathedralPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2 + 4);
    canvas.rotate(-0.06);

    // Drop Shadow
    final shadowPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(-36, -30, 72, 60),
          const Radius.circular(8),
        ),
      );
    canvas.drawShadow(shadowPath, const Color(0x551E3A8A), 10, true);

    // Main Central Nave Wall (Historic Coral Stone)
    final stonePaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFFBEB),
          Color(0xFFE2E8F0),
          Color(0xFF94A3B8),
        ],
      ).createShader(const Rect.fromLTWH(-32, -32, 64, 60));

    final naveRect = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-18, -14, 36, 42),
      const Radius.circular(4),
    );
    canvas.drawRRect(naveRect, stonePaint);

    // Central Triangular Pediment
    final pedimentPath = Path()
      ..moveTo(-19, -14)
      ..lineTo(0, -32)
      ..lineTo(19, -14)
      ..close();
    final pedimentPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFFFEF3C7), Color(0xFFCBD5E1)],
      ).createShader(const Rect.fromLTWH(-20, -32, 40, 20));
    canvas.drawPath(pedimentPath, pedimentPaint);

    // Left Bell Tower
    final leftTower = RRect.fromRectAndRadius(
      const Rect.fromLTWH(-33, -26, 15, 54),
      const Radius.circular(3),
    );
    canvas.drawRRect(leftTower, stonePaint);

    // Right Bell Tower
    final rightTower = RRect.fromRectAndRadius(
      const Rect.fromLTWH(18, -26, 15, 54),
      const Radius.circular(3),
    );
    canvas.drawRRect(rightTower, stonePaint);

    // Tower Domes / Belfry Caps
    final domePaint = Paint()..color = const Color(0xFFD97706);
    canvas.drawArc(
      const Rect.fromLTWH(-33, -34, 15, 14),
      math.pi,
      math.pi,
      true,
      domePaint,
    );
    canvas.drawArc(
      const Rect.fromLTWH(18, -34, 15, 14),
      math.pi,
      math.pi,
      true,
      domePaint,
    );

    // Belfry Arched Windows
    final belfryWindowPaint = Paint()..color = const Color(0xFF334155);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(-28, -20, 5, 11),
        const Radius.circular(2),
      ),
      belfryWindowPaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        const Rect.fromLTWH(23, -20, 5, 11),
        const Radius.circular(2),
      ),
      belfryWindowPaint,
    );

    // Rose Window (Circular Stained Glass Center)
    final rosetteOuter = Paint()
      ..shader = const RadialGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFEA580C)],
      ).createShader(const Rect.fromLTWH(-8, -12, 16, 16));
    canvas.drawCircle(const Offset(0, -6), 7, rosetteOuter);
    canvas.drawCircle(
      const Offset(0, -6),
      4.5,
      Paint()..color = const Color(0xFF1E293B),
    );
    canvas.drawCircle(
      const Offset(0, -6),
      2,
      Paint()..color = const Color(0xFFFEF08A),
    );

    // Grand Arched Cathedral Portal (Entrance Door)
    final doorArch = Path()
      ..moveTo(-7, 28)
      ..lineTo(-7, 12)
      ..arcToPoint(
        const Offset(7, 12),
        radius: const Radius.circular(7),
        clockwise: true,
      )
      ..lineTo(7, 28)
      ..close();
    final doorPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF78350F), Color(0xFF451A03)],
      ).createShader(const Rect.fromLTWH(-7, 8, 14, 20));
    canvas.drawPath(doorArch, doorPaint);

    // Crosses on Rooftops
    final crossPaint = Paint()
      ..color = const Color(0xFFFDE68A)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // Center Cross
    canvas.drawLine(const Offset(0, -32), const Offset(0, -38), crossPaint);
    canvas.drawLine(const Offset(-3, -35), const Offset(3, -35), crossPaint);

    // Left Cross
    canvas.drawLine(const Offset(-25.5, -34), const Offset(-25.5, -39), crossPaint);
    canvas.drawLine(const Offset(-28, -36.5), const Offset(-23, -36.5), crossPaint);

    // Right Cross
    canvas.drawLine(const Offset(25.5, -34), const Offset(25.5, -39), crossPaint);
    canvas.drawLine(const Offset(23, -36.5), const Offset(28, -36.5), crossPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Bacolod MassKara Festival Smiling Mask Badge
class MassKara3DBadge extends StatelessWidget {
  final double size;
  const MassKara3DBadge({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    final scale = size / 96.0;
    return SizedBox(
      width: size,
      height: size,
      child: Transform.scale(
        scale: scale,
        child: const CustomPaint(painter: _MassKaraPainter()),
      ),
    );
  }
}

class _MassKaraPainter extends CustomPainter {
  const _MassKaraPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    // 1. Drop Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x441E3A8A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(0, 4), width: 68, height: 58),
      shadowPaint,
    );

    // Helper to draw a single sculpted feather plume
    void drawPlume(double angleRad, double length, double width, Color color) {
      canvas.save();
      canvas.rotate(angleRad);
      final p = Path()
        ..moveTo(0, -16)
        ..quadraticBezierTo(width * 0.55, -16 - length * 0.45, 0, -16 - length)
        ..quadraticBezierTo(-width * 0.55, -16 - length * 0.45, 0, -16)
        ..close();
      canvas.drawPath(p, Paint()..color = color);
      canvas.restore();
    }

    // 2. Radiant Fiesta Headdress Petals / Feathers
    // Mirrored on BOTH left (-1) and right (+1) sides with 2 FULL STACKS on each side

    // --- STACK 1: Outer / Back Layer (5 plumes per side + 1 center crest) ---
    final outerColors = [
      const Color(0xFF06B6D4), // Cyan
      const Color(0xFFE11D48), // Magenta
      const Color(0xFFFACC15), // Yellow
      const Color(0xFFF97316), // Orange
      const Color(0xFF10B981), // Emerald
    ];

    // Left and Right symmetrical outer plumes
    for (final side in [-1.0, 1.0]) {
      for (int i = 0; i < 5; i++) {
        final angleDeg = 16.0 + (i * 18.0); // 16°, 34°, 52°, 70°, 88°
        final angleRad = side * (angleDeg * math.pi / 180.0);
        final length = 38.0 - (i * 1.5);
        final color = outerColors[i % outerColors.length];
        drawPlume(angleRad, length, 11.5, color);
      }
    }
    // Center upright crest plume
    drawPlume(0, 42.0, 12.5, const Color(0xFFFACC15));

    // --- STACK 2: Inner / Front Layer (4 plumes per side, fuller layered headdress) ---
    final innerColors = [
      const Color(0xFFFB7185), // Rosy Pink
      const Color(0xFF38BDF8), // Sky Cyan
      const Color(0xFFFDE047), // Sunshine Yellow
      const Color(0xFFFB923C), // Tangerine
    ];

    // Left and Right symmetrical inner plumes (interleaved)
    for (final side in [-1.0, 1.0]) {
      for (int i = 0; i < 4; i++) {
        final angleDeg = 25.0 + (i * 18.0); // 25°, 43°, 61°, 79°
        final angleRad = side * (angleDeg * math.pi / 180.0);
        final length = 28.0 - (i * 1.5);
        final color = innerColors[i % innerColors.length];
        drawPlume(angleRad, length, 9.5, color);
      }
    }
    // Center inner crest plume
    drawPlume(0, 30.0, 10.0, const Color(0xFFE11D48));

    // 3. Curved Headdress Tiara / Band across Forehead
    final crownBand = Path()
      ..moveTo(-24, -3)
      ..quadraticBezierTo(0, -18, 24, -3)
      ..quadraticBezierTo(22, 1, 20, 2)
      ..quadraticBezierTo(0, -12, -20, 2)
      ..close();
    canvas.drawPath(crownBand, Paint()..color = const Color(0xFFF59E0B));

    // Tiara jewel studs
    final studPaint = Paint()..color = const Color(0xFFFEF3C7);
    const studPositions = [
      Offset(-14, -7),
      Offset(-7, -11),
      Offset(0, -13),
      Offset(7, -11),
      Offset(14, -7),
    ];
    for (final pos in studPositions) {
      canvas.drawCircle(pos, 1.8, studPaint);
    }

    // 4. Smiling Mask Face Oval (Golden / Warm Sun Tone)
    final faceRect =
        Rect.fromCenter(center: const Offset(0, 6), width: 50, height: 46);
    final facePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(0.0, -0.2),
        radius: 0.9,
        colors: [
          Color(0xFFFFFBEB),
          Color(0xFFFEF08A),
          Color(0xFFF59E0B),
          Color(0xFFEA580C),
        ],
      ).createShader(faceRect);
    canvas.drawOval(faceRect, facePaint);

    // 5. Arched Joyful Eyes (Closed Smiling Creases)
    final eyePaint = Paint()
      ..color = const Color(0xFF4C0519)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final leftEye = Path()
      ..moveTo(-16, 2)
      ..quadraticBezierTo(-11, -5, -6, 2);
    canvas.drawPath(leftEye, eyePaint);

    final rightEye = Path()
      ..moveTo(6, 2)
      ..quadraticBezierTo(11, -5, 16, 2);
    canvas.drawPath(rightEye, eyePaint);

    // Eyelash Accents
    final lashPaint = Paint()
      ..color = const Color(0xFFBE123C)
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(-15, -1), const Offset(-18, -4), lashPaint);
    canvas.drawLine(const Offset(15, -1), const Offset(18, -4), lashPaint);

    // 6. Rosy Cheeks
    final cheekPaint = Paint()
      ..color = const Color(0x66F43F5E)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(const Offset(-16, 9), 5, cheekPaint);
    canvas.drawCircle(const Offset(16, 9), 5, cheekPaint);

    // 7. Iconic MassKara Beaming Open Smile (White Teeth + Ruby Mouth)
    final mouthPath = Path()
      ..moveTo(-16, 11)
      ..quadraticBezierTo(0, 9, 16, 11)
      ..quadraticBezierTo(0, 27, -16, 11)
      ..close();
    canvas.drawPath(mouthPath, Paint()..color = const Color(0xFF9F1239));

    // Smiling White Teeth
    final teethPath = Path()
      ..moveTo(-14, 11)
      ..quadraticBezierTo(0, 9, 14, 11)
      ..quadraticBezierTo(0, 18, -14, 11)
      ..close();
    canvas.drawPath(teethPath, Paint()..color = Colors.white);

    // 8. Central Forehead Jewel
    canvas.drawCircle(
        const Offset(0, -9), 4.2, Paint()..color = const Color(0xFF06B6D4));
    canvas.drawCircle(
        const Offset(0, -9), 2.2, Paint()..color = Colors.white);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3D Bacolod Chicken Inasal on a Skewer Stick Badge
class Inasal3DBadge extends StatelessWidget {
  final double size;
  const Inasal3DBadge({super.key, this.size = 115});

  @override
  Widget build(BuildContext context) {
    final scale = size / 85.0;
    return SizedBox(
      width: size,
      height: size,
      child: Transform.scale(
        scale: scale,
        child: const CustomPaint(painter: _InasalPainter()),
      ),
    );
  }
}

class _InasalPainter extends CustomPainter {
  const _InasalPainter();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(-0.35); // Classic appetizing grill angle

    // 1. Drop Shadow
    final shadowPaint = Paint()
      ..color = const Color(0x441E3A8A)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
    canvas.drawOval(
      Rect.fromCenter(center: const Offset(4, 14), width: 68, height: 38),
      shadowPaint,
    );

    // 2. Bamboo Skewer Stick (Runs through the chicken)
    final stickPaint = Paint()
      ..color = const Color(0xFFD4A373)
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round;
    // Lower stick (handle)
    canvas.drawLine(const Offset(-38, 22), const Offset(44, -26), stickPaint);
    // Tip of bamboo stick (sharp)
    final tipPath = Path()
      ..moveTo(42, -25)
      ..lineTo(48, -28)
      ..lineTo(44, -23)
      ..close();
    canvas.drawPath(tipPath, Paint()..color = const Color(0xFFB08968));

    // 3. Juicy Grilled Inasal Chicken Leg / Thigh Quarter
    final chickenPath = Path()
      // Top joint
      ..moveTo(26, -16)
      // Plump drumstick curve
      ..quadraticBezierTo(28, -6, 22, 6)
      // Thigh quarter meat
      ..quadraticBezierTo(14, 22, -6, 22)
      ..quadraticBezierTo(-24, 20, -28, 4)
      ..quadraticBezierTo(-30, -10, -12, -18)
      ..quadraticBezierTo(6, -24, 26, -16)
      ..close();

    // Golden Annatto (Atsuete) Char-Grilled Shader
    final chickenPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFDE047), // Grilled golden yellow
          Color(0xFFF97316), // Rich annatto orange
          Color(0xFFEA580C), // Glazed red-orange
          Color(0xFF78350F), // Deep savory caramelized roast
        ],
        stops: [0.0, 0.35, 0.70, 1.0],
      ).createShader(const Rect.fromLTWH(-32, -24, 64, 48));
    canvas.drawPath(chickenPath, chickenPaint);

    // 4. Glossy Annatto Oil Sheen Highlight
    final sheenPath = Path()
      ..moveTo(-18, -12)
      ..quadraticBezierTo(2, -18, 18, -10);
    final sheenPaint = Paint()
      ..color = const Color(0x66FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(sheenPath, sheenPaint);

    // 5. Authentic Char-Grill Marks (Smoky Bacolod Inasal lines)
    final charPaint = Paint()
      ..color = const Color(0x99451A03)
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(-16, 2), const Offset(-8, -12), charPaint);
    canvas.drawLine(const Offset(-6, 12), const Offset(4, -4), charPaint);
    canvas.drawLine(const Offset(6, 14), const Offset(14, 2), charPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

