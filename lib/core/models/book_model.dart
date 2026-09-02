import 'package:ketabto_test/core/entities/book_entity.dart';

class BookModel extends BookEntity {
  const BookModel({
    required super.id,
    required super.category,
    required super.name,
    required super.imageUrl,
    required super.writerName,
    required super.price,
    required super.pages,
    required super.description,
    required super.ownerId,
    required super.ownerName,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      writerName: json['writerName']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      pages: (json['pages'] as num?)?.toInt() ?? 0,
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      ownerId: json['ownerId']?.toString() ?? '',
      ownerName: json['ownerName']?.toString() ?? '',
    );
  }

 Map<String, dynamic> toJson() {
  return {
    'name': name,
    'category': category,
    'writerName': writerName,
    'price': price,
    'pages': pages,
    'description': description,
    'imageUrl': imageUrl,
  };
}

Map<String, dynamic> toLocalJson() {
  return {
    'id': id,
    'name': name,
    'category': category,
    'writerName': writerName,
    'price': price,
    'pages': pages,
    'description': description,
    'imageUrl': imageUrl,
    'ownerId': ownerId,
    'ownerName': ownerName,
  };
}

  factory BookModel.fromEntity(BookEntity entity) {
    return BookModel(
      id: entity.id,
      category: entity.category,
      name: entity.name,
      imageUrl: entity.imageUrl,
      writerName: entity.writerName,
      price: entity.price,
      pages: entity.pages,
      description: entity.description,
      ownerId: entity.ownerId,
      ownerName: entity.ownerName,
    );
  }
}