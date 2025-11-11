import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/job_local_datasource.dart';
import '../../data/datasources/job_remote_datasource.dart';
import '../../data/repositories/job_repository_impl.dart';
import '../../domain/repositories/job_repository.dart';
import '../../domain/usecases/get_jobs.dart';
import '../../domain/usecases/get_favorite_jobs.dart';
import '../../domain/usecases/toggle_favorite_job.dart';
import '../../presentation/blocs/favorites/favorites_bloc.dart';
import '../../presentation/blocs/job_list/job_list_bloc.dart';
import '../../presentation/blocs/theme/theme_bloc.dart';

class InjectionContainer {
  static late SharedPreferences _sharedPreferences;
  static late http.Client _httpClient;
  static late JobRepository _jobRepository;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    _httpClient = http.Client();

    final remoteDataSource = JobRemoteDataSourceImpl(client: _httpClient);
    final localDataSource = JobLocalDataSourceImpl(
      sharedPreferences: _sharedPreferences,
    );

    _jobRepository = JobRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
  }

  static JobListBloc createJobListBloc() {
    return JobListBloc(getJobs: GetJobs(_jobRepository));
  }

  static FavoritesBloc createFavoritesBloc() {
    return FavoritesBloc(
      getFavoriteJobs: GetFavoriteJobs(_jobRepository),
      toggleFavoriteJob: ToggleFavoriteJob(_jobRepository),
    );
  }

  static ThemeBloc createThemeBloc() {
    return ThemeBloc(sharedPreferences: _sharedPreferences);
  }
}
