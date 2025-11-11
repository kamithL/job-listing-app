import 'package:equatable/equatable.dart';

abstract class JobListEvent extends Equatable {
  const JobListEvent();

  @override
  List<Object?> get props => [];
}

class LoadJobsEvent extends JobListEvent {}

class SearchJobsEvent extends JobListEvent {
  final String query;

  const SearchJobsEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class FilterJobsByTypeEvent extends JobListEvent {
  final String jobType;

  const FilterJobsByTypeEvent(this.jobType);

  @override
  List<Object?> get props => [jobType];
}

class ClearFiltersEvent extends JobListEvent {}

class RefreshJobsEvent extends JobListEvent {}
