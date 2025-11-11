import 'package:dartz/dartz.dart';
import '../repositories/job_repository.dart';
import '../../core/error/failures.dart';

class ToggleFavoriteJob {
  final JobRepository repository;

  ToggleFavoriteJob(this.repository);

  Future<Either<Failure, bool>> call(String jobId) async {
    return await repository.toggleFavoriteJob(jobId);
  }
}
