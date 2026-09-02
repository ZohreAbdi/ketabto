import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/features/feature_category/domain/category_entity.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          children: [
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: category.colorValue.withOpacity(.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Image.asset(
                  category.icon as String,
                  width: 28,
                  height: 28,
                  color: category.colorValue,
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              category.name.tr(),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
