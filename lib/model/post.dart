import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Post {
  final String name;
  final String imagePath;
  final DateTime createdAt;
  final bool isPublic;

  const Post({this.name, this.imagePath, this.createdAt, this.isPublic = true});

  Post.fromMap(Map<String, dynamic> data)
      : this.name = data['name'] as String,
        this.imagePath = data['imagePath'] as String,
        this.createdAt = (data['createdAt'] as Timestamp).toDate(),
        this.isPublic = data['isPublic'] as bool;

  Map<String, dynamic> toMap() {
    // ignore: implicit_dynamic_map_literal
    return {
      'name': name,
      'imagePath': imagePath,
      'createdAt': createdAt,
      'isPublic': isPublic,
    };
  }
}
