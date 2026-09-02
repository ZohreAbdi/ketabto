import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';

enum SnackType { success, error, info }

class AppSnackBar {
  static Future<SnackBarClosedReason> show(
    BuildContext context, {
    required String message,
    SnackType type = SnackType.info,
    String? actionLabel,
    VoidCallback? onAction,
  }) async {
    final colorScheme = Theme.of(context).colorScheme;
    final color = switch (type) {
      SnackType.success => const Color.fromARGB(255, 109, 158, 81),
      SnackType.error => const Color.fromARGB(255, 180, 63, 63),
      SnackType.info => colorScheme.primary,
    };

    final Widget icon = switch (type) {
      SnackType.success => HugeIcon(
        icon: HugeIcons.strokeRoundedCheckmarkCircle01,
        color: colorScheme.onPrimary,
        size: 20,
      ),

      SnackType.error => HugeIcon(
        icon: HugeIcons.strokeRoundedAlertCircle,
        color: colorScheme.onPrimary,
        size: 20,
      ),

      SnackType.info => HugeIcon(
        icon: HugeIcons.strokeRoundedInformationCircle,
        color: colorScheme.onPrimary,
        size: 20,
      ),
    };

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    return ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            action: actionLabel != null
                ? SnackBarAction(
                    label: actionLabel,
                    textColor: colorScheme.onPrimary,
                    onPressed: onAction!,
                  )
                : null,
            behavior: SnackBarBehavior.floating,
            elevation: 0,
            backgroundColor: Colors.transparent,
            duration: const Duration(seconds: 4),
            content: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(.25),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  icon,
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        color: colorScheme.onPrimary,
                        fontSize: 14,
                        height: 1.45,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .closed;
  }

  static Future<SnackBarClosedReason> success(
    BuildContext context,
    String message,
  ) {
    return show(context, message: message, type: SnackType.success);
  }

  static Future<SnackBarClosedReason> error(
    BuildContext context,
    String message,
  ) {
    return show(context, message: message, type: SnackType.error);
  }

  static Future<SnackBarClosedReason> info(
    BuildContext context,
    String message, {
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return show(
      context,
      message: message,
      type: SnackType.info,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }
}
