import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/di/dependency_injection.dart';
import 'package:ketabto_test/core/widgets/back_button.dart';
import 'package:ketabto_test/core/widgets/fade_slide_in.dart';
import 'package:ketabto_test/features/feature_activity/presentation/blocs/saved_books_bloc/saved_books_bloc.dart';
import 'package:ketabto_test/features/feature_category/data/categories.dart';
import 'package:ketabto_test/features/feature_category/presentation/widgets/category_card.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/get_book_bloc/get_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/screens/category_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: BackWidget(),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<BookBloc, BookState>(
        builder: (context, state) {
          if (state is BookLoading) {
            return Center(
              child: CircularProgressIndicator(color: colorScheme.primary),
            );
          }

          if (state is BookError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: colorScheme.onSurface),
              ),
            );
          }

          if (state is BookLoaded) {
            final books = state.books;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList.separated(
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      final count = books
                          .where((book) => book.category == category.id)
                          .length;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: FadeSlideIn(
                          index: index,
                          child: CategoryCard(
                            category: category,
                            bookCount: count,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (newContext) => MultiBlocProvider(
                                    providers: [
                                      BlocProvider(
                                        create: (_) =>
                                            sl<BookBloc>()
                                              ..add(const GetBooksEvent()),
                                      ),

                                      BlocProvider.value(
                                        value: context.read<SavedBooksBloc>(),
                                      ),
                                    ],
                                    child: CategoryBooksScreen(
                                      category: category,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
