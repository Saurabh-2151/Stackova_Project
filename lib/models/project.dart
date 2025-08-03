class Project {
  final String id;
  final String title;
  final String description;
  final String detailedDescription;
  final List<String> technologies;
  final String category;
  final List<String> features;
  final List<String> screenshots;
  final String? githubUrl;
  final String? liveUrl;
  final String? clientName;
  final String? duration;
  final String? teamSize;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.detailedDescription,
    required this.technologies,
    required this.category,
    required this.features,
    this.screenshots = const [],
    this.githubUrl,
    this.liveUrl,
    this.clientName,
    this.duration,
    this.teamSize,
  });
}
