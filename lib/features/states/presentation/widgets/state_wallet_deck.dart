import 'package:flutter/material.dart';
import '../../domain/models/state_model.dart';
import 'state_card.dart';
import 'deck_animation_controller.dart';

class StateWalletDeck extends StatefulWidget {
  final List<StateModel> states;
  final ValueChanged<StateModel>? onCardTapped;

  const StateWalletDeck({
    Key? key,
    required this.states,
    this.onCardTapped,
  }) : super(key: key);

  @override
  State<StateWalletDeck> createState() => _StateWalletDeckState();
}

class _StateWalletDeckState extends State<StateWalletDeck>
    with TickerProviderStateMixin {
  late DeckAnimationController _deckController;
  int _activeIndex = 0;
  double _dragOffset = 0;
  bool _isDragging = false;

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
    setState(() {
      _dragOffset = 0;
    });
  }

  void _handleDragStart(DragStartDetails details) {
    _isDragging = true;
    _deckController.stopAnimation();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    _isDragging = false;

    final velocity = details.velocity.pixelsPerSecond.dy;
    final threshold = 50.0;
    final velocityThreshold = 500.0;

    // Check if drag should trigger a card change
    if (_dragOffset.abs() > threshold || velocity.abs() > velocityThreshold) {
      if (_dragOffset < -threshold || velocity < -velocityThreshold) {
        // Drag upward - show next card
        if (_activeIndex < widget.states.length - 1) {
          _activeIndex++;
          _deckController.animateToPosition(velocity);
        } else {
          _deckController.animateBack();
        }
      } else if (_dragOffset > threshold || velocity > velocityThreshold) {
        // Drag downward - show previous card
        if (_activeIndex > 0) {
          _activeIndex--;
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

  double _calculateCardOffset(int index) {
    final indexDifference = index - _activeIndex;

    if (indexDifference == 0) {
      // Active card follows drag
      return _dragOffset;
    } else if (indexDifference > 0) {
      // Cards below are offset down
      return _dragOffset + (indexDifference * 60.0);
    } else {
      // Cards above are offset up (hidden)
      return _dragOffset + (indexDifference * 60.0);
    }
  }

  double _calculateCardScale(int index) {
    final indexDifference = (index - _activeIndex).abs();
    if (indexDifference == 0) {
      return 1.0;
    } else {
      return 1.0 - (indexDifference * 0.02);
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
            final cardOffset = _calculateCardOffset(index);
            final cardScale = _calculateCardScale(index);
            final animationValue = _deckController.animationValue;

            // Interpolate animation if running
            final displayOffset = _isDragging
                ? cardOffset
                : Tween<double>(
                    begin: cardOffset,
                    end: 0,
                  ).evaluate(CurvedAnimation(
                    parent: _deckController.controller,
                    curve: Curves.elasticOut,
                  ));

            return Positioned(
              left: 0,
              right: 0,
              top: 80 + (index * 60),
              child: Transform.translate(
                offset: Offset(0, displayOffset),
                child: Transform.scale(
                  scale: cardScale,
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    onTap: isActive
                        ? () => widget.onCardTapped?.call(state)
                        : () {
                            // Tap to switch to this card
                            setState(() {
                              _activeIndex = index;
                              _deckController.animateToPosition(0);
                            });
                          },
                    child: StateCard(
                      state: state,
                      isActive: isActive,
                      isDragging: _isDragging,
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
}
