import 'package:flutter/material.dart';

/// Service and device category model.
class CategoryModel {
  final String id;
  final String name;
  final String slug;
  final IconData icon;
  final String? subtitle;
  final Color backgroundColor;
  final Color iconColor;
  final String targetRoute;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.icon,
    this.subtitle,
    required this.backgroundColor,
    required this.iconColor,
    required this.targetRoute,
  });
}
