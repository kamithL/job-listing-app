// import '../../domain/entities/job.dart';

// class JobModel extends Job {
//   const JobModel({
//     required super.id,
//     required super.title,
//     required super.company,
//     required super.location,
//     required super.jobType,
//     required super.description,
//     super.salary,
//     super.companyLogo,
//     required super.requirements,
//     required super.postedDate,
//   });

//   factory JobModel.fromJson(Map<String, dynamic> json) {
//     return JobModel(
//       id: json['id'].toString(),
//       title: json['title'] ?? '',
//       company: json['company'] ?? '',
//       location: json['location'] ?? '',
//       jobType: json['jobType'] ?? 'Full-time',
//       description: json['description'] ?? '',
//       salary: json['salary'],
//       companyLogo: json['companyLogo'],
//       requirements: json['requirements'] != null
//           ? List<String>.from(json['requirements'])
//           : [],
//       postedDate: json['postedDate'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'title': title,
//       'company': company,
//       'location': location,
//       'jobType': jobType,
//       'description': description,
//       'salary': salary,
//       'companyLogo': companyLogo,
//       'requirements': requirements,
//       'postedDate': postedDate,
//     };
//   }

//   Job toEntity() {
//     return Job(
//       id: id,
//       title: title,
//       company: company,
//       location: location,
//       jobType: jobType,
//       description: description,
//       salary: salary,
//       companyLogo: companyLogo,
//       requirements: requirements,
//       postedDate: postedDate,
//     );
//   }
// }
import '../../domain/entities/job.dart';

class JobModel extends Job {
  const JobModel({
    required super.id,
    required super.title,
    required super.company,
    required super.location,
    required super.jobType,
    required super.description,
    super.salary,
    super.companyLogo,
    required super.requirements,
    required super.postedDate,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'].toString(),
      title: json['job_title'] ?? json['title'] ?? '',
      company: json['company_name'] ?? json['company'] ?? '',
      location: json['location_city'] ?? json['location'] ?? '',
      jobType: json['job_type'] ?? json['jobType'] ?? 'Full-time',
      description: json['full_description'] ?? json['description'] ?? '',
      salary: json['salary'] != null ? '\$${json['salary']}' : null,
      companyLogo: json['companyLogo'],
      requirements: json['requirements'] != null
          ? List<String>.from(json['requirements'])
          : [],
      postedDate: json['postedDate'] ?? 'Recently posted',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'jobType': jobType,
      'description': description,
      'salary': salary,
      'companyLogo': companyLogo,
      'requirements': requirements,
      'postedDate': postedDate,
    };
  }

  Job toEntity() {
    return Job(
      id: id,
      title: title,
      company: company,
      location: location,
      jobType: jobType,
      description: description,
      salary: salary,
      companyLogo: companyLogo,
      requirements: requirements,
      postedDate: postedDate,
    );
  }
}
