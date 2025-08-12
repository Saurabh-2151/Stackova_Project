import '../models/project.dart';
import 'comprehensive_projects_database.dart';
import 'expanded_projects_database.dart';

// Category content data structure for text descriptions
class CategoryContent {
  final String categoryId;
  final String title;
  final String content;
  final String icon;

  const CategoryContent({
    required this.categoryId,
    required this.title,
    required this.content,
    required this.icon,
  });
}

class ProjectsData {
  // Cache for improved performance
  static List<Project>? _cachedAllProjects;
  static List<Project>? _cachedExpandedProjects;
  static Map<String, List<Project>>? _cachedProjectsByCategory;

  // Category content descriptions
  static const Map<String, CategoryContent> categoryContents = {
    'android': CategoryContent(
      categoryId: 'android',
      title: 'Android Projects & App Ideas',
      content: '''Android Projects & App Ideas

Importance of Android Projects & Android App Ideas in 2025

Over 72% of smartphones on the earth work on Android OS. Additionally android OS allows companies /institutes /organizations to develop customized android apps to interact with their customers/students/followers 24/7 through android apps. A wide variety of successful online business ideas can be developed using android apps. Stackova compiles the best android projects for students and app ideas to start your online business.''',
      icon: '📱',
    ),
    'web': CategoryContent(
      categoryId: 'web',
      title: 'Web Based Project Ideas & Topics',
      content: '''Web Based Project Ideas & Topics

Get latest web based project ideas and topics for your research and studies using HTML5 CSS Javascript Bootstrap and more technologies. We have the widest list of innovative web based projects. Web based searching to web based project ideas for your research. Get web mining as well as web connectivity based projects with guidance only at Stackova. Top web based projects using HTML 5 Css, Javascript, Bootstrap.''',
      icon: '🌐',
    ),
    'ios': CategoryContent(
      categoryId: 'ios',
      title: 'iOS Projects',
      content: '''iOS Projects

Stackova provides a variety of iOS projects with source code using Swift for students, researchers and engineers. Get Swift iOS projects with codes for study and research as well as commercial use. We specialize in a variety of iOS projects from basic apps to webservice based systems for iOS. Also we provide advanced iOS development services on Swift for developing iOS projects and system as per client requirements. Our iOS based projects list is refreshed every month be updated with latest iOS development technologies.''',
      icon: '🍎',
    ),
    'ai': CategoryContent(
      categoryId: 'ai',
      title: 'Artificial Intelligence Projects',
      content: '''Artificial Intelligence Projects

Get latest list of artificial intelligence projects for your studies and research at Stackova. We provide the widest and most innovative artificial intelligence projects for students. These projects on artificial intelligence have been developed to help engineers, researchers and students in their research and studies in AI based systems. Browse through our list of latest artificial intelligence project ideas and choose the topic that suits you best. These systems have been proposed to help humankind in various walks of life using AI based systems. Go through our artificial intelligence project ideas and topics to find the AI project for your needs.''',
      icon: '🤖',
    ),
    'ml': CategoryContent(
      categoryId: 'ml',
      title: 'Machine Learning & Deep Learning',
      content: '''Machine Learning & Deep Learning

What is Machine Learning and Deep Learning?
Machine Learning is a core component of Artificial Intelligence that includes how machines can analyze data, identify patterns and make decisions with low to no human intervention.

Deep Learning also known as neural learning or deep neural learning is a part of Machine Learning that uses networks for learning from unorganized or unlabelled datasets.

Need for Machine Learning ?

With the ever-increasing demand for machine automated solutions ML has become one of the rapidly evolving technology along with AI & Data Science. Find the Latest Machine Learning projects based on ML algorithms for open source machine learning.''',
      icon: '🧠',
    ),
    'blockchain': CategoryContent(
      categoryId: 'blockchain',
      title: 'Blockchain Projects & Development Solutions',
      content: '''Blockchain Projects & Development Solutions

Blockchain Technology makes use of blocks with cryptography to ensure a secure and reliable system. Blockchain Technology is rapidly finding use in government, Healthcare, Industrial, Banking sectors. Get Latest Blockchain projects for Supply Chain, Healthcare, Banking & Government Sectors with customized development solutions.''',
      icon: '🔗',
    ),
    'arvr': CategoryContent(
      categoryId: 'arvr',
      title: 'AR VR Projects & Customized Development',
      content: '''AR VR Projects & Customized Development

Find latest Augment reality and virtual reality projects topics and Ideas for Customized Game, Product Promotion, Industrial Simulation at Stackova along with customized AR VR Development solutions.''',
      icon: '🥽',
    ),
    'cloud': CategoryContent(
      categoryId: 'cloud',
      title: 'Cloud Computing & DevOps Solutions',
      content: '''Cloud Computing & DevOps Solutions

Cloud computing has revolutionized how businesses operate by providing scalable, flexible, and cost-effective infrastructure solutions. Stackova offers comprehensive cloud computing and DevOps projects that help organizations migrate to the cloud, automate their development processes, and achieve continuous integration and deployment. Our cloud solutions include multi-cloud management, containerization, microservices architecture, and infrastructure as code implementations.''',
      icon: '☁️',
    ),
    'fintech': CategoryContent(
      categoryId: 'fintech',
      title: 'FinTech & Digital Banking Solutions',
      content: '''FinTech & Digital Banking Solutions

The financial technology sector is experiencing unprecedented growth with digital transformation reshaping traditional banking and financial services. Stackova provides cutting-edge FinTech solutions including digital banking platforms, payment gateways, cryptocurrency exchanges, robo-advisors, and regulatory compliance systems. Our FinTech projects leverage blockchain, AI, and advanced security measures to create secure, scalable, and user-friendly financial applications.''',
      icon: '💳',
    ),
    'edtech': CategoryContent(
      categoryId: 'edtech',
      title: 'EdTech & E-Learning Platforms',
      content: '''EdTech & E-Learning Platforms

Educational technology is transforming how we learn and teach in the digital age. Stackova develops innovative EdTech solutions including learning management systems, virtual classrooms, adaptive learning platforms, and educational mobile applications. Our e-learning projects incorporate AI-powered personalization, gamification, virtual reality, and collaborative learning tools to enhance educational outcomes and accessibility.''',
      icon: '🎓',
    ),
    'healthtech': CategoryContent(
      categoryId: 'healthtech',
      title: 'HealthTech & Medical Innovation',
      content: '''HealthTech & Medical Innovation

Healthcare technology is revolutionizing patient care and medical research through digital innovation. Stackova specializes in developing HealthTech solutions including telemedicine platforms, electronic health records, medical imaging analysis, wearable health monitoring, and AI-powered diagnostic tools. Our healthcare projects prioritize patient privacy, regulatory compliance, and interoperability to improve healthcare delivery and outcomes.''',
      icon: '🏥',
    ),
    'iot': CategoryContent(
      categoryId: 'iot',
      title: 'IoT & Smart Systems Development',
      content: '''IoT & Smart Systems Development

The Internet of Things (IoT) is connecting billions of devices worldwide, creating smart ecosystems that improve efficiency and quality of life. Stackova develops comprehensive IoT solutions including smart home automation, industrial IoT systems, environmental monitoring, and connected vehicle platforms. Our IoT projects integrate sensors, edge computing, cloud connectivity, and data analytics to create intelligent, responsive systems.''',
      icon: '🌐',
    ),
  };

