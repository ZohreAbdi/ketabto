import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/bloc/addbook_bloc.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/label_field.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step_tip.dart';
import 'package:ketabto_test/features/feature_category/data/categories.dart';
import 'package:ketabto_test/features/feature_category/domain/category_entity.dart';

class PagesCategoryStep extends StatelessWidget {
  final TextEditingController pagesController;
  final ValueChanged<Category> onCategorySelected;

  const PagesCategoryStep({
    super.key,
    required this.pagesController,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         StepTip(
          title: 'AddBook.Step3Tip'.tr(),
          message: 'AddBook.Step3Tipmsg'.tr(),
        ),
        SizedBox(height: MediaQuery.of(context).size.width * 0.08),
        LabeledField(
          label: 'AddBook.Numberofpages'.tr(),
          controller: pagesController,
          hint: 'AddBook.Numberofpageshint'.tr(),
          keyboardType: TextInputType.number,
          validator: (v) {
            if (v == null || v.trim().isEmpty) return 'AddBook.nullNumofpagesmsg'.tr();
            if (int.tryParse(v.trim()) == null) return 'AddBook.validNumbermsg'.tr();
            return null;
          },
        ),
        const SizedBox(height: 26),
        Text(
          'AddBook.Category'.tr(),
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<AddBookBloc, AddBookState>(
          buildWhen: (prev, curr) => prev.draft.category != curr.draft.category,
          builder: (context, state) {
            final selectedCategory = state.draft.category;
            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((category) {
                final isSelected = category == selectedCategory;
                return GestureDetector(
                  onTap: () => onCategorySelected(category),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      category.name.tr(),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
