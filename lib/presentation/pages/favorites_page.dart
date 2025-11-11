import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:job_listing_app/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:job_listing_app/presentation/blocs/favorites/favorites_event.dart';
import 'package:job_listing_app/presentation/blocs/favorites/favorites_state.dart';
import 'package:job_listing_app/presentation/blocs/job_list/job_list_bloc.dart';
import 'package:job_listing_app/presentation/blocs/job_list/job_list_state.dart';
import '../widgets/job_card.dart';
import '../widgets/empty_state.dart';
import 'job_details_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesBloc>().add(LoadFavoritesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Jobs')),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, favState) {
          if (favState is FavoritesLoading) {
            return Center(
              child: CircularProgressIndicator(color: theme.primaryColor),
            );
          }

          if (favState is FavoritesLoaded) {
            if (favState.favoriteJobIds.isEmpty) {
              return EmptyState(
                title: 'No Favorite Jobs',
                message:
                    'Start adding jobs to your favorites by tapping the heart icon',
                icon: Icons.favorite_border,
                onAction: () => Navigator.pop(context),
                actionLabel: 'Browse Jobs',
              );
            }

            return BlocBuilder<JobListBloc, JobListState>(
              builder: (context, jobState) {
                if (jobState is JobListLoaded) {
                  final favoriteJobs = jobState.jobs
                      .where((job) => favState.favoriteJobIds.contains(job.id))
                      .toList();

                  if (favoriteJobs.isEmpty) {
                    return EmptyState(
                      title: 'No Favorite Jobs',
                      message:
                          'The jobs you favorited may no longer be available',
                      icon: Icons.favorite_border,
                      onAction: () => Navigator.pop(context),
                      actionLabel: 'Browse Jobs',
                    );
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              'Your Favorites',
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
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${favoriteJobs.length} Jobs',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          itemCount: favoriteJobs.length,
                          itemBuilder: (context, index) {
                            final job = favoriteJobs[index];
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
                  );
                }

                return Center(
                  child: CircularProgressIndicator(color: theme.primaryColor),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
