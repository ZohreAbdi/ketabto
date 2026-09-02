import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/label_field.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/widgets/step_tip.dart';

class TitleAuthorStep extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController writerController;

  const TitleAuthorStep({
    super.key,
    required this.nameController,
    required this.writerController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         StepTip(
          title: 'AddBook.Step2Tip'.tr(),
          message:'AddBook.Step2Tipmsg'.tr(),
        ),
        SizedBox(height: MediaQuery.of(context).size.width * 0.08),
        LabeledField(
          label: 'AddBook.Booktitle'.tr(),
          controller: nameController,
          hint: 'AddBook.Booktitlehint'.tr(),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'AddBook.nulltitlemsg'.tr() : null,
        ),
        const SizedBox(height: 22),
        LabeledField(
          label: 'AddBook.Writername'.tr(),
          controller: writerController,
          hint: 'AddBook.Writernamehint'.tr(),
          validator: (v) => (v == null || v.trim().isEmpty)
              ? 'AddBook.nullwriternamemsg'.tr()
              : null,
        ),
      ],
    );
  }
}