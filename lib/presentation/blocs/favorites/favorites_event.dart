import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final String jobId;

  const ToggleFavoriteEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}

class CheckFavoriteStatusEvent extends FavoritesEvent {
  final String jobId;

  const CheckFavoriteStatusEvent(this.jobId);

  @override
  List<Object?> get props => [jobId];
}
