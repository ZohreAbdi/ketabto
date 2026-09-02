import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/widgets/primary_button.dart';

class AddBookSuccessScreen extends StatefulWidget {
  final File coverImage;
  final String bookName;
  final String writerName;
  final String heroTag;

  const AddBookSuccessScreen({
    super.key,
    required this.coverImage,
    required this.bookName,
    required this.writerName,
    required this.heroTag,
  });

  @override
  State<AddBookSuccessScreen> createState() => _AddBookSuccessScreenState();
}

class _AddBookSuccessScreenState extends State<AddBookSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _checkScale;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Checkmark badge pops in with a bouncy elastic curve.
    _checkScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.55, curve: Curves.elasticOut),
    );

    _textFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.45, 0.85, curve: Curves.easeOut),
    );

    _textSlide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.45, 0.85, curve: Curves.easeOutCubic),
          ),
        );

    // Wait for the Hero flight (~300ms) before starting the celebration.
    Future.delayed(const Duration(milliseconds: 320), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final sw = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),

              // ── Hero cover image + checkmark badge ──────────────────
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Hero(
                    tag: widget.heroTag,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.file(
                        widget.coverImage,
                        width: sw * 0.5,
                        height: sw * 0.72,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -14,
                    right: -14,
                    child: ScaleTransition(
                      scale: _checkScale,
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: colorScheme.primary.withOpacity(0.35),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedTick01,
                          color: colorScheme.onPrimary,
                          size: 28,
                        ),
                        // const Icon(
                        //   Icons.check_rounded,
                        //   color: Colors.white,
                        //   size: 28,
                        // ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              // ── Celebration text ─────────────────────────────────────
              FadeTransition(
                opacity: _textFade,
                child: SlideTransition(
                  position: _textSlide,
                  child: Column(
                    children: [
                      Text(
                        'AddBook.BookAdded'.tr(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'AddBook.msgAddBookSuccess'.tr(
                          namedArgs: {
                            'bookName': widget.bookName,
                            'writerName': widget.writerName,
                          },
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.5,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              FadeTransition(
                opacity: _textFade,
                child: PrimaryButton(
                  label: 'Buttons.Done'.tr(),
                  onPressed: () {
                    // Pop the success screen, then the add-book flow itself.
                    Navigator.of(context).pop();
                    // Navigator.of(context).pop();
                  },
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
