import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/models/state_model.dart';
import 'state_card.dart';
import 'deck_animation_controller.dart';

class StateWalletDeck extends StatefulWidget {
  final List<StateModel> states;
  final ValueChanged<StateModel>? onCardTapped;
  final bool hapticFeedbackEnabled;

  const StateWalletDeck({
    Key? key,
    required this.states,
    this.onCardTapped,
    this.hapticFeedbackEnabled = true,
  }) : super(key: key);

  @override
  State<StateWalletDeck> createState() => _StateWalletDeckState();
}

class _StateWalletDeckState extends State<StateWalletDeck>
    with TickerProviderStateMixin {
  late DeckAnimationController _deckController;
  int _activeIndex = 0;
  int _previousIndex = 0;
  double _dragOffset = 0;
  double _dragVelocity = 0;
  bool _isDragging = false;

  static const double _cardSpacing = 56.0;
  static const double _maxDragThreshold = 60.0;
  static const double _velocityThreshold = 500.0;
  static const double _maxTilt = 0.026; // ~1.5 degrees in radians

  @override
  void initState() {
    super.initState();
    _deckController = DeckAnimationController(
      vsync: this,
      onAnimationComplete: _onAnimationComplete,
    );
  }

  @override
  void dispose() {
    _deckController.dispose();
    super.dispose();
  }

  void _onAnimationComplete() {
    if (mounted) {
      setState(() {
        _dragOffset = 0;
        _dragVelocity = 0;
      });
    }
  }

  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
    _deckController.stopAnimation();
    _previousIndex = _activeIndex;
    _dragVelocity = 0;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragVelocity = details.velocity.pixelsPerSecond.dy;

      // Apply spring resistance at boundaries
      final resistanceMultiplier = _calculateResistance(_dragOffset + details.delta.dy);
      _dragOffset += details.delta.dy * resistanceMultiplier;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;

    final velocity = details.velocity.pixelsPerSecond.dy;
    final shouldChangeCard = _dragOffset.abs() > _maxDragThreshold ||
        velocity.abs() > _velocityThreshold;

    if (shouldChangeCard) {
      if (_dragOffset < -_maxDragThreshold || velocity < -_velocityThreshold) {
        // Drag upward - show next card
        if (_activeIndex < widget.states.length - 1) {
          _activeIndex++;
          _triggerHapticFeedback();
          _deckController.animateToPosition(velocity);
        } else {
          _deckController.animateBack();
        }
      } else if (_dragOffset > _maxDragThreshold ||
          velocity > _velocityThreshold) {
        // Drag downward - show previous card
        if (_activeIndex > 0) {
          _activeIndex--;
          _triggerHapticFeedback();
          _deckController.animateToPosition(velocity);
        } else {
          _deckController.animateBack();
        }
      } else {
        _deckController.animateBack();
      }
    } else {
      _deckController.animateBack();
    }
  }

  /// Calculates spring resistance based on drag position
  /// Returns a multiplier between 0.3 and 1.0
  double _calculateResistance(double position) {
    const double springConstant = 0.4;

    if (position < 0) {
      // Dragging upward
      final topBoundary = -(_maxDragThreshold * 2);
      if (position < topBoundary) {
        return springConstant;
      }
    } else if (position > 0) {
      // Dragging downward
      final bottomBoundary = _maxDragThreshold * 2;
      if (position > bottomBoundary) {
        return springConstant;
      }
    }

    return 1.0;
  }

  void _triggerHapticFeedback() {
    if (widget.hapticFeedbackEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  /// Calculates the vertical offset for each card
  double _calculateCardOffset(int index, double animationValue) {
    final indexDifference = index - _activeIndex;

    if (_isDragging) {
      if (indexDifference == 0) {
        return _dragOffset;
      } else if (indexDifference > 0) {
        return _dragOffset + (indexDifference * _cardSpacing);
      } else {
        return _dragOffset + (indexDifference * _cardSpacing);
      }
    } else {
      // Smooth animation with elastic curve
      final targetOffset = indexDifference * _cardSpacing;
      final displayOffset = Tween<double>(
        begin: _dragOffset,
        end: 0,
      ).evaluate(CurvedAnimation(
        parent: _deckController.controller,
        curve: Curves.elasticOut,
      ));

      return targetOffset + displayOffset;
    }
  }

  /// Calculates scale for each card with subtle effect
  double _calculateCardScale(int index) {
    final indexDifference = (index - _activeIndex).abs();
    if (indexDifference == 0) {
      return 1.0;
    } else if (indexDifference == 1) {
      return 0.97; // Slight scale for immediate next card
    } else {
      return 0.95; // Subtle scale for cards further back
    }
  }

  /// Calculates vertical parallax effect during drag
  double _calculateParallax(int index) {
    if (!_isDragging) return 0;

    final indexDifference = (index - _activeIndex).abs();
    final parallaxIntensity = 0.15; // Subtle parallax

    if (index > _activeIndex) {
      return _dragOffset * parallaxIntensity * indexDifference;
    } else if (index < _activeIndex) {
      return _dragOffset * parallaxIntensity * -indexDifference;
    }

    return 0;
  }

  /// Calculates subtle tilt angle during drag (max ~1.5 degrees)
  double _calculateTilt(int index) {
    if (!_isDragging || index != _activeIndex) return 0;

    // Limit tilt to max 1.5 degrees
    final tiltAmount = (_dragOffset / 200).clamp(-_maxTilt, _maxTilt);
    return tiltAmount;
  }

  /// Calculates shadow elevation based on card position
  double _calculateShadowElevation(int index) {
    final indexDifference = (index - _activeIndex).abs();
    if (indexDifference == 0) {
      return 8.0; // Active card has more shadow
    } else if (indexDifference == 1) {
      return 4.0; // Next card has subtle shadow
    } else {
      return 2.0; // Cards further back have minimal shadow
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: _handleDragStart,
      onVerticalDragUpdate: _handleDragUpdate,
      onVerticalDragEnd: _handleDragEnd,
      child: Stack(
        children: List.generate(
          widget.states.length,
          (index) {
            final state = widget.states[index];
            final isActive = index == _activeIndex;
            final cardOffset = _calculateCardOffset(index, 0);
            final cardScale = _calculateCardScale(index);
            final parallax = _calculateParallax(index);
            final tilt = _calculateTilt(index);
            final shadowElevation = _calculateShadowElevation(index);

            return Positioned(
              left: 0,
              right: 0,
              top: 100 + (index * _cardSpacing),
              child: Transform.translate(
                offset: Offset(0, cardOffset + parallax),
                child: Transform.scale(
                  scale: cardScale,
                  alignment: Alignment.topCenter,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateZ(tilt),
                    child: GestureDetector(
                      onTap: isActive
                          ? () => widget.onCardTapped?.call(state)
                          : () {
                              // Tap to switch to this card
                              setState(() {
                                _previousIndex = _activeIndex;
                                _activeIndex = index;
                                _triggerHapticFeedback();
                                _deckController.animateToPosition(0);
                              });
                            },
                      child: _buildCardWithShadow(
                        child: StateCard(
                          state: state,
                          isActive: isActive,
                          isDragging: _isDragging,
                          shadowElevation: shadowElevation,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Wraps card with layered shadow effect for premium appearance
  Widget _buildCardWithShadow({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          // Outer shadow (soft)
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 12),
            spreadRadius: 0,
          ),
          // Mid shadow (subtle)
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
            spreadRadius: 0,
          ),
          // Inner highlight (subtle depth)
          BoxShadow(
            color: Colors.white.withOpacity(0.5),
            blurRadius: 1,
            offset: const Offset(0, 1),
            spreadRadius: 0,
            inset: true,
          ),
        ],
      ),
      child: child,
    );
  }
}
