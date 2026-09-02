import 'package:flutter/material.dart';
import 'loading_book_card.dart';

class LoadingBookList extends StatelessWidget {
  const LoadingBookList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 6,
      itemBuilder: (_, __) => const LoadingBookCard(),
    );
  }
}