import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hugeicons/hugeicons.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final List<List<dynamic>> icon;
  final Color colorValue;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
  });

  @override
  List<Object> get props => [
        id,
        name,
        icon,
        colorValue,
      ];
}