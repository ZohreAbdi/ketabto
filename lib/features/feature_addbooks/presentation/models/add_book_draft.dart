import 'dart:io';

import 'package:ketabto_test/features/feature_category/domain/category_entity.dart';

/// Holds the in-progress book while the user moves through the
/// add-book steps. Lives inside [AddBookState] — the bloc is the
/// single source of truth, the screen just reads/updates it.
class AddBookDraft {
  final File? image;
  final String? imageUrl;
  final String? name;
  final String? writerName;
  final int? pages;
  final Category? category;
  final String? description;
  final double? price;

  const AddBookDraft({
    this.image,
    this.imageUrl,
    this.name,
    this.writerName,
    this.pages,
    this.category,
    this.description,
    this.price,
  });

  AddBookDraft copyWith({
    File? image,
    String? imageUrl,
    String? name,
    String? writerName,
    int? pages,
    Category? category,
    String? description,
    double? price,
  }) {
    return AddBookDraft(
      image: image ?? this.image,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      writerName: writerName ?? this.writerName,
      pages: pages ?? this.pages,
      category: category ?? this.category,
      description: description ?? this.description,
      price: price ?? this.price,
    );
  }
}