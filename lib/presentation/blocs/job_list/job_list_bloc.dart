import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_jobs.dart';
import '../../../domain/entities/job.dart';
import 'job_list_event.dart';
import 'job_list_state.dart';

class JobListBloc extends Bloc<JobListEvent, JobListState> {
  final GetJobs getJobs;

  JobListBloc({required this.getJobs}) : super(JobListInitial()) {
    on<LoadJobsEvent>(_onLoadJobs);
    on<SearchJobsEvent>(_onSearchJobs);
    on<FilterJobsByTypeEvent>(_onFilterJobsByType);
    on<ClearFiltersEvent>(_onClearFilters);
    on<RefreshJobsEvent>(_onRefreshJobs);
  }

  Future<void> _onLoadJobs(
    LoadJobsEvent event,
    Emitter<JobListState> emit,
  ) async {
    emit(JobListLoading());

    final result = await getJobs();

    result.fold(
      (failure) => emit(JobListError(failure.message)),
      (jobs) => emit(JobListLoaded(jobs: jobs, filteredJobs: jobs)),
    );
  }

  void _onSearchJobs(SearchJobsEvent event, Emitter<JobListState> emit) {
    if (state is JobListLoaded) {
      final currentState = state as JobListLoaded;
      final query = event.query.toLowerCase();

      List<Job> filtered = currentState.jobs;

      if (query.isNotEmpty) {
        filtered = filtered.where((job) {
          return job.title.toLowerCase().contains(query) ||
              job.company.toLowerCase().contains(query) ||
              job.location.toLowerCase().contains(query);
        }).toList();
      }

      if (currentState.selectedJobType != null) {
        filtered = filtered
            .where((job) => job.jobType == currentState.selectedJobType)
            .toList();
      }

      emit(
        currentState.copyWith(filteredJobs: filtered, searchQuery: event.query),
      );
    }
  }

  void _onFilterJobsByType(
    FilterJobsByTypeEvent event,
    Emitter<JobListState> emit,
  ) {
    if (state is JobListLoaded) {
      final currentState = state as JobListLoaded;

      List<Job> filtered = currentState.jobs;

      if (currentState.searchQuery.isNotEmpty) {
        final query = currentState.searchQuery.toLowerCase();
        filtered = filtered.where((job) {
          return job.title.toLowerCase().contains(query) ||
              job.company.toLowerCase().contains(query) ||
              job.location.toLowerCase().contains(query);
        }).toList();
      }

      filtered = filtered.where((job) => job.jobType == event.jobType).toList();

      emit(
        currentState.copyWith(
          filteredJobs: filtered,
          selectedJobType: event.jobType,
        ),
      );
    }
  }

  void _onClearFilters(ClearFiltersEvent event, Emitter<JobListState> emit) {
    if (state is JobListLoaded) {
      final currentState = state as JobListLoaded;
      emit(
        currentState.copyWith(
          filteredJobs: currentState.jobs,
          searchQuery: '',
          clearJobType: true,
        ),
      );
    }
  }

  Future<void> _onRefreshJobs(
    RefreshJobsEvent event,
    Emitter<JobListState> emit,
  ) async {
    final result = await getJobs();

    result.fold(
      (failure) => emit(JobListError(failure.message)),
      (jobs) => emit(JobListLoaded(jobs: jobs, filteredJobs: jobs)),
    );
  }
}
