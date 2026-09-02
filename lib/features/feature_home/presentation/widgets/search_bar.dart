import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/widgets/back_button.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;
  final bool hasNotification;
  final bool showNotification;
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;

  const HomeSearchBar({
    super.key,
    this.onSearchTap,
    this.onNotificationTap,
    this.hasNotification = false,
    this.showNotification = true,
    this.controller,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          // LEFT ACTION
          SizedBox(
            width: 42,
            height: 42,
            child: showNotification
                ? Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.05),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: onNotificationTap,
                      icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedNotification01,
                        color: colorScheme.primary,
                        size: 22,
                      ),
                    ),
                  )
                : GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Center(child: BackWidget()),
                  ),
          ),

          const SizedBox(width: 8),

          // SEARCH
          SizedBox(
            width: 300,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: TextField(
                controller: controller,
                onSubmitted: onSubmitted,
                onChanged: onChanged,
                onTap: onSearchTap,
                cursorColor: colorScheme.primary,

                decoration: InputDecoration(
                  focusedBorder: InputBorder.none,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  hintText: 'Search.SearchBooks'.tr(),
                  hintStyle: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 25,
                    minHeight: 25,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(start: 12,end: 4),
                    child: HugeIcon(
                      icon: HugeIcons.strokeRoundedSearch01,
                      size: 25,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
