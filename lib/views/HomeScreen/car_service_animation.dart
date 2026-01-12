import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Enhanced car services animation with smooth transitions
/// Shows: Car Rental → Service → Wash → Decor in a loop
class CarServiceAnimation extends StatefulWidget {
  final double size;

  const CarServiceAnimation({
    Key? key,
    this.size = 200,
  }) : super(key: key);

  @override
  State<CarServiceAnimation> createState() => _CarServiceAnimationState();
}

class _CarServiceAnimationState extends State<CarServiceAnimation>
    with TickerProviderStateMixin {
  late AnimationController _carController;
  late AnimationController _cycleController;
  late AnimationController _transitionController;

  late Animation<double> _carMoveAnimation;
  late Animation<double> _wheelRotation;

  int _currentService = 0;
  int _nextService = 1;

  final List<ServiceData> _services = [
    ServiceData(
      icon: Icons.directions_car,
      label: 'Car Rental',
      color: Color(0xFF00BFA5),
      gradient: [Color(0xFF00BFA5), Color(0xFF00796B)],
    ),
    ServiceData(
      icon: Icons.build_circle,
      label: 'Car Service',
      color: Color(0xFFFF6B6B),
      gradient: [Color(0xFFFF6B6B), Color(0xFFE63946)],
    ),
    ServiceData(
      icon: Icons.water_drop,
      label: 'Car Wash',
      color: Color(0xFF4ECDC4),
      gradient: [Color(0xFF4ECDC4), Color(0xFF2A9D8F)],
    ),
    ServiceData(
      icon: Icons.auto_awesome,
      label: 'Car Decor',
      color: Color(0xFFFFD93D),
      gradient: [Color(0xFFFFD93D), Color(0xFFFFA500)],
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Slower car movement (6 seconds for full cycle)
    _carController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _carMoveAnimation = Tween<double>(
      begin: -0.2,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _carController,
      curve: Curves.easeInOut,
    ));

    _wheelRotation = Tween<double>(
      begin: 0,
      end: math.pi * 12,
    ).animate(_carController);

    // Service cycle (8 seconds per service)
    _cycleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Transition animation (1 second)
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _cycleController.addListener(() {
      int newService = (_cycleController.value * 4).floor() % 4;
      if (newService != _currentService) {
        setState(() {
          _nextService = newService;
        });
        _transitionController.forward(from: 0).then((_) {
          setState(() {
            _currentService = _nextService;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _carController.dispose();
    _cycleController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size * 2.5,
      height: widget.size,
      padding: EdgeInsets.all(widget.size * 0.1),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade50,
            Colors.grey.shade100,
          ],
        ),
        borderRadius: BorderRadius.circular(widget.size * 0.15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _carController,
          _cycleController,
          _transitionController,
        ]),
        builder: (context, child) {
          return Stack(
            children: [
              // Background road
              _buildRoad(),
              
              // Service label and icon
              _buildServiceLabel(),
              
              // Animated car
              _buildAnimatedCar(),
              
              // Special effects based on service
              _buildServiceEffects(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildRoad() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: widget.size * 0.25,
      child: Container(
        height: 4,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.grey.shade300,
              Colors.grey.shade400,
              Colors.grey.shade300,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceLabel() {
    final currentSvc = _services[_currentService];
    final nextSvc = _services[_nextService];
    final transition = Curves.easeInOut.transform(_transitionController.value);

    // Fade between current and next service
    final displayService = _transitionController.value < 0.5 ? currentSvc : nextSvc;
    final opacity = _transitionController.value < 0.5 
        ? 1 - (_transitionController.value * 2)
        : (_transitionController.value - 0.5) * 2;

    return Positioned(
      left: widget.size * 0.1,
      top: widget.size * 0.15,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 500),
        opacity: opacity,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.size * 0.15,
            vertical: widget.size * 0.08,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: displayService.gradient,
            ),
            borderRadius: BorderRadius.circular(widget.size * 0.12),
            boxShadow: [
              BoxShadow(
                color: displayService.color.withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(widget.size * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  displayService.icon,
                  size: widget.size * 0.15,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: widget.size * 0.08),
              Text(
                displayService.label,
                style: TextStyle(
                  fontSize: widget.size * 0.11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCar() {
    final carPosition = _carMoveAnimation.value;
    final bounce = math.sin(_carController.value * math.pi * 4) * 3;

    return Positioned(
      left: (widget.size * 2.5 - widget.size * 0.8) * carPosition,
      bottom: widget.size * 0.25 + bounce,
      child: CustomPaint(
        size: Size(widget.size * 0.8, widget.size * 0.4),
        painter: ModernCarPainter(
          wheelRotation: _wheelRotation.value,
          color: _services[_currentService].color,
        ),
      ),
    );
  }

  Widget _buildServiceEffects() {
    return Positioned.fill(
      child: CustomPaint(
        painter: ServiceEffectsPainter(
          service: _currentService,
          progress: _carController.value,
          color: _services[_currentService].color,
        ),
      ),
    );
  }
}

class ServiceData {
  final IconData icon;
  final String label;
  final Color color;
  final List<Color> gradient;

  ServiceData({
    required this.icon,
    required this.label,
    required this.color,
    required this.gradient,
  });
}

class ModernCarPainter extends CustomPainter {
  final double wheelRotation;
  final Color color;

  ModernCarPainter({
    required this.wheelRotation,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    // Shadow
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.95),
        width: size.width * 0.7,
        height: size.height * 0.15,
      ),
      shadowPaint,
    );

    // Main body
    final bodyPath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.65)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.35,
        size.width * 0.35,
        size.height * 0.35,
      )
      ..lineTo(size.width * 0.55, size.height * 0.35)
      ..quadraticBezierTo(
        size.width * 0.7,
        size.height * 0.35,
        size.width * 0.75,
        size.height * 0.5,
      )
      ..lineTo(size.width * 0.8, size.height * 0.65)
      ..lineTo(size.width * 0.85, size.height * 0.65)
      ..lineTo(size.width * 0.85, size.height * 0.75)
      ..lineTo(size.width * 0.15, size.height * 0.75)
      ..lineTo(size.width * 0.15, size.height * 0.65)
      ..close();

    // Gradient for body
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color,
        color.withOpacity(0.8),
      ],
    );

    final bodyRect = bodyPath.getBounds();
    paint.shader = gradient.createShader(bodyRect);
    canvas.drawPath(bodyPath, paint);

    // Outline
    final outlinePaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;
    canvas.drawPath(bodyPath, outlinePaint);

    // Windows
    final windowPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.lightBlue.shade100.withOpacity(0.8),
          Colors.lightBlue.shade200.withOpacity(0.6),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    // Front window
    final frontWindow = Path()
      ..moveTo(size.width * 0.37, size.height * 0.4)
      ..lineTo(size.width * 0.45, size.height * 0.4)
      ..lineTo(size.width * 0.48, size.height * 0.6)
      ..lineTo(size.width * 0.37, size.height * 0.6)
      ..close();
    canvas.drawPath(frontWindow, windowPaint);

    // Back window
    final backWindow = Path()
      ..moveTo(size.width * 0.5, size.height * 0.4)
      ..lineTo(size.width * 0.58, size.height * 0.4)
      ..lineTo(size.width * 0.63, size.height * 0.6)
      ..lineTo(size.width * 0.52, size.height * 0.6)
      ..close();
    canvas.drawPath(backWindow, windowPaint);

    // Wheels
    _drawWheel(canvas, Offset(size.width * 0.3, size.height * 0.78), size.height * 0.15);
    _drawWheel(canvas, Offset(size.width * 0.7, size.height * 0.78), size.height * 0.15);

    // Headlight
    final headlight = Paint()
      ..color = Colors.yellow.shade300
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
      Offset(size.width * 0.82, size.height * 0.6),
      size.width * 0.025,
      headlight,
    );
  }

  void _drawWheel(Canvas canvas, Offset center, double radius) {
    // Tire
    final tirePaint = Paint()
      ..color = Colors.grey.shade900
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, tirePaint);

    // Rim
    final rimPaint = Paint()
      ..shader = RadialGradient(
        colors: [Colors.grey.shade300, Colors.grey.shade500],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 0.7));
    canvas.drawCircle(center, radius * 0.7, rimPaint);

    // Hub cap
    final hubPaint = Paint()
      ..color = Colors.grey.shade700
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.3, hubPaint);

    // Rotating spokes
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(wheelRotation);

    final spokePaint = Paint()
      ..color = Colors.grey.shade800
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 5; i++) {
      canvas.drawLine(
        Offset.zero,
        Offset(radius * 0.5, 0),
        spokePaint,
      );
      canvas.rotate(math.pi * 2 / 5);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(ModernCarPainter oldDelegate) =>
      wheelRotation != oldDelegate.wheelRotation || color != oldDelegate.color;
}

class ServiceEffectsPainter extends CustomPainter {
  final int service;
  final double progress;
  final Color color;

  ServiceEffectsPainter({
    required this.service,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (service) {
      case 1: // Service - Tools floating
        _drawToolsEffect(canvas, size);
        break;
      case 2: // Wash - Water droplets
        _drawWashEffect(canvas, size);
        break;
      case 3: // Decor - Sparkles
        _drawDecorEffect(canvas, size);
        break;
    }
  }

  void _drawToolsEffect(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (int i = 0; i < 4; i++) {
      final offset = (progress + i * 0.25) % 1.0;
      final x = size.width * (0.3 + i * 0.15);
      final y = size.height * (0.2 + offset * 0.3);
      final rotation = offset * math.pi * 2;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rotation);

      // Draw wrench shape
      canvas.drawLine(Offset(-8, 0), Offset(8, 0), paint);
      canvas.drawCircle(Offset(-8, 0), 4, paint);
      canvas.drawCircle(Offset(8, 0), 4, paint);

      canvas.restore();
    }
  }

  void _drawWashEffect(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade300.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 12; i++) {
      final offset = (progress * 2 + i * 0.08) % 1.0;
      final x = size.width * (0.2 + i * 0.06);
      final y = size.height * (0.1 + offset * 0.6);
      final size1 = 3 + math.sin(progress * math.pi * 4 + i) * 2;

      canvas.drawOval(
        Rect.fromCenter(
          center: Offset(x, y),
          width: size1,
          height: size1 * 1.5,
        ),
        paint,
      );
    }
  }

  void _drawDecorEffect(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < 8; i++) {
      final angle = progress * math.pi * 2 + i * math.pi / 4;
      final scale = (math.sin(progress * math.pi * 3 + i) + 1) / 2;
      final x = size.width * (0.25 + i * 0.1);
      final y = size.height * 0.25;
      final sparkleSize = 8 * scale;

      // Cross sparkle
      canvas.drawLine(
        Offset(x - sparkleSize, y),
        Offset(x + sparkleSize, y),
        paint,
      );
      canvas.drawLine(
        Offset(x, y - sparkleSize),
        Offset(x, y + sparkleSize),
        paint,
      );

      // Diagonal lines
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(math.pi / 4);
      canvas.drawLine(
        Offset(-sparkleSize * 0.7, 0),
        Offset(sparkleSize * 0.7, 0),
        paint,
      );
      canvas.drawLine(
        Offset(0, -sparkleSize * 0.7),
        Offset(0, sparkleSize * 0.7),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(ServiceEffectsPainter oldDelegate) =>
      service != oldDelegate.service || progress != oldDelegate.progress;
}