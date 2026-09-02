import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';

class RecentSearchChip extends StatelessWidget {
  final String search;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const RecentSearchChip({
    required this.search,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // HugeIcon(
            //   icon: HugeIcons.strokeRoundedSearch01,
            //   size: 18,
            //   color: MyColors.hintGrey,
            // ),

            // const SizedBox(width: 8),

            Text(
              search,
              style:  TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            // const SizedBox(width: 8),

            // GestureDetector(
            //   onTap: onRemove,
            //   child: HugeIcon(
            //     icon: HugeIcons.strokeRoundedCancel01,
            //     size: 17,
            //     color: MyColors.hintGrey,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}