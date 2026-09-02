import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/bloc/addbook_bloc.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step_tip.dart';

class CoverStep extends StatelessWidget {
  final VoidCallback onTapPick;
  const CoverStep({super.key, required this.onTapPick});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sw = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTip(
          title: 'AddBook.Step1Tip'.tr(),
          message: 'AddBook.Step1Tipmsg'.tr(),
        ),
        SizedBox(height: sw * 0.12),
        Center(
          child: GestureDetector(
            onTap: onTapPick,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: sw * 0.5,
              height: sw * 0.72,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: colorScheme.surfaceContainerHighest,
              ),
              clipBehavior: Clip.antiAlias,
              child: BlocBuilder<AddBookBloc, AddBookState>(
                buildWhen: (prev, curr) => prev.draft.image != curr.draft.image,
                builder: (context, state) {
                  final image = state.draft.image;
                  if (image == null) {
                    return CustomPaint(
                      painter: _DashedBorderPainter(
                        color: colorScheme.primary.withOpacity(0.35),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            HugeIcon(
                              icon: HugeIcons.strokeRoundedImageAdd02,
                              size: 34,
                              color: colorScheme.primary.withOpacity(0.6),
                            ),
                            // Icon(
                            //   Icons.add_photo_alternate_outlined,
                            //   size: 34,
                            //   color: MyColors.primary.withOpacity(0.6),
                            // ),
                            const SizedBox(height: 10),
                            Text(
                              'AddBook.Taptoupload'.tr(),
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  // No Hero here — the persistent top-bar thumbnail is the
                  // actual Hero source/destination.
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(image, fit: BoxFit.cover),
                      Positioned(
                        right: 8,
                        bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.all(7),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            size: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  const _DashedBorderPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(20),
    );

    const dashWidth = 7.0;
    const dashSpace = 5.0;
    final path = Path()..addRRect(rrect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        canvas.drawPath(
          metric.extractPath(distance, distance + dashWidth),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}
