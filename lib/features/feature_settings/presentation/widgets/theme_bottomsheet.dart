import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/config/theme/theme_controller.dart';

class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final currentTheme = ThemeController.themeNotifier.value;

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(.15),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Settings.Theme'.tr(),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const SizedBox(height: 20),

          _ThemeOption(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedSun03,
              color: MyColors.primary,
              size: 21,
            ),
            title: 'Profile.Light'.tr(),
            value: ThemeMode.light,
            selected: currentTheme == ThemeMode.light,
            onTap: () async {
              await ThemeController.setTheme(ThemeMode.light);

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),

          const SizedBox(height: 10),

          _ThemeOption(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedMoon02,
              color: MyColors.primary,
              size: 21,
            ),
            title: 'Profile.Dark'.tr(),
            value: ThemeMode.dark,
            selected: currentTheme == ThemeMode.dark,
            onTap: () async {
              await ThemeController.setTheme(ThemeMode.dark);

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),

          const SizedBox(height: 10),

          _ThemeOption(
            icon: const HugeIcon(
              icon: HugeIcons.strokeRoundedComputer,
              color: MyColors.primary,
              size: 21,
            ),
            title: 'Profile.System'.tr(),
            value: ThemeMode.system,
            selected: currentTheme == ThemeMode.system,
            onTap: () async {
              await ThemeController.setTheme(ThemeMode.system);

              if (context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }
}

class _ThemeOption extends StatelessWidget {
  final Widget icon;
  final String title;
  final ThemeMode value;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeOption({
    required this.icon,
    required this.title,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: selected ? MyColors.primary.withOpacity(.10) : colorScheme.surface,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: MyColors.primary.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: Center(child: icon),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),

              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: selected
                        ? MyColors.primary
                        : colorScheme.onSurface.withOpacity(.25),
                    width: 2,
                  ),
                ),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: selected ? 1 : 0,
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: MyColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