  static List<Project> getAllProjects() {
    // Return cached projects if available
    if (_cachedAllProjects != null) {
      return _cachedAllProjects!;
    }

    // Build and cache the projects list
    _cachedAllProjects = [
      // Web App Projects
      const Project(
        id: 'ambulance-booking',
        title: 'Ambulance Booking System using Python',
        description: 'Emergency medical service booking platform',
        detailedDescription:
            'A comprehensive ambulance booking system designed to provide quick and efficient emergency medical services. The platform connects patients with nearby ambulances, tracks real-time locations, and manages emergency medical requests with priority-based dispatching.',
        technologies: ['Python', 'Django', 'PostgreSQL'],
        category: 'Web App',
        features: [
          'Real-time ambulance tracking',
          'Emergency request prioritization',
          'GPS-based nearest ambulance finder',
          'Patient medical history integration',
          'Driver and vehicle management',
          'Payment gateway integration',
          'SMS and email notifications',
          'Admin dashboard for monitoring',
        ],
        screenshots: [
          'assets/projects/ambulance/dashboard.png',
          'assets/projects/ambulance/booking.png',
          'assets/projects/ambulance/tracking.png',
        ],
        duration: '3 months',
        teamSize: '4 developers',
        clientName: 'HealthCare Solutions Inc.',
      ),

      const Project(
        id: 'chatbot-assistant',
        title: 'Chatbot Assistant System using Python',
        description: 'AI-powered customer service chatbot',
        detailedDescription:
            'An intelligent chatbot system powered by natural language processing to provide automated customer support. Features include intent recognition, context-aware responses, and seamless handoff to human agents when needed.',
        technologies: ['Python', 'NLP', 'Flask'],
        category: 'Web App',
        features: [
          'Natural language understanding',
          'Intent recognition and classification',
          'Context-aware conversations',
          'Multi-language support',
          'Integration with CRM systems',
          'Analytics and reporting',
          'Human agent handoff',
          'Custom training interface',
        ],
        screenshots: [
          'assets/projects/chatbot/interface.png',
          'assets/projects/chatbot/analytics.png',
          'assets/projects/chatbot/training.png',
        ],
        duration: '4 months',
        teamSize: '3 developers',
        githubUrl: 'https://github.com/stackova/chatbot-system',
      ),

      const Project(
        id: 'vaccination-management',
        title: 'Child Vaccination Management System using Python',
        description: 'Healthcare management for child immunization',
        detailedDescription:
            'A comprehensive vaccination management system designed to track and manage child immunization schedules. The system helps healthcare providers maintain vaccination records, send reminders, and ensure children receive timely immunizations.',
        technologies: ['Python', 'Django', 'MySQL'],
        category: 'Web App',
        features: [
          'Vaccination schedule tracking',
          'Automated reminder system',
          'Digital vaccination certificates',
          'Parent portal access',
          'Healthcare provider dashboard',
          'Inventory management for vaccines',
          'Reporting and analytics',
          'Mobile-responsive design',
        ],
        screenshots: [
          'assets/projects/vaccination/schedule.png',
          'assets/projects/vaccination/certificate.png',
          'assets/projects/vaccination/dashboard.png',
        ],
        duration: '5 months',
        teamSize: '5 developers',
        clientName: 'Ministry of Health',
      ),

      const Project(
        id: 'complaint-registration',
        title: 'Online Complaint Registration & Management System using Python',
        description: 'Digital complaint handling and tracking system',
        detailedDescription:
            'A digital platform for citizens to register complaints and track their resolution status. The system provides transparency in government services and enables efficient complaint management with automated workflows.',
        technologies: ['Python', 'Flask', 'SQLite'],
        category: 'Web App',
        features: [
          'Online complaint submission',
          'Real-time status tracking',
          'Automated workflow management',
          'Department-wise routing',
          'Priority-based categorization',
          'Email and SMS notifications',
          'Analytics dashboard',
          'Public complaint portal',
        ],
        screenshots: [
          'assets/projects/complaint/submission.png',
          'assets/projects/complaint/tracking.png',
          'assets/projects/complaint/admin.png',
        ],
        duration: '3 months',
        teamSize: '3 developers',
        clientName: 'City Municipal Corporation',
      ),

      // Android App Projects
      const Project(
        id: 'organ-donation',
        title: 'Organ Donation System using Python',
        description: 'Life-saving organ matching and donation platform',
        detailedDescription:
            'A critical healthcare application that connects organ donors with recipients. The system manages donor registrations, recipient matching based on medical compatibility, and coordinates with hospitals for organ transplantation procedures.',
        technologies: ['Python', 'Django', 'PostgreSQL'],
        category: 'Android App',
        features: [
          'Donor registration and verification',
          'Medical compatibility matching',
          'Emergency notification system',
          'Hospital coordination interface',
          'Organ availability tracking',
          'Medical history management',
          'Secure data encryption',
          'Real-time communication',
        ],
        screenshots: [
          'assets/projects/organ/registration.png',
          'assets/projects/organ/matching.png',
          'assets/projects/organ/emergency.png',
        ],
        duration: '6 months',
        teamSize: '6 developers',
        clientName: 'National Organ Donation Network',
      ),

      const Project(
        id: 'student-feedback',
        title: 'Student Feedback Review System using Python',
        description: 'Educational feedback collection and analysis',
        detailedDescription:
            'A comprehensive feedback system for educational institutions to collect, analyze, and act upon student feedback. The system provides insights into teaching quality, course effectiveness, and overall student satisfaction.',
        technologies: ['Python', 'Django', 'Pandas'],
        category: 'Android App',
        features: [
          'Anonymous feedback collection',
          'Multi-criteria evaluation',
          'Real-time analytics',
          'Sentiment analysis',
          'Automated report generation',
          'Faculty performance tracking',
          'Course improvement suggestions',
          'Mobile-friendly interface',
        ],
        screenshots: [
          'assets/projects/feedback/collection.png',
          'assets/projects/feedback/analytics.png',
          'assets/projects/feedback/reports.png',
        ],
        duration: '4 months',
        teamSize: '4 developers',
        clientName: 'University Education Board',
      ),

      const Project(
        id: 'real-estate-booking',
        title: 'Real Estate Booking System using Smart Contracts',
        description: 'Blockchain-based property transaction system',
        detailedDescription:
            'A revolutionary real estate platform that uses blockchain technology and smart contracts to facilitate transparent, secure, and efficient property transactions. The system eliminates intermediaries and provides a trustless environment for buyers and sellers.',
        technologies: ['Solidity', 'Web3.js', 'Ethereum'],
        category: 'Android App',
        features: [
          'Smart contract automation',
          'Property tokenization',
          'Escrow management',
          'Digital property certificates',
          'Transparent transaction history',
          'Multi-signature wallets',
          'Automated compliance checks',
          'Decentralized property listings',
        ],
        screenshots: [
          'assets/projects/realestate/listings.png',
          'assets/projects/realestate/contracts.png',
          'assets/projects/realestate/wallet.png',
        ],
        duration: '8 months',
        teamSize: '7 developers',
        githubUrl: 'https://github.com/stackova/realestate-blockchain',
      ),

      const Project(
        id: 'crowdfunding-platform',
        title: 'Trusted Crowdfunding Platform Using a Smart Contract',
        description: 'Decentralized fundraising platform',
        detailedDescription:
            'A blockchain-powered crowdfunding platform that ensures transparency and trust in fundraising campaigns. Using smart contracts, the platform automatically manages fund distribution, milestone tracking, and contributor rewards.',
        technologies: ['Solidity', 'Web3.js', 'IPFS'],
        category: 'Android App',
        features: [
          'Smart contract-based campaigns',
          'Milestone-based fund release',
          'Contributor voting system',
          'Transparent fund tracking',
          'Automated refund mechanisms',
          'Campaign verification',
          'Token-based rewards',
          'Decentralized governance',
        ],
        screenshots: [
          'assets/projects/crowdfunding/campaigns.png',
          'assets/projects/crowdfunding/voting.png',
          'assets/projects/crowdfunding/dashboard.png',
        ],
        duration: '7 months',
        teamSize: '5 developers',
        liveUrl: 'https://crowdfund.stackova.com',
      ),

      // iOS App Projects
      const Project(
        id: 'fitness-tracker-ios',
        title: 'Fitness Tracker iOS App',
        description: 'Comprehensive health and fitness monitoring',
        detailedDescription:
            'A native iOS application that helps users track their fitness goals, monitor health metrics, and maintain an active lifestyle. The app integrates with Apple HealthKit and provides personalized workout recommendations.',
        technologies: ['Swift', 'HealthKit', 'Core Data'],
        category: 'iOS App',
        features: [
          'HealthKit integration',
          'Workout tracking',
          'Nutrition monitoring',
          'Goal setting and progress',
          'Social challenges',
          'Apple Watch compatibility',
          'Personalized recommendations',
          'Health data analytics',
        ],
        screenshots: [
          'assets/projects/fitness/dashboard.png',
          'assets/projects/fitness/workouts.png',
          'assets/projects/fitness/progress.png',
        ],
        duration: '5 months',
        teamSize: '4 developers',
        clientName: 'FitLife Solutions',
      ),

      const Project(
        id: 'expense-manager-ios',
        title: 'Personal Expense Manager iOS',
        description: 'Smart financial management and budgeting',
        detailedDescription:
            'An intelligent expense tracking application that helps users manage their finances, create budgets, and achieve financial goals. The app uses machine learning to categorize expenses and provide spending insights.',
        technologies: ['Swift', 'Core ML', 'CloudKit'],
        category: 'iOS App',
        features: [
          'Automatic expense categorization',
          'Budget planning and tracking',
          'Bill reminders',
          'Financial goal setting',
          'Spending analytics',
          'Receipt scanning',
          'Multi-currency support',
          'Cloud synchronization',
        ],
        screenshots: [
          'assets/projects/expense/overview.png',
          'assets/projects/expense/budgets.png',
          'assets/projects/expense/analytics.png',
        ],
        duration: '4 months',
        teamSize: '3 developers',
        githubUrl: 'https://github.com/stackova/expense-manager-ios',
      ),
    ];

    return _cachedAllProjects!;
  }

