import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/widgets/price_formmater..dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step_tip.dart';

class PriceStep extends StatelessWidget {
  final TextEditingController controller;
  const PriceStep({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StepTip(
          title: 'AddBook.Step5Tip'.tr(),
          message: 'AddBook.Step5Tipmsg'.tr(),
        ),
        SizedBox(height: MediaQuery.of(context).size.width * 0.1),
        TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ThousandsSeparatorInputFormatter(),
          ],
          maxLength: 11,
          style: TextStyle(color: colorScheme.onSurface, fontSize: 15),
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'AddBook.Toman'.tr(),
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
          validator: (v) {
            final value = v!.replaceAll(',', '').trim();
            if (double.tryParse(value) == null) {
              return 'AddBook.validPricemsg'.tr();
            }
            if (v == null || v.trim().isEmpty)
              return 'AddBook.nullPricemsg'.tr();
            if (v.length < 4) return 'AddBook.validPricemsg'.tr();
            return null;
          },
        ),
      ],
    );
  }
}

// ─── Shared labeled field ───────────────────────────────────────────────────
