import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_favorite_jobs.dart';
import '../../../domain/usecases/toggle_favorite_job.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavoriteJobs getFavoriteJobs;
  final ToggleFavoriteJob toggleFavoriteJob;

  FavoritesBloc({
    required this.getFavoriteJobs,
    required this.toggleFavoriteJob,
  }) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await getFavoriteJobs();

    result.fold(
      (failure) => emit(FavoritesError(failure.message)),
      (favoriteIds) => emit(FavoritesLoaded(favoriteJobIds: favoriteIds)),
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    if (state is FavoritesLoaded) {
      final currentState = state as FavoritesLoaded;

      final result = await toggleFavoriteJob(event.jobId);

      result.fold((failure) => emit(FavoritesError(failure.message)), (
        success,
      ) {
        final updatedFavorites = List<String>.from(currentState.favoriteJobIds);
        if (updatedFavorites.contains(event.jobId)) {
          updatedFavorites.remove(event.jobId);
        } else {
          updatedFavorites.add(event.jobId);
        }

        emit(currentState.copyWith(favoriteJobIds: updatedFavorites));
      });
    }
  }
}
