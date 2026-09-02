// import 'package:flutter/material.dart';
// import 'package:hugeicons/hugeicons.dart';
// import 'package:ketabto_test/config/theme/colors.dart';
// import 'package:ketabto_test/core/widgets/fade_slide_in.dart';

// class ProfileStatsCard extends StatelessWidget {
//   final int books;
//   final int saved;
//   final String rank;
//   final VoidCallback? onBooksTap;
//   final VoidCallback? onSavedTap;

//   const ProfileStatsCard({
//     super.key,
//     required this.books,
//     required this.saved,
//     required this.rank,
//     this.onBooksTap,
//     this.onSavedTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20),
//       child: Row(
//         children: [
//           Expanded(
//             child: FadeSlideIn(
//               index: 0,
//               child: _StatCard(
//                 icon: const HugeIcon(icon: HugeIcons.strokeRoundedBooks01, color: MyColors.primary),
//                 numericValue: books,
//                 title: "Books",
//                 onTap: onBooksTap,
//               ),
//             ),
//           ),

//           const SizedBox(width: 14),

//           Expanded(
//             child: FadeSlideIn(
//               index: 1,
//               child: _StatCard(
//                 icon: const HugeIcon(icon: HugeIcons.strokeRoundedBookmark02, color: MyColors.primary),
//                 numericValue: saved,
//                 title: "Saved",
//                 onTap: onSavedTap,
//               ),
//             ),
//           ),

//           const SizedBox(width: 14),

//           Expanded(
//             child: FadeSlideIn(
//               index: 2,
//               child: _StatCard(
//                 icon: const HugeIcon(icon: HugeIcons.strokeRounded24HoursClock, color: MyColors.primary),
//                 textValue: rank,
//                 title: "Rank",
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _StatCard extends StatelessWidget {
//   final Widget icon;

//   /// Set this for a stat that should count up from zero (Books, Saved).
//   final int? numericValue;

//   /// Set this for a stat that's already a label, not a number (Rank).
//   /// Exactly one of [numericValue] / [textValue] should be provided.
//   final String? textValue;

//   final String title;
//   final VoidCallback? onTap;

//   const _StatCard({
//     required this.icon,
//     this.numericValue,
//     this.textValue,
//     required this.title,
//     this.onTap,
//   }) : assert(numericValue != null || textValue != null, 'Provide numericValue or textValue');

//   @override
//   Widget build(BuildContext context) {
//     final color = Theme.of(context).colorScheme;

//     return Material(
//       color: Colors.transparent,
//       borderRadius: BorderRadius.circular(22),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(22),
//         onTap: onTap,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
//           decoration: BoxDecoration(
//             color: color.surface,
//             borderRadius: BorderRadius.circular(22),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(.05),
//                 blurRadius: 16,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Column(
//             children: [
//               Container(
//                 height: 46,
//                 width: 46,
//                 decoration: BoxDecoration(
//                   color: MyColors.primary.withOpacity(.12),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Padding(padding: const EdgeInsets.all(10.0), child: icon),
//               ),

//               const SizedBox(height: 16),

//               numericValue != null
//                   ? TweenAnimationBuilder<int>(
//                       tween: IntTween(begin: 0, end: numericValue),
//                       duration: const Duration(milliseconds: 900),
//                       curve: Curves.easeOutCubic,
//                       builder: (context, animatedValue, child) {
//                         return Text(
//                           '$animatedValue',
//                           style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                         );
//                       },
//                     )
//                   : Text(
//                       textValue!,
//                       style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                     ),

//               const SizedBox(height: 6),

//               Text(
//                 title,
//                 style: TextStyle(fontSize: 13, color: color.onSurfaceVariant),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
