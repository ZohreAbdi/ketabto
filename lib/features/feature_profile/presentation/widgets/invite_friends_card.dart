// import 'package:flutter/material.dart';
// import 'package:ketabto_test/config/theme/colors.dart';

// /// A highlighted card for the referral/invite flow — visually
// /// distinct from the plain menu rows below it, since this is the one
// /// action on the screen worth calling extra attention to.
// class InviteFriendsCard extends StatelessWidget {
//   final VoidCallback? onTap;

//   const InviteFriendsCard({super.key, this.onTap});

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.transparent,
//       borderRadius: BorderRadius.circular(22),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(22),
//         onTap: onTap,
//         child: Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(22),
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [MyColors.primary, MyColors.focusedBorder],
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: MyColors.primary.withOpacity(.25),
//                 blurRadius: 16,
//                 offset: const Offset(0, 8),
//               ),
//             ],
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 44,
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(.16),
//                   shape: BoxShape.circle,
//                 ),
//                 // Using a Material icon here since I can't confirm the
//                 // exact HugeIcons gift-icon name in this environment —
//                 // swap for something like HugeIcons.strokeRoundedGift
//                 // once you've checked it exists via autocomplete.
//                 child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 22),
//               ),

//               const SizedBox(width: 14),

//               const Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Invite friends',
//                       style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//                     ),
//                     SizedBox(height: 2),
//                     Text(
//                       'Share the shelf — give a friend a free month.',
//                       style: TextStyle(color: Colors.white70, fontSize: 12.5),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(width: 8),
//               const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 18),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
