import 'package:flutter/material.dart';
import 'package:ketabto_test/config/theme/colors.dart';

/// A row of pill-shaped segments showing progress through a multi-step flow.
class StepProgressBar extends StatelessWidget {
  final int totalSteps;
  final int currentStep; // 0-based

  const StepProgressBar({
    super.key,
    required this.totalSteps,
    required this.currentStep,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final inactiveColor = colorScheme.onSurface.withOpacity(
  colorScheme.brightness == Brightness.dark ? 0.25 : 0.12,
);
    return Row(
      children: List.generate(totalSteps, (index) {
        final isActiveOrDone = index <= currentStep;
        return Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: index == totalSteps - 1 ? 0 : 6),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              height: 5,
              decoration: BoxDecoration(
                color: isActiveOrDone
                    ? colorScheme.primary
                    : inactiveColor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        );
      }),
    );
  }
}
