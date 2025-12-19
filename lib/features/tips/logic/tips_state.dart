import 'package:equatable/equatable.dart';
import 'package:flutter_practice13/core/models/tip_model.dart';

class TipsState extends Equatable {
  final List<TipModel> tips;
  final String selectedCategory;
  final bool isLoading;

  const TipsState({
    this.tips = const [],
    this.selectedCategory = 'Все',
    this.isLoading = false,
  });

  List<TipModel> get filteredTips {
    if (selectedCategory == 'Все') {
      return tips;
    }
    return tips.where((tip) => tip.category == selectedCategory).toList();
  }

  List<String> get categories {
    final cats = tips.map((t) => t.category).toSet().toList();
    return ['Все', ...cats];
  }

  TipsState copyWith({
    List<TipModel>? tips,
    String? selectedCategory,
    bool? isLoading,
  }) {
    return TipsState(
      tips: tips ?? this.tips,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [tips, selectedCategory, isLoading];
}


