import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice13/features/tips/logic/tips_cubit.dart';
import 'package:flutter_practice13/features/tips/logic/tips_state.dart';

class TipDetailScreen extends StatelessWidget {
  final String tipId;

  const TipDetailScreen({
    super.key,
    required this.tipId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TipsCubit, TipsState>(
      builder: (context, state) {
        final tip = state.tips.firstWhere((t) => t.id == tipId);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (tip.imageUrl != null)
                  CachedNetworkImage(
                    imageUrl: tip.imageUrl!,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 250,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 50),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Chip(
                            label: Text(tip.category),
                          ),
                          const Spacer(),
                          Text(
                            DateFormat('dd.MM.yyyy').format(tip.publishDate),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tip.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        tip.content,
                        style: const TextStyle(
                          fontSize: 16,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Divider(),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              tip.isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: tip.isLiked ? Colors.red : null,
                            ),
                            onPressed: () {
                              context.read<TipsCubit>().toggleLike(tip.id);
                            },
                          ),
                          Text(
                            '${tip.likes} ${_getLikesWord(tip.likes)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getLikesWord(int count) {
    if (count % 10 == 1 && count % 100 != 11) {
      return 'отметка';
    } else if ([2, 3, 4].contains(count % 10) &&
        ![12, 13, 14].contains(count % 100)) {
      return 'отметки';
    } else {
      return 'отметок';
    }
  }
}


