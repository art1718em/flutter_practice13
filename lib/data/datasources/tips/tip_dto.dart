class TipDto {
  final String id;
  final String title;
  final String content;
  final String category;
  final String publishDate;
  final String? imageUrl;
  final int likes;
  final bool isLiked;

  TipDto({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.publishDate,
    this.imageUrl,
    required this.likes,
    required this.isLiked,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'category': category,
    'publishDate': publishDate,
    'imageUrl': imageUrl,
    'likes': likes,
    'isLiked': isLiked,
  };

  factory TipDto.fromJson(Map<String, dynamic> json) => TipDto(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    category: json['category'] as String,
    publishDate: json['publishDate'] as String,
    imageUrl: json['imageUrl'] as String?,
    likes: json['likes'] as int,
    isLiked: json['isLiked'] as bool,
  );
}
