class Service {
  final String id;
  final String title;
  final String description;
  final String icon;
  final List<String> features;

  const Service({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.features,
  });
}

class ServiceData {
  static const List<Service> services = [
    Service(
      id: 'web-development',
      title: 'Web Development',
      description: 'Custom web applications built with modern technologies and responsive design.',
      icon: 'web',
      features: [
        'Responsive Design',
        'Modern Frameworks',
        'SEO Optimized',
        'Fast Performance',
      ],
    ),
    Service(
      id: 'mobile-development',
      title: 'Mobile Development',
      description: 'Native and cross-platform mobile apps for iOS and Android.',
      icon: 'mobile',
      features: [
        'Native Performance',
        'Cross-Platform',
        'App Store Ready',
        'Push Notifications',
      ],
    ),
    Service(
      id: 'custom-software',
      title: 'Custom Software',
      description: 'Tailored software solutions to meet your specific business needs.',
      icon: 'software',
      features: [
        'Custom Solutions',
        'Scalable Architecture',
        'Integration Ready',
        'Maintenance Support',
      ],
    ),
  ];
}
