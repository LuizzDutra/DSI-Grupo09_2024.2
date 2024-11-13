import 'package:flutter/material.dart';

class HeartBeatAnimation extends StatefulWidget {
  const HeartBeatAnimation({super.key});

  @override
  _HeartBeatAnimationState createState() => _HeartBeatAnimationState();
}

class _HeartBeatAnimationState extends State<HeartBeatAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100, 
        height: 100, 
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Transform.scale(
              scale: _animation.value,
              child: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
            );
          },
        ),
      ),
    );
  }
}
