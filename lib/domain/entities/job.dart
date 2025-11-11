import 'package:equatable/equatable.dart';

class Job extends Equatable {
  final String id;
  final String title;
  final String company;
  final String location;
  final String jobType;
  final String description;
  final String? salary;
  final String? companyLogo;
  final List<String> requirements;
  final String postedDate;

  const Job({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.jobType,
    required this.description,
    this.salary,
    this.companyLogo,
    required this.requirements,
    required this.postedDate,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    company,
    location,
    jobType,
    description,
    salary,
    companyLogo,
    requirements,
    postedDate,
  ];
}
