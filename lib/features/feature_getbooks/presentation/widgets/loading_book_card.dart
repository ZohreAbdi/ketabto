import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingBookCard extends StatelessWidget {
  const LoadingBookCard({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Shimmer.fromColors(
        baseColor: colorScheme.surfaceContainerHighest,
        highlightColor: colorScheme.surface,
        child: Material(
          color: colorScheme.surfaceContainer,
          elevation: 2,
          borderRadius: BorderRadius.circular(22),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 130,
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: SizedBox(
                    height: 130,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18,
                          width: 160,
                          color: colorScheme.surface,
                        ),

                        const SizedBox(height: 12),

                        Container(
                          height: 14,
                          width: 120,
                          color: colorScheme.surface,
                        ),

                        const SizedBox(height: 18),

                        Container(
                          height: 28,
                          width: 90,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),

                        const Spacer(),

                        Row(
                          children: [
                            Container(
                              width: 80,
                              height: 14,
                              color: colorScheme.surface,
                            ),

                            const Spacer(),

                            Container(
                              width: 70,
                              height: 32,
                              decoration: BoxDecoration(
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}