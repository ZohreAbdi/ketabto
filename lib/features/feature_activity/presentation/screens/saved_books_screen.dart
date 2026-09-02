import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/di/dependency_injection.dart';
import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/core/widgets/back_button.dart';
import 'package:ketabto_test/core/widgets/book_card.dart';
import 'package:ketabto_test/features/feature_activity/presentation/blocs/saved_books_bloc/saved_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/blocs/get_book_bloc/get_books_bloc.dart';

class SavedBooksScreen extends StatelessWidget {
  const SavedBooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // همان SavedBooksBloc اصلی که در main ساخته شده
        BlocProvider.value(value: context.read<SavedBooksBloc>()),

        // BookBloc جدید فقط برای گرفتن لیست کتاب‌ها
        BlocProvider(create: (_) => sl<BookBloc>()..add(const GetBooksEvent())),
      ],
      child: const _SavedBooksView(),
    );
  }
}

class _SavedBooksView extends StatelessWidget {
  const _SavedBooksView();

  @override
  Widget build(BuildContext context) {
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
      body: BlocBuilder<SavedBooksBloc, SavedBooksState>(
        builder: (context, savedState) {
          if (savedState is SavedBooksLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          }

          if (savedState is SavedBooksError) {
            return Center(child: Text(savedState.message));
          }

          if (savedState is! SavedBooksLoaded) {
            return const SizedBox.shrink();
          }

          final savedIds = savedState.bookIds;

          if (savedIds.isEmpty) {
            return Center(
              child: Text(
                'Errors.Nosavedbooksyet'.tr(),
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
              ),
            );
          }

          return BlocBuilder<BookBloc, BookState>(
            builder: (context, bookState) {
              if (bookState is! BookLoaded) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                );
              }

              final savedBooks = bookState.books
                  .where((book) => savedIds.contains(book.id))
                  .toList();

              if (savedBooks.isEmpty) {
                return Center(
                  child: Text(
                    'Errors.Nosavedbooksyet'.tr(),
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(18, 24, 18, 0),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.52,
                ),
                itemCount: savedBooks.length,
                itemBuilder: (context, index) {
                  return Center(
                    child: HomeBookCard(book: savedBooks[index], index: index),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
