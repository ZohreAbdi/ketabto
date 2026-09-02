import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step_tip.dart';

class DescriptionStep extends StatelessWidget {
  final TextEditingController controller;
  const DescriptionStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTip(
          title: 'AddBook.Step4Tip'.tr(),
          message: 'AddBook.Step4Tipmsg'.tr(),
        ),
        SizedBox(height: MediaQuery.of(context).size.width * 0.08),
        TextFormField(
          controller: controller,
          maxLines: 7,
          maxLength: 500,
          style: TextStyle(
            fontSize: 14.5,
            height: 1.5,
            color: colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: 'AddBook.Describehint'.tr(),
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: colorScheme.surfaceContainerHighest,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: colorScheme.primary, width: 1.4),
            ),
          ),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'AddBook.nullDescribemsg'.tr()
              : null,
        ),
      ],
    );
  }
}
