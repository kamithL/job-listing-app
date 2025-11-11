import 'package:dartz/dartz.dart';
import '../entities/job.dart';
import '../repositories/job_repository.dart';
import '../../core/error/failures.dart';

class GetJobById {
  final JobRepository repository;

  GetJobById(this.repository);

  Future<Either<Failure, Job>> call(String id) async {
    return await repository.getJobById(id);
  }
}