  static List<Project> getProjectsByCategory(String category) {
    // Initialize cache if needed
    _cachedProjectsByCategory ??= <String, List<Project>>{};

    // Return cached result if available
    if (_cachedProjectsByCategory!.containsKey(category)) {
      return _cachedProjectsByCategory![category]!;
    }

    // Calculate and cache the result
    final result = getAllProjects()
        .where((project) => project.category == category)
        .toList();
    _cachedProjectsByCategory![category] = result;

    return result;
  }

  static Project? getProjectById(String id) {
    try {
      return getAllProjects().firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<String> getAllCategories() {
    return ['All Software Projects', 'Web App', 'Android App', 'iOS App'];
  }

  // Get category content by category ID
  static CategoryContent? getCategoryContent(String categoryId) {
    return categoryContents[categoryId];
  }

  // Get category content by project type
  static CategoryContent? getCategoryContentByType(String projectType) {
    switch (projectType.toLowerCase()) {
      case 'web':
      case 'web app':
        return categoryContents['web'];
      case 'android':
      case 'android app':
        return categoryContents['android'];
      case 'ios':
      case 'ios app':
        return categoryContents['ios'];
      case 'ai':
      case 'artificial intelligence':
        return categoryContents['ai'];
      case 'ml':
      case 'machine learning':
        return categoryContents['ml'];
      case 'blockchain':
        return categoryContents['blockchain'];
      case 'arvr':
      case 'ar':
      case 'vr':
        return categoryContents['arvr'];
      case 'cloud':
        return categoryContents['cloud'];
      case 'fintech':
        return categoryContents['fintech'];
      case 'edtech':
        return categoryContents['edtech'];
      case 'healthtech':
        return categoryContents['healthtech'];
      case 'iot':
        return categoryContents['iot'];
      default:
        return null;
    }
  }

  // Get comprehensive project database
  static List<ProjectCategory> getComprehensiveCategories() {
    return ComprehensiveProjectsDatabase.getAllProjectCategories();
  }

  // Generate Project objects from comprehensive database
  static List<Project> getExpandedProjects() {
    // Return cached expanded projects if available
    if (_cachedExpandedProjects != null) {
      return _cachedExpandedProjects!;
    }

    final expandedProjects = <Project>[];
    final categories = ComprehensiveProjectsDatabase.getAllProjectCategories();

    for (final category in categories) {
      for (int i = 0; i < category.projects.length; i++) {
        final projectTitle = category.projects[i];
        final projectId = projectTitle
            .toLowerCase()
            .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
            .replaceAll(' ', '-');

        // Map category names to existing categories
        String mappedCategory;
        if (category.name.contains('Web') || category.name.contains('SaaS')) {
          mappedCategory = 'Web App';
        } else if (category.name.contains('Android')) {
          mappedCategory = 'Android App';
        } else if (category.name.contains('iOS')) {
          mappedCategory = 'iOS App';
        } else {
          mappedCategory = 'Web App'; // Default to Web App for other categories
        }

        // Generate technologies based on category
        List<String> technologies = _getTechnologiesForCategory(category.name);

        // Generate features based on project title
        List<String> features = _generateFeaturesForProject(projectTitle);

        expandedProjects.add(
          Project(
            id: projectId,
            title: projectTitle,
            description: _generateDescription(projectTitle, category.name),
            detailedDescription: _generateDetailedDescription(
              projectTitle,
              category.description,
            ),
            technologies: technologies,
            category: mappedCategory,
            features: features,
            screenshots: _generateScreenshots(projectId),
            duration: _estimateDuration(category.name),
            teamSize: _estimateTeamSize(category.name),
            clientName: 'Enterprise Client',
          ),
        );
      }
    }

    // Cache the result
    _cachedExpandedProjects = expandedProjects;
    return _cachedExpandedProjects!;
  }

  // Get all projects including original and expanded
  static List<Project> getAllProjectsExpanded() {
    final originalProjects = getAllProjects();
    final expandedProjects = getExpandedProjects();
    return [...originalProjects, ...expandedProjects];
  }

  // Helper method to get technologies for category
  static List<String> _getTechnologiesForCategory(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'blockchain & cryptocurrency':
        return ['Solidity', 'Web3.js', 'React', 'Node.js'];
      case 'ai & machine learning':
        return ['Python', 'TensorFlow', 'PyTorch', 'FastAPI'];
      case 'web Development':
        return ['React', 'Node.js', 'MongoDB', 'Express'];
      case 'android applications':
        return ['Kotlin', 'Android SDK', 'Firebase', 'Retrofit'];
      case 'ios applications':
        return ['Swift', 'SwiftUI', 'Core Data', 'CloudKit'];
      case 'ar & vr applications':
        return ['Unity', 'ARKit', 'ARCore', 'C#'];
      case 'data science & analytics':
        return ['Python', 'Pandas', 'Matplotlib', 'Jupyter'];
      case 'iot & embedded systems':
        return ['Arduino', 'Raspberry Pi', 'C++', 'MQTT'];
      case 'cybersecurity & information security':
        return ['Python', 'Kali Linux', 'Wireshark', 'OpenSSL'];
      case 'cloud & devops':
        return ['AWS', 'Docker', 'Kubernetes', 'Terraform'];
      case 'fintech & digital banking':
        return ['React', 'Node.js', 'PostgreSQL', 'Stripe API'];
      case 'edtech & e-learning':
        return ['React', 'Node.js', 'MongoDB', 'WebRTC'];
      case 'healthtech & medical':
        return ['React', 'Node.js', 'FHIR', 'HL7'];
      default:
        return ['React', 'Node.js', 'MongoDB', 'Express'];
    }
  }

  // Helper method to generate description
  static String _generateDescription(String title, String category) {
    return 'Advanced $category solution: $title with modern architecture and scalable design.';
  }

  // Helper method to generate detailed description
  static String _generateDetailedDescription(
    String title,
    String categoryDescription,
  ) {
    return 'A comprehensive $title system built with cutting-edge technology. $categoryDescription This solution provides enterprise-grade functionality with modern user experience and robust security features.';
  }

  // Helper method to generate features
  static List<String> _generateFeaturesForProject(String title) {
    final baseFeatures = [
      'Modern responsive design',
      'Real-time data synchronization',
      'Advanced security features',
      'Scalable architecture',
      'User-friendly interface',
      'Analytics and reporting',
      'Mobile-responsive design',
      'Cloud integration',
    ];

    // Add specific features based on project type
    if (title.toLowerCase().contains('ai') ||
        title.toLowerCase().contains('machine learning')) {
      baseFeatures.addAll([
        'AI-powered insights',
        'Machine learning algorithms',
        'Predictive analytics',
      ]);
    }
    if (title.toLowerCase().contains('blockchain')) {
      baseFeatures.addAll([
        'Smart contracts',
        'Decentralized architecture',
        'Cryptocurrency integration',
      ]);
    }
    if (title.toLowerCase().contains('mobile') ||
        title.toLowerCase().contains('app')) {
      baseFeatures.addAll([
        'Push notifications',
        'Offline functionality',
        'Biometric authentication',
      ]);
    }

    return baseFeatures.take(8).toList();
  }

  // Helper method to generate screenshots
  static List<String> _generateScreenshots(String projectId) {
    return [
      'assets/projects/$projectId/dashboard.png',
      'assets/projects/$projectId/features.png',
      'assets/projects/$projectId/mobile.png',
    ];
  }

  // Helper method to estimate duration
  static String _estimateDuration(String category) {
    switch (category.toLowerCase()) {
      case 'blockchain & cryptocurrency':
      case 'ai & machine learning':
        return '4-6 months';
      case 'ar & vr applications':
      case 'iot & embedded systems':
        return '3-5 months';
      case 'cybersecurity & information security':
        return '2-4 months';
      default:
        return '2-3 months';
    }
  }

  // Helper method to estimate team size
  static String _estimateTeamSize(String category) {
    switch (category.toLowerCase()) {
      case 'blockchain & cryptocurrency':
      case 'ai & machine learning':
        return '5-7 developers';
      case 'ar & vr applications':
      case 'iot & embedded systems':
        return '4-6 developers';
      default:
        return '3-5 developers';
    }
  }

  // Clear cache for memory management
  static void clearCache() {
    _cachedAllProjects = null;
    _cachedExpandedProjects = null;
    _cachedProjectsByCategory = null;
  }
}
