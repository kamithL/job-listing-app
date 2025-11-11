import 'package:flutter/material.dart';

class FilterChips extends StatelessWidget {
  final String? selectedJobType;
  final Function(String) onFilterSelected;
  final VoidCallback onClearFilters;

  const FilterChips({
    super.key,
    required this.selectedJobType,
    required this.onFilterSelected,
    required this.onClearFilters,
  });

  static const List<String> jobTypes = [
    'Full-time',
    'Part-time',
    'Remote',
    'Contract',
    'Hourly',
  ];

  Color _getJobTypeColor(String jobType) {
    switch (jobType.toLowerCase()) {
      case 'full-time':
        return const Color(0xFF5B37B7);
      case 'part-time':
        return const Color(0xFF3B82F6);
      case 'remote':
        return const Color(0xFF10B981);
      case 'contract':
        return const Color(0xFFF59E0B);
      case 'hourly':
        return const Color(0xFFEC4899);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...jobTypes.map((type) {
            final isSelected = selectedJobType == type;
            final color = _getJobTypeColor(type);

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(type),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    onFilterSelected(type);
                  } else {
                    onClearFilters();
                  }
                },
                backgroundColor: color.withOpacity(0.1),
                selectedColor: color.withOpacity(0.2),
                checkmarkColor: color,
                labelStyle: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(
                  color: isSelected ? color : Colors.transparent,
                  width: 2,
                ),
              ),
            );
          }),
          if (selectedJobType != null)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: TextButton.icon(
                onPressed: onClearFilters,
                icon: const Icon(Icons.clear_all),
                label: const Text('Clear'),
              ),
            ),
        ],
      ),
    );
  }
}
