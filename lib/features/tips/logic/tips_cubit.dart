import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice13/domain/usecases/tips/get_tips_usecase.dart';
import 'package:flutter_practice13/domain/usecases/tips/toggle_like_usecase.dart';
import 'tips_state.dart';

class TipsCubit extends Cubit<TipsState> {
  final GetTipsUseCase getTipsUseCase;
  final ToggleLikeUseCase toggleLikeUseCase;

  TipsCubit({
    required this.getTipsUseCase,
    required this.toggleLikeUseCase,
  }) : super(const TipsState()) {
    loadTips();
  }

  Future<void> loadTips() async {
    try {
      final tips = await getTipsUseCase();
      emit(state.copyWith(tips: tips));
    } catch (e) {
      emit(state.copyWith(tips: []));
    }
  }

  void setCategory(String category) {
    emit(state.copyWith(selectedCategory: category));
  }

  Future<void> toggleLike(String tipId) async {
    try {
      await toggleLikeUseCase(tipId);
      await loadTips();
    } catch (e) {
      rethrow;
    }
  }
}
