import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/job_list/job_list_bloc.dart';
import '../blocs/job_list/job_list_event.dart';
import '../blocs/job_list/job_list_state.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../widgets/job_card.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/filter_chips.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_widget.dart';
import 'favorites_page.dart';
import 'job_details_page.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  State<JobListPage> createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  @override
  void initState() {
    super.initState();
    context.read<JobListBloc>().add(LoadJobsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find Your Job'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()),
              );
            },
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
          ),
          IconButton(
            onPressed: () {
              context.read<ThemeBloc>().add(ToggleThemeEvent());
            },
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      body: BlocBuilder<JobListBloc, JobListState>(
        builder: (context, state) {
          if (state is JobListLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: theme.primaryColor),
                  const SizedBox(height: 16),
                  Text('Loading jobs...', style: theme.textTheme.bodyLarge),
                ],
              ),
            );
          }

          if (state is JobListError) {
            return ErrorDisplay(
              message: state.message,
              onRetry: () {
                context.read<JobListBloc>().add(LoadJobsEvent());
              },
            );
          }

          if (state is JobListLoaded) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<JobListBloc>().add(RefreshJobsEvent());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SearchBarWidget(
                          onSearch: (query) {
                            context.read<JobListBloc>().add(
                              SearchJobsEvent(query),
                            );
                          },
                          initialValue: state.searchQuery,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Results',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${state.filteredJobs.length} Jobs',
                                style: TextStyle(
                                  color: theme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.tune),
                              tooltip: 'Advanced Filters',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        FilterChips(
                          selectedJobType: state.selectedJobType,
                          onFilterSelected: (type) {
                            context.read<JobListBloc>().add(
                              FilterJobsByTypeEvent(type),
                            );
                          },
                          onClearFilters: () {
                            context.read<JobListBloc>().add(
                              ClearFiltersEvent(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: state.filteredJobs.isEmpty
                        ? EmptyState(
                            title: 'No Jobs Found',
                            message:
                                state.searchQuery.isNotEmpty ||
                                    state.selectedJobType != null
                                ? 'Try adjusting your search or filters'
                                : 'No jobs available at the moment',
                            icon: Icons.work_off_outlined,
                            onAction:
                                state.searchQuery.isNotEmpty ||
                                    state.selectedJobType != null
                                ? () {
                                    context.read<JobListBloc>().add(
                                      ClearFiltersEvent(),
                                    );
                                  }
                                : null,
                            actionLabel: 'Clear Filters',
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            itemCount: state.filteredJobs.length,
                            itemBuilder: (context, index) {
                              final job = state.filteredJobs[index];
                              return JobCard(
                                job: job,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                          ) => JobDetailsPage(job: job),
                                      transitionsBuilder:
                                          (
                                            context,
                                            animation,
                                            secondaryAnimation,
                                            child,
                                          ) {
                                            const begin = Offset(1.0, 0.0);
                                            const end = Offset.zero;
                                            const curve = Curves.easeInOutCubic;

                                            var tween = Tween(
                                              begin: begin,
                                              end: end,
                                            ).chain(CurveTween(curve: curve));

                                            return SlideTransition(
                                              position: animation.drive(tween),
                                              child: child,
                                            );
                                          },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
