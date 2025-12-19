import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_practice13/features/tips/logic/tips_cubit.dart';
import 'package:flutter_practice13/features/tips/logic/tips_state.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TipsCubit>().loadTips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Советы автовладельцам'),
        centerTitle: true,
      ),
      body: BlocBuilder<TipsCubit, TipsState>(
        builder: (context, state) {
          return Column(
            children: [
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: state.categories.length,
                  itemBuilder: (context, index) {
                    final category = state.categories[index];
                    final isSelected = category == state.selectedCategory;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) {
                          context.read<TipsCubit>().setCategory(category);
                        },
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: state.filteredTips.isEmpty
                    ? const Center(
                        child: Text('Нет советов в этой категории'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: state.filteredTips.length,
                        itemBuilder: (context, index) {
                          final tip = state.filteredTips[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            child: InkWell(
                              onTap: () => context.push('/tips/${tip.id}'),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (tip.imageUrl != null)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: tip.imageUrl!,
                                        height: 200,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Container(
                                          height: 200,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.image,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Chip(
                                              label: Text(
                                                tip.category,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ),
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            const Spacer(),
                                            Text(
                                              DateFormat('dd.MM.yyyy')
                                                  .format(tip.publishDate),
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          tip.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          tip.content.split('\n').first,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                tip.isLiked
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: tip.isLiked
                                                    ? Colors.red
                                                    : null,
                                              ),
                                              onPressed: () {
                                                context
                                                    .read<TipsCubit>()
                                                    .toggleLike(tip.id);
                                              },
                                            ),
                                            Text('${tip.likes}'),
                                            const Spacer(),
                                            TextButton(
                                              onPressed: () =>
                                                  context.push('/tips/${tip.id}'),
                                              child: const Text('Читать далее'),
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
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

