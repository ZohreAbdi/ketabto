import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/features/feature_category/domain/category_entity.dart';

class CategoryChipList extends StatelessWidget {
  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const CategoryChipList({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = category.id == selectedId;

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => onSelected(category.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: SizedBox(
                width: 52,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedScale(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutBack,
                      scale: selected ? 1 : .9,
                      child: HugeIcon(
                        icon: category.icon,
                        color: selected
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                
                    const SizedBox(height: 6),
                
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 180),
                      style: TextStyle(
                        color: selected
                            ? Theme.of(context).colorScheme.onSurfaceVariant
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                        fontSize: 13,
                      ),
                      child: Text(category.name.tr()),
                    ),
                
                    const SizedBox(height: 6),
                
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      width: selected ? 24 : 0,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// /// Horizontal, single-select row of category chips.
// class CategoryChipList extends StatelessWidget {
//   final List<Category> categories;
//   final String? selectedId;
//   final ValueChanged<String> onSelected;

//   const CategoryChipList({
//     super.key,
//     required this.categories,
//     required this.selectedId,
//     required this.onSelected,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 40,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         separatorBuilder: (context, index) => const SizedBox(width: 8),
//         itemBuilder: (context, index) {
//           final category = categories[index];
//           final selected = category.id == selectedId;
//           return GestureDetector(
//             onTap: () => onSelected(category.id),
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 250),
//               curve: Curves.easeOut,
//               padding: const EdgeInsets.symmetric(horizontal: 14),
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: selected ? MyColors.primary : Colors.white,
//                 borderRadius: BorderRadius.circular(14),
//                 border: Border.all(
//                   color: selected
//                       ? MyColors.primary
//                       : MyColors.icon.withAlpha(35),
//                 ),
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   HugeIcon(
//                     icon: category.icon,
//                     color: selected ? Colors.white : MyColors.hintGrey,
//                   ),
//                   const SizedBox(width: 6),
//                   Text(
//                     category.name,
//                     style: TextStyle(
//                       color: selected ? Colors.white : MyColors.hintGrey,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
