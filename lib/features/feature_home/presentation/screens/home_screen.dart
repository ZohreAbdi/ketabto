import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/di/dependency_injection.dart';
import 'package:ketabto_test/features/feature_activity/presentation/blocs/saved_books_bloc/saved_books_bloc.dart';
import 'package:ketabto_test/features/feature_home/presentation/screens/search_screen.dart';
import 'package:ketabto_test/core/widgets/book_card.dart';
import 'package:ketabto_test/core/widgets/fade_slide_in.dart';
import 'package:ketabto_test/features/feature_home/presentation/widgets/banner_carousel.dart';
import 'package:ketabto_test/features/feature_home/presentation/widgets/category_chip_list.dart';
import 'package:ketabto_test/features/feature_home/presentation/widgets/search_bar.dart';
import 'package:ketabto_test/core/widgets/section_label.dart';
import 'package:ketabto_test/core/widgets/snack_bar.dart';
import 'package:ketabto_test/features/feature_category/data/categories.dart';
import 'package:ketabto_test/features/feature_category/presentation/screens/Categories_screen.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/get_book_bloc/get_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/screens/category_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedCategoryId;
  int _navIndex = 0;

  void _onCategorySelected(String id) async {
    final category = categories.firstWhere((category) => category.id == id);

    final savedBooksBloc = context.read<SavedBooksBloc>();

    setState(() {
      _selectedCategoryId = id;
    });

    await Future.delayed(const Duration(milliseconds: 250));

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<BookBloc>()),
            BlocProvider.value(value: savedBooksBloc),
          ],
          child: CategoryBooksScreen(category: category),
        ),
      ),
    );

    if (!mounted) return;

    setState(() {
      _selectedCategoryId = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              delegate: _SearchHeaderDelegate(),
            ),

            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 14),

                  FadeSlideIn(
                    index: 1,
                    child: const BannerCarousel(
                      banners: [
                        BannerItem(
                          id: 'b1',
                          eyebrow: 'FEATURED',
                          title: 'Autumn reading list',
                          subtitle:
                              '12 novels picked for slow, rainy afternoons.',
                          ctaLabel: 'Explore',
                        ),
                        BannerItem(
                          id: 'b2',
                          eyebrow: 'NEW THIS WEEK',
                          title: 'Rest of the World',
                          subtitle:
                              'A debut short-story collection everyone is discussing.',
                          ctaLabel: 'Read more',
                        ),
                        BannerItem(
                          id: 'b3',
                          eyebrow: 'MEMBERS',
                          title: '2 months free',
                          subtitle:
                              'Unlock the full library with a Plus membership.',
                          ctaLabel: 'Upgrade',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  FadeSlideIn(
                    index: 2,
                    child: SectionLabel(
                      title: 'Home.Categories'.tr(),
                      trailing: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) {
                                final savedBooksBloc = context
                                    .read<SavedBooksBloc>();

                                return MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: context.read<BookBloc>(),
                                    ),
                                    BlocProvider.value(value: savedBooksBloc),
                                  ],
                                  child: const CategoriesScreen(),
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Seeall'.tr(),
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  FadeSlideIn(
                    index: 3,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: CategoryChipList(
                        categories: categories.take(7).toList(),
                        selectedId: _selectedCategoryId,
                        onSelected: _onCategorySelected,
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  BlocBuilder<BookBloc, BookState>(
                    builder: (context, state) {
                      if (state is! BookLoaded) {
                        return const SizedBox.shrink();
                      }

                      final books = state.books;

                      return FadeSlideIn(
                        index: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionLabel(
                              title: 'Home.Recommended'.tr(),
                              trailing: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Seeall'.tr(),
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            SizedBox(
                              height: 220,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: books.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: context.locale.languageCode == 'fa'
                                        ? const EdgeInsets.only(left: 14)
                                        : const EdgeInsets.only(right: 14),
                                    child: HomeBookCard(
                                      book: books[index],
                                      index: index,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            SectionLabel(
                              title: 'Home.NewArrivals'.tr(),
                              trailing: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Seeall'.tr(),
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              height: 220,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: books.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: context.locale.languageCode == 'fa'
                                        ? const EdgeInsets.only(left: 14)
                                        : const EdgeInsets.only(right: 14),
                                    child: HomeBookCard(
                                      book: books.reversed.toList()[index],
                                      index: index,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            SectionLabel(
                              title: 'Home.TopRated'.tr(),
                              trailing: TextButton(
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {},
                                child: Text(
                                  'Seeall'.tr(),
                                  style: TextStyle(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            SizedBox(
                              height: 220,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                padding: const EdgeInsetsDirectional.only(
                                  start: 20,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemCount: books.take(10).length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: context.locale.languageCode == 'fa'
                                        ? const EdgeInsets.only(left: 14)
                                        : const EdgeInsets.only(right: 14),
                                    child: HomeBookCard(
                                      book: books[index],
                                      index: index,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 76;

  @override
  double get maxExtent => 76;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      alignment: Alignment.center,
      child: HomeSearchBar(
        hasNotification: true,
        showNotification: true,
        onSearchTap: () {
          final bookBloc = context.read<BookBloc>();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: bookBloc,
                child: const SearchScreen(),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeaderDelegate oldDelegate) {
    return true;
  }
}
