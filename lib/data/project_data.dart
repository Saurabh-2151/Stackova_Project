class Project {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final List<String> technologies;
  final String? imageUrl;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.technologies,
    this.imageUrl,
  });
}

class ProjectCategory {
  final String id;
  final String name;

  const ProjectCategory({
    required this.id,
    required this.name,
  });
}

class ProjectData {
  static const List<ProjectCategory> categories = [
    ProjectCategory(id: 'web', name: 'Web App'),
    ProjectCategory(id: 'android', name: 'Android App'),
    ProjectCategory(id: 'ios', name: 'iOS App'),
    ProjectCategory(id: 'software', name: 'Custom Software'),
  ];

  static const List<Project> projects = [
    Project(
      id: 'ecommerce-web',
      title: 'E-commerce Platform',
      description: 'Modern e-commerce platform with advanced features',
      categoryId: 'web',
      technologies: ['React', 'Node.js', 'MongoDB'],
    ),
    Project(
      id: 'fitness-android',
      title: 'Fitness Tracker App',
      description: 'Android fitness tracking application',
      categoryId: 'android',
      technologies: ['Kotlin', 'Firebase', 'Material Design'],
    ),
    Project(
      id: 'banking-ios',
      title: 'Banking App',
      description: 'Secure iOS banking application',
      categoryId: 'ios',
      technologies: ['Swift', 'Core Data', 'TouchID'],
    ),
    Project(
      id: 'inventory-software',
      title: 'Inventory Management',
      description: 'Custom inventory management system',
      categoryId: 'software',
      technologies: ['Java', 'Spring Boot', 'PostgreSQL'],
    ),
  ];
}
