import 'package:equatable/equatable.dart';

class TipModel extends Equatable {
  final String id;
  final String title;
  final String content;
  final String category;
  final DateTime publishDate;
  final String? imageUrl;
  final int likes;
  final bool isLiked;

  const TipModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.publishDate,
    this.imageUrl,
    this.likes = 0,
    this.isLiked = false,
  });

  TipModel copyWith({
    String? id,
    String? title,
    String? content,
    String? category,
    DateTime? publishDate,
    String? imageUrl,
    int? likes,
    bool? isLiked,
  }) {
    return TipModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      publishDate: publishDate ?? this.publishDate,
      imageUrl: imageUrl ?? this.imageUrl,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        content,
        category,
        publishDate,
        imageUrl,
        likes,
        isLiked,
      ];
}
