//import 'package:flutter/widget_previews.dart';
import 'package:easy_localization/easy_localization.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/di/dependency_injection.dart';
import 'package:ketabto_test/features/feature_home/presentation/screens/home_screen.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/bloc/addbook_bloc.dart';
import 'package:ketabto_test/features/feature_addbooks/presentation/screens/add_book_screen.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/get_book_bloc/get_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/recent_books_bloc/recent_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/screens/explore_screen.dart';
import 'package:ketabto_test/features/feature_profile/presentation/bloc/bloc/profile_bloc.dart';
import 'package:ketabto_test/features/feature_profile/presentation/screens/profile_screen.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();

  //   _pages = [HomeScreen(), AddBook(), ExploreScreen(), ChatListScreen()];
  // }

  @override
  void initState() {
    // ← move from didChangeDependencies, no context needed here
    super.initState();
    _pages = [
      BlocProvider(
        create: (_) => sl<BookBloc>()..add(const GetBooksEvent()),
        child: const HomeScreen(),
      ),

      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => sl<BookBloc>()..add(const GetBooksEvent()),
          ),
          BlocProvider(
            create: (_) =>
                sl<RecentBooksBloc>()..add(const GetRecentBooksEvent()),
          ),
        ],
        child: const ExploreScreen(),
      ),
      BlocProvider(
        create: (_) => sl<AddBookBloc>(),
        child: const AddBookScreen(ownerId: '', ownerName: ''),
      ),
      const Center(child: Text("Chat")),
      BlocProvider(
        create: (_) => sl<ProfileBloc>(),
        child: const ProfileScreen(),
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  // void _onItemTapped(int index) {
  //   if (index == 1) {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => AddBook()));
  //   } else {
  //     setState(() {
  //       _selectedIndex = index;
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          iconTheme: WidgetStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return const IconThemeData(color: MyColors.primary);
            }

            return IconThemeData(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(MaterialState.selected)) {
              return const TextStyle(
                color: MyColors.labelGrey,
                fontFamily: 'SF',
                fontSize: 14,
              );
            }

            return TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontFamily: 'SF',
              fontSize: 14,
            );
          }),
        ),
        child: NavigationBar(
          height: 70,
          elevation: 0,
          onDestinationSelected: _onItemTapped,
          selectedIndex: _selectedIndex,
          indicatorColor: Colors.transparent,
          destinations: <Widget>[
            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedHome01),
              //Icon(Symbols.home_rounded),
              selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedHome01,
                strokeWidth: 2,
              ),
              //Icon(Symbols.home_filled_rounded, fill: 1),
              label: "Navigation.Home".tr(),
            ),
            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedLibraries),
              //Icon(Symbols.book_4),
              selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedLibraries,
                strokeWidth: 2,
              ),
              //Icon(Symbols.book_4, fill: 1),
              label: "Navigation.Books".tr(),
            ),
            // NavigationDestination(icon: Icon(Icons.bookmark), label: ''),
            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedAddCircle),
              //Icon(Symbols.add_circle),
              selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedAddCircle,
                strokeWidth: 2,
              ),
              //Icon(Symbols.add_circle, fill: 1),
              label: "Navigation.AddBook".tr(),
            ),
            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedBubbleChat),
              //Icon(Symbols.chat_bubble),
              selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedBubbleChat,
                strokeWidth: 2,
              ),
              //Icon(Icons.chat_bubble, fill: 1),
              label: "Navigation.Chats".tr(),
            ),
            NavigationDestination(
              icon: HugeIcon(icon: HugeIcons.strokeRoundedUser03),
              // Icon(Symbols.person_2_rounded),
              selectedIcon: HugeIcon(
                icon: HugeIcons.strokeRoundedUser03,
                strokeWidth: 2,
              ),
              //Icon(Symbols.person_2_rounded, fill: 1),
              label: "Navigation.Profile".tr(),
            ),
          ],
        ),
      ),
    );
  }
}
