import 'package:flutter/material.dart';
import 'package:ketabto_test/config/theme/colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  /// Text displayed inside the button.
  final String label;

  /// Called when the button is tapped. Pass `null` to disable.
  final VoidCallback? onPressed;

  /// When `true` an indeterminate [CircularProgressIndicator] replaces the label.
  final bool isLoading;

  // ─── Responsive helpers ─────────────────────────────────────────────────
  double _sw(BuildContext context) => MediaQuery.of(context).size.width;
  double _sh(BuildContext context) => MediaQuery.of(context).size.height;
  double _w(BuildContext context, double v) => _sw(context) / 390 * v;
  double _h(BuildContext context, double v) => _sh(context) / 844 * v;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sw = _sw(context);

    return SizedBox(
      width: double.infinity,
      height: _h(context, 52).clamp(46.0, 56.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: colorScheme.primary.withOpacity(0.6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              _w(context, 12).clamp(8.0, 16.0),
            ),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: _w(context, 22).clamp(18.0, 26.0),
                height: _w(context, 22).clamp(18.0, 26.0),
                child: CircularProgressIndicator(
                  color: colorScheme.onPrimary,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: (sw * 0.048).clamp(13.0, 16.0),
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
