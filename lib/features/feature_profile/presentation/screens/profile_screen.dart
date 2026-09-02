import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/language_controller.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/config/theme/theme_controller.dart';
import 'package:ketabto_test/core/widgets/app_error_view.dart';
import 'package:ketabto_test/core/widgets/back_button.dart';
import 'package:ketabto_test/core/widgets/fade_slide_in.dart';
import 'package:ketabto_test/features/feature_activity/presentation/blocs/saved_books_bloc/saved_books_bloc.dart';
import 'package:ketabto_test/features/feature_activity/presentation/screens/saved_books_screen.dart';
import 'package:ketabto_test/features/feature_profile/presentation/bloc/bloc/profile_bloc.dart';
import 'package:ketabto_test/features/feature_profile/presentation/widgets/count_badge.dart';
import 'package:ketabto_test/features/feature_profile/presentation/widgets/profile_header.dart';
import 'package:ketabto_test/features/feature_profile/presentation/widgets/profile_loading_skeleton.dart';
import 'package:ketabto_test/features/feature_profile/presentation/widgets/profile_menu_tile.dart';
import 'package:ketabto_test/features/feature_profile/presentation/widgets/profile_section.dart';
import 'package:ketabto_test/features/feature_settings/presentation/widgets/language_bottomsheet.dart';
import 'package:ketabto_test/features/feature_settings/presentation/widgets/theme_bottomsheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    context.read<ProfileBloc>().add(const GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const SafeArea(
              child: Column(
                children: [
                  _ProfileTopBar(),
                  Expanded(child: ProfileLoadingSkeleton()),
                ],
              ),
            );
          }

          if (state is ProfileError) {
            return SafeArea(
              child: Column(
                children: [
                  const _ProfileTopBar(),
                  Expanded(
                    child: AppErrorView(
                      title: "Errors.Profileloaderror".tr(),
                      message: state.message,
                      onRetry: () => context.read<ProfileBloc>().add(
                        const GetProfileEvent(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is ProfileSuccess) {
            final user = state.user;

            return SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  SliverAppBar(
                    floating: true,
                    snap: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    centerTitle: false,
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: ProfileHeader(user: user),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: FadeSlideIn(
                        index: 3,
                        child: ProfileSection(
                          title: "Profile.Activity".tr(),
                          children: [
                            ProfileMenuTile(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedBooks01,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              label: "Profile.MyBooks".tr(),
                              trailing: CountBadge(count: 12),
                              onTap: () {
                                // TODO: My Books
                              },
                            ),

                            BlocBuilder<SavedBooksBloc, SavedBooksState>(
                              builder: (context, state) {
                                int count = 0;

                                if (state is SavedBooksLoaded) {
                                  count = state.bookIds.length;
                                }

                                return ProfileMenuTile(
                                  icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedBookmark02,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                  label: "Profile.SavedBooks".tr(),
                                  trailing: CountBadge(count: count),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<SavedBooksBloc>(),
                                          child: const SavedBooksScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // SliverPadding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   sliver: SliverToBoxAdapter(
                  //     child: FadeSlideIn(
                  //       index: 3,
                  //       child: InviteFriendsCard(
                  //         onTap: () {
                  //           // TODO: open the share sheet / invite flow.
                  //         },
                  //       ),
                  //     ),
                  //   ),
                  // ),

                  // const SliverToBoxAdapter(child: SizedBox(height: 20)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: FadeSlideIn(
                        index: 4,
                        child: ProfileSection(
                          title: "Profile.Preferences".tr(),
                          children: [
                            ProfileMenuTile(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedLanguageSquare,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              label: 'Profile.Languages'.tr(),
                              trailing: Text(
                                context.locale.languageCode == 'en'
                                    ? 'English'
                                    : 'فارسی',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                              ),
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  isScrollControlled: true,
                                  builder: (_) => const LanguageBottomsheet(),
                                );
                              },
                            ),

                            ValueListenableBuilder<ThemeMode>(
                              valueListenable: ThemeController.themeNotifier,
                              builder: (context, themeMode, _) {
                                String themeName;

                                switch (themeMode) {
                                  case ThemeMode.light:
                                    themeName = 'Profile.Light'.tr();
                                    break;

                                  case ThemeMode.dark:
                                    themeName = 'Profile.Dark'.tr();
                                    break;

                                  case ThemeMode.system:
                                    themeName = 'Profile.System'.tr();
                                    break;
                                }

                                return ProfileMenuTile(
                                  icon: HugeIcon(
                                    icon: HugeIcons.strokeRoundedMoon02,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                  label: 'Profile.Darkmode'.tr(),
                                  trailing: Text(
                                    themeName,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      builder: (_) => const ThemeBottomSheet(),
                                    );
                                  },
                                );
                              },
                            ),
                            ProfileMenuTile(
                              // Swap for HugeIcons.strokeRoundedNotification0X
                              // once you've confirmed the exact suffix.
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedNotification01,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              label: 'Profile.Notifications'.tr(),
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverToBoxAdapter(
                      child: FadeSlideIn(
                        index: 4,
                        child: ProfileSection(
                          title: "Profile.Support".tr(),
                          children: [
                            ProfileMenuTile(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedUserAdd02,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              label: 'Profile.InviteFriends'.tr(),
                              onTap: () {},
                            ),

                            ProfileMenuTile(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedHelpCircle,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              label: 'Profile.HelpCenter'.tr(),
                              onTap: () {},
                            ),
                            ProfileMenuTile(
                              // Swap for HugeIcons.strokeRoundedNotification0X
                              // once you've confirmed the exact suffix.
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedMail02,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              label: 'Profile.ContactUs'.tr(),
                              onTap: () {},
                            ),
                            ProfileMenuTile(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedInformationCircle,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                              label: 'Profile.AboutKetabto'.tr(),
                              onTap: () {},
                            ),
                            ProfileMenuTile(
                              icon: HugeIcon(
                                icon: HugeIcons.strokeRoundedLogoutCircle01,
                                color: Colors.red.shade400,
                              ),
                              label: 'Profile.SignOut'.tr(),
                              labelColor: Colors.red.shade400,
                              onTap: () => _confirmSignOut(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            );
          }

          return const Center();
        },
      ),
    );
  }

  static void _confirmSignOut(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Profile.Signout?'.tr()),
          content: Text("Profile.SignOutmsg".tr()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Buttons.Cancel'.tr(), style: TextStyle()),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // TODO: dispatch your real sign-out (auth bloc / service).
              },
              child: Text(
                'Profile.SignOut'.tr(),
                style: TextStyle(color: Colors.red.shade400),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Back + settings row, factored out so it can be shown above the
/// loading skeleton and error view too — otherwise those states would
/// strand the person with no way back.
class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: BackWidget(),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedSettings01),
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
