import 'package:al_rova/utils/constants/colors.dart';
import 'package:al_rova/utils/constants/fonts.dart';
import 'package:flutter/material.dart';

class CustomToast extends StatefulWidget {
  final String message;
  final bool isError;

  const CustomToast({super.key, required this.message, required this.isError});

  @override
  State<CustomToast> createState() => _CustomToastState();
}

class _CustomToastState extends State<CustomToast>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacityAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border(
                    left: BorderSide(
                        width: 10,
                        color: widget.isError ? Colors.red : Colors.green)),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 5.0,
                  ),
                ]),
            child: Text(
              widget.message,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontFamily: Fonts.poppins,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.w500),
            ),
          ),
        );
      },
    );
  }
}
