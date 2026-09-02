import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/entities/user_entity.dart';
import 'package:ketabto_test/core/widgets/fade_slide_in.dart';
import 'package:path_provider/path_provider.dart';

/// Hero tag for the profile avatar. Give a matching `Hero` (same tag)
/// to whatever navigates here — a bottom-nav tab, a drawer header, a
/// list row avatar — and Flutter animates a shared-element transition
/// into this screen automatically. No other wiring needed beyond the
/// matching tag; if nothing on the previous route uses this tag, the
/// avatar just appears normally with no transition.
const String kProfileAvatarHeroTag = 'profile-avatar';

class ProfileHeader extends StatefulWidget {
  final UserEntity user;
  const ProfileHeader({super.key, required this.user});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  String? _profileImagePath;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    final box = Hive.box('profileBox');
    final path = box.get('profile_image_path') as String?;

    if (path != null && await File(path).exists()) {
      setState(() {
        _profileImagePath = path;
      });
    }
  }

  // Future<void> onTapPick() async {
  //   final picked = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 85,
  //   );

  //   if (picked == null) return;

  //   final box = Hive.box('profileBox');

  //   // مسیر عکس قبلی
  //   final oldPath = box.get('profile_image_path') as String?;

  //   // حذف عکس قبلی از storage اپ
  //   if (oldPath != null) {
  //     final oldFile = File(oldPath);

  //     if (await oldFile.exists()) {
  //       await oldFile.delete();
  //     }
  //   }

  //   // مسیر storage اختصاصی اپ
  //   final appDir = await getApplicationDocumentsDirectory();

  //   final fileName =
  //       'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

  //   // کپی عکس جدید به storage اپ
  //   final savedImage = await File(picked.path).copy(
  //     '${appDir.path}/$fileName',
  //   );

  //   // ذخیره مسیر عکس جدید در Hive
  //   await box.put(
  //     'profile_image_path',
  //     savedImage.path,
  //   );

  //   if (!mounted) return;

  //   setState(() {
  //     _profileImagePath = savedImage.path;
  //   });
  // }

  // Future<void> onTapPick() async {
  //   final picked = await _picker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 85,
  //   );

  //   if (picked == null) return;

  //   final cropped = await ImageCropper().cropImage(
  //     sourcePath: picked.path,
  //     aspectRatio: const CropAspectRatio(
  //       ratioX: 1,
  //       ratioY: 1,
  //     ),
  //     compressQuality: 90,
  //     uiSettings: [
  //       AndroidUiSettings(
  //         toolbarTitle: 'Edit Profile Photo',
  //         toolbarColor: MyColors.primary,
  //         toolbarWidgetColor: Colors.white,
  //         lockAspectRatio: true,
  //       ),
  //     ],
  //   );

  //   if (cropped == null) return;

  //   debugPrint('Cropped image: ${cropped.path}');
  // }

  Future<void> onTapPick() async {
    final colorScheme = Theme.of(context).colorScheme;
    // 1. انتخاب عکس از گالری
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (picked == null) return;

    // 2. باز کردن Cropper
    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
      uiSettings: [
        AndroidUiSettings(
          toolbarColor: colorScheme.primary,
          toolbarWidgetColor: colorScheme.onPrimary,
          statusBarColor: colorScheme.primary,
          backgroundColor: colorScheme.surface,
          cropFrameColor: colorScheme.onSurface,
          cropGridColor: colorScheme.onSurface.withOpacity(.5),
          lockAspectRatio: true,
          hideBottomControls: true,
        ),

        IOSUiSettings(
          title: 'Edit Profile Photo',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    // اگر کاربر Crop را لغو کرد
    if (cropped == null) return;

    final box = Hive.box('profileBox');

    // 3. گرفتن مسیر عکس قبلی
    final oldPath = box.get('profile_image_path') as String?;

    // 4. ذخیره عکس جدید در storage اختصاصی اپ
    final appDir = await getApplicationDocumentsDirectory();

    final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final savedImage = await File(
      cropped.path,
    ).copy('${appDir.path}/$fileName');

    // 5. حذف عکس قبلی
    if (oldPath != null) {
      final oldFile = File(oldPath);

      if (await oldFile.exists()) {
        await oldFile.delete();
      }
    }

    // 6. ذخیره مسیر عکس جدید در Hive
    await box.put('profile_image_path', savedImage.path);

    if (!mounted) return;

    // 7. آپدیت UI
    setState(() {
      _profileImagePath = savedImage.path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Hero(
            tag: kProfileAvatarHeroTag,
            child: SizedBox(
              width: 110,
              height: 110,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 110,
                    height: 110,
                    padding: const EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: MyColors.primary, width: 3),
                    ),
                    child: ClipOval(
                      child: _profileImagePath != null
                          ? Image.file(
                              File(_profileImagePath!),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/Profile.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),

                  Positioned(
                    right: 2,
                    bottom: 2,
                    child: GestureDetector(
                      onTap: onTapPick,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: MyColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colorScheme.surface,
                            width: 3,
                          ),
                        ),
                        child: const Center(
                          child: HugeIcon(
                            icon: HugeIcons.strokeRoundedEdit03,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          /// Name
          FadeSlideIn(
            index: 0,
            child: Text(
              widget.user.name!,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// Email
          FadeSlideIn(
            index: 1,
            child: Text(
              widget.user.email,
              style: TextStyle(
                fontSize: 15,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Rank Badge
          FadeSlideIn(
            index: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(.15),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.workspace_premium, color: Colors.amber, size: 18),

                  SizedBox(width: 8),

                  Text(
                    "Gold Reader",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
