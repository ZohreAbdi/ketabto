import 'package:flutter/material.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/widgets/shimmer_box.dart';

/// Shown while ProfileBloc is loading. Mirrors the real header/stats/
/// menu layout (same 28px header radius, 22px card radius) so the
/// transition into real content doesn't jolt.
class ProfileLoadingSkeleton extends StatelessWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.shadow.withOpacity(.12),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                const ShimmerBox(
                  width: 100,
                  height: 100,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                const SizedBox(height: 20),
                ShimmerBox(
                  width: 140,
                  height: 18,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 8),
                ShimmerBox(
                  width: 180,
                  height: 13,
                  borderRadius: BorderRadius.circular(6),
                ),
                const SizedBox(height: 20),
                ShimmerBox(
                  width: 120,
                  height: 30,
                  borderRadius: BorderRadius.circular(30),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Row(
            children: List.generate(3, (index) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 0 : 7,
                    right: index == 2 ? 0 : 7,
                  ),
                  child: ShimmerBox(
                    width: double.infinity,
                    height: 130,
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          ShimmerBox(
            width: double.infinity,
            height: 84,
            borderRadius: BorderRadius.circular(22),
          ),
          const SizedBox(height: 20),
          ...List.generate(5, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ShimmerBox(
                width: double.infinity,
                height: 52,
                borderRadius: BorderRadius.circular(16),
              ),
            );
          }),
        ],
      ),
    );
  }
}
