import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/storage_constants.dart';
import '../../core/error/exceptions.dart';

abstract class JobLocalDataSource {
  Future<List<String>> getFavoriteJobIds();
  Future<bool> toggleFavoriteJob(String jobId);
  Future<bool> isFavorite(String jobId);
}

class JobLocalDataSourceImpl implements JobLocalDataSource {
  final SharedPreferences sharedPreferences;

  JobLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getFavoriteJobIds() async {
    try {
      final favoriteIds = sharedPreferences.getStringList(
        StorageConstants.favoriteJobsKey,
      );
      return favoriteIds ?? [];
    } catch (e) {
      throw CacheException('Failed to get favorite jobs: ${e.toString()}');
    }
  }

  @override
  Future<bool> toggleFavoriteJob(String jobId) async {
    try {
      final favoriteIds =
          sharedPreferences.getStringList(StorageConstants.favoriteJobsKey) ??
          [];

      if (favoriteIds.contains(jobId)) {
        favoriteIds.remove(jobId);
      } else {
        favoriteIds.add(jobId);
      }

      return await sharedPreferences.setStringList(
        StorageConstants.favoriteJobsKey,
        favoriteIds,
      );
    } catch (e) {
      throw CacheException('Failed to toggle favorite: ${e.toString()}');
    }
  }

  @override
  Future<bool> isFavorite(String jobId) async {
    try {
      final favoriteIds =
          sharedPreferences.getStringList(StorageConstants.favoriteJobsKey) ??
          [];
      return favoriteIds.contains(jobId);
    } catch (e) {
      throw CacheException('Failed to check favorite status: ${e.toString()}');
    }
  }
}
