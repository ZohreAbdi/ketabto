import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ketabto_test/config/theme/colors.dart';
import 'package:ketabto_test/core/entities/book_entity.dart';
import 'package:ketabto_test/features/feature_activity/presentation/blocs/saved_books_bloc/saved_books_bloc.dart';
import 'package:ketabto_test/features/feature_getbooks/presentation/screens/book_detail_screen.dart';

class HomeBookCard extends StatelessWidget {
  final BookEntity book;
  final int index;

  const HomeBookCard({super.key, required this.book, required this.index});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final heroTag = 'home_book_${book.id}';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 400),
            reverseTransitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (_, __, ___) {
              return BlocProvider.value(
                value: context.read<SavedBooksBloc>(),
                child: BookDetailScreen(book: book, heroTag: heroTag),
              );
            },
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: SizedBox(
        width: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: heroTag,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: AspectRatio(
                  aspectRatio: 0.78,
                  child: Image.network(
                    book.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Container(
                        color: colorScheme.surfaceContainerHighest,
                        child: HugeIcon(
                          icon: HugeIcons.strokeRoundedBookOpen02,
                          size: 34,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              book.name,
              style:  TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
                height: 1.25,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            Text(
              book.writerName,
              style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
