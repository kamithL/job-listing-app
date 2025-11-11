import 'package:dartz/dartz.dart';
import '../repositories/job_repository.dart';
import '../../core/error/failures.dart';

class GetFavoriteJobs {
  final JobRepository repository;

  GetFavoriteJobs(this.repository);

  Future<Either<Failure, List<String>>> call() async {
    return await repository.getFavoriteJobIds();
  }
}
