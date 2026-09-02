import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/di/dependency_injection.dart';
import 'package:ketabto_test/core/widgets/section_label.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/get_book_bloc/get_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/widgets/book_card.dart';
import 'package:ketabto_test/features/feature_home/presentation/blocs/recent_search_bloc/recent_search_bloc.dart';
import 'package:ketabto_test/features/feature_home/presentation/blocs/search_bloc/search_book_bloc.dart';
import 'package:ketabto_test/features/feature_home/presentation/widgets/recent_chip.dart';
import 'package:ketabto_test/features/feature_home/presentation/widgets/search_bar.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              sl<RecentSearchBloc>()..add(const LoadRecentSearches()),
        ),
        BlocProvider(create: (_) => sl<SearchBooksBloc>()),
      ],
      child: _SearchScreenContent(controller: _searchController),
    );
  }
}

class _SearchScreenContent extends StatelessWidget {
  final TextEditingController controller;

  const _SearchScreenContent({required this.controller});

  void _searchBooks(BuildContext context, String query) {
    final bookState = context.read<BookBloc>().state;

    if (bookState is! BookLoaded) return;

    context.read<SearchBooksBloc>().add(
      SearchBooks(query: query, books: bookState.books),
    );
  }

  void _selectRecentSearch(BuildContext context, String search) {
    controller.text = search;

    // کرسر بره انتهای متن
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    _searchBooks(context, search);
  }

  void _saveRecentSearch(BuildContext context, String query) {
    query = query.trim();

    if (query.isEmpty) return;

    context.read<RecentSearchBloc>().add(AddRecentSearch(query));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 76,
                child: Align(
                  alignment: Alignment.center,
                  child: HomeSearchBar(
                    showNotification: false,
                    controller: controller,
                    onChanged: (query) {
                      _searchBooks(context, query);
                    },
                    onSubmitted: (query) {
                      _saveRecentSearch(context, query);
                    },
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: BlocBuilder<RecentSearchBloc, RecentSearchState>(
                  builder: (context, state) {
                    if (state is RecentSearchLoading) {
                      return const SizedBox.shrink();
                    }

                    if (state is! RecentSearchLoaded ||
                        state.searches.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24),
                        SectionLabel(
                          title: 'Search.SearchHistory'.tr(),
                          trailing: TextButton(
                            onPressed: () {
                              controller.clear();

                              context.read<RecentSearchBloc>().add(
                                const ClearRecentSearches(),
                              );

                              context.read<SearchBooksBloc>().add(
                                const ClearSearchResults(),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Clearall'.tr(),
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 14),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: state.searches.map((search) {
                              return RecentSearchChip(
                                search: search,
                                onTap: () {
                                  _selectRecentSearch(context, search);
                                },
                                onRemove: () {
                                  context.read<RecentSearchBloc>().add(
                                    const ClearRecentSearches(),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<SearchBooksBloc, SearchBooksState>(
                builder: (context, state) {
                  if (state is! SearchLoaded) {
                    return const SizedBox.shrink();
                  }

                  if (state.results.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 30,
                      ),
                      child: Center(
                        child: Text(
                          'Errors.Nobooksfound'.tr(),
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...state.results.asMap().entries.map((entry) {
                          return BookCard(book: entry.value, index: entry.key);
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
