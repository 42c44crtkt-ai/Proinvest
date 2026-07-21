import 'package:flutter/material.dart';
import '../../domain/models/state_model.dart';

class DeckAnimationController {
  final TickerProvider vsync;
  final VoidCallback onAnimationComplete;

  late AnimationController controller;
  late Animation<double> animation;

  DeckAnimationController({
    required this.vsync,
    required this.onAnimationComplete,
  }) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );

    animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );

    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onAnimationComplete();
      }
    });
  }

  double get animationValue => animation.value;

  void animateToPosition(double velocity) {
    controller.reset();
    controller.forward();
  }

  void animateBack() {
    if (controller.isAnimating) return;
    controller.reset();
    controller.forward();
  }

  void stopAnimation() {
    controller.stop();
  }

  void dispose() {
    controller.dispose();
  }
}
