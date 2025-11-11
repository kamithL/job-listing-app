import 'package:equatable/equatable.dart';
import '../../../domain/entities/job.dart';

abstract class JobListState extends Equatable {
  const JobListState();

  @override
  List<Object?> get props => [];
}

class JobListInitial extends JobListState {}

class JobListLoading extends JobListState {}

class JobListLoaded extends JobListState {
  final List<Job> jobs;
  final List<Job> filteredJobs;
  final String searchQuery;
  final String? selectedJobType;

  const JobListLoaded({
    required this.jobs,
    required this.filteredJobs,
    this.searchQuery = '',
    this.selectedJobType,
  });

  @override
  List<Object?> get props => [jobs, filteredJobs, searchQuery, selectedJobType];

  JobListLoaded copyWith({
    List<Job>? jobs,
    List<Job>? filteredJobs,
    String? searchQuery,
    String? selectedJobType,
    bool clearJobType = false,
  }) {
    return JobListLoaded(
      jobs: jobs ?? this.jobs,
      filteredJobs: filteredJobs ?? this.filteredJobs,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedJobType: clearJobType
          ? null
          : (selectedJobType ?? this.selectedJobType),
    );
  }
}

class JobListError extends JobListState {
  final String message;

  const JobListError(this.message);

  @override
  List<Object?> get props => [message];
}
