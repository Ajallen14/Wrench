import 'package:flutter/material.dart';

class ResizableFlipCard extends StatefulWidget {
  final Widget front;
  final Widget back;
  final Function(bool isFlipped)? onFlip;

  const ResizableFlipCard({
    super.key,
    required this.front,
    required this.back,
    this.onFlip,
  });

  @override
  State<ResizableFlipCard> createState() => _ResizableFlipCardState();
}

class _ResizableFlipCardState extends State<ResizableFlipCard> {
  bool _showFront = true;

  void toggleCard() {
    setState(() {
      _showFront = !_showFront;
    });
    if (widget.onFlip != null) {
      widget.onFlip!(!_showFront);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleCard,
      // AnimatedSize handles the smooth height change
      child: AnimatedSize(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (Widget child, Animation<double> animation) {
            final rotateAnim = Tween(begin: 0.0, end: 1.0).animate(animation);

            return AnimatedBuilder(
              animation: rotateAnim,
              child: child,
              builder: (context, child) {
                // Simulate a flip by scaling width from 0 to 1
                final val = rotateAnim.value;
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // Perspective
                    ..scale(val, 1.0, 1.0), // Scale X only
                  alignment: Alignment.center,
                  child: child,
                );
              },
            );
          },
          
          child: _showFront
              ? KeyedSubtree(key: const ValueKey(true), child: widget.front)
              : KeyedSubtree(key: const ValueKey(false), child: widget.back),
        ),
      ),
    );
  }
}
