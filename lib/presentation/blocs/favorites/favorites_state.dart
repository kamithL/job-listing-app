import 'package:equatable/equatable.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<String> favoriteJobIds;
  final Map<String, bool> favoriteStatus;

  const FavoritesLoaded({
    required this.favoriteJobIds,
    this.favoriteStatus = const {},
  });

  @override
  List<Object?> get props => [favoriteJobIds, favoriteStatus];

  bool isFavorite(String jobId) {
    return favoriteJobIds.contains(jobId);
  }

  FavoritesLoaded copyWith({
    List<String>? favoriteJobIds,
    Map<String, bool>? favoriteStatus,
  }) {
    return FavoritesLoaded(
      favoriteJobIds: favoriteJobIds ?? this.favoriteJobIds,
      favoriteStatus: favoriteStatus ?? this.favoriteStatus,
    );
  }
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
