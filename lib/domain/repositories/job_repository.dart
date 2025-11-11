import 'package:dartz/dartz.dart';
import '../entities/job.dart';
import '../../core/error/failures.dart';

abstract class JobRepository {
  Future<Either<Failure, List<Job>>> getJobs();
  Future<Either<Failure, Job>> getJobById(String id);
  Future<Either<Failure, List<String>>> getFavoriteJobIds();
  Future<Either<Failure, bool>> toggleFavoriteJob(String jobId);
  Future<Either<Failure, bool>> isFavorite(String jobId);
}
