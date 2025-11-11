import 'package:dartz/dartz.dart';
import '../entities/job.dart';
import '../repositories/job_repository.dart';
import '../../core/error/failures.dart';

class GetJobs {
  final JobRepository repository;

  GetJobs(this.repository);

  Future<Either<Failure, List<Job>>> call() async {
    return await repository.getJobs();
  }
}
