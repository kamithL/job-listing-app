import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';
import '../../core/constants/api_constants.dart';
import '../../core/error/exceptions.dart';

abstract class JobRemoteDataSource {
  Future<List<JobModel>> getJobs();
  Future<JobModel> getJobById(String id);
}

class JobRemoteDataSourceImpl implements JobRemoteDataSource {
  final http.Client client;

  JobRemoteDataSourceImpl({required this.client});

  @override
  Future<List<JobModel>> getJobs() async {
    try {
      final response = await client
          .get(
            Uri.parse('${ApiConstants.baseUrl}${ApiConstants.jobsEndpoint}'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => JobModel.fromJson(json)).toList();
      } else {
        throw ServerException('Failed to fetch jobs: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error occurred: ${e.toString()}');
    }
  }

  @override
  Future<JobModel> getJobById(String id) async {
    try {
      final response = await client
          .get(
            Uri.parse(
              '${ApiConstants.baseUrl}${ApiConstants.jobsEndpoint}/$id',
            ),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(ApiConstants.connectionTimeout);

      if (response.statusCode == 200) {
        return JobModel.fromJson(json.decode(response.body));
      } else {
        throw ServerException('Failed to fetch job: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) {
        rethrow;
      }
      throw NetworkException('Network error occurred: ${e.toString()}');
    }
  }
}
