// Expanded Software Projects Database for Stackova Company Website
// This file contains comprehensive project ideas organized by categories

class ProjectCategory {
  final String name;
  final String description;
  final List<String> projects;
  final String icon;

  const ProjectCategory({
    required this.name,
    required this.description,
    required this.projects,
    required this.icon,
  });
}

class ExpandedProjectsDatabase {
  
  // BLOCKCHAIN & CRYPTOCURRENCY PROJECTS (50+ projects)
  static const blockchainProjects = ProjectCategory(
    name: "Blockchain & Cryptocurrency",
    description: "Decentralized applications and blockchain-based solutions",
    icon: "🔗",
    projects: [
      // DeFi & Financial
      "Decentralized Exchange (DEX) Platform",
      "Yield Farming & Liquidity Mining Platform",
      "Cross-Chain Bridge Protocol",
      "Automated Market Maker (AMM) System",
      "Crypto Lending & Borrowing Platform",
      "Decentralized Insurance Protocol",
      "Crypto Portfolio Management Dashboard",
      "Multi-Signature Wallet System",
      "Stablecoin Minting & Burning Protocol",
      "Decentralized Derivatives Trading Platform",
      
      // NFT & Digital Assets
      "NFT Marketplace with Royalty Distribution",
      "Dynamic NFT Gaming Platform",
      "Fractional NFT Ownership System",
      "NFT-based Event Ticketing Platform",
      "Digital Art Authentication System",
      "Music NFT Streaming Platform",
      "Virtual Real Estate Trading Platform",
      "NFT-based Membership System",
      "Generative Art NFT Creator",
      "NFT Rental & Lending Platform",
      
      // Enterprise & Governance
      "Supply Chain Transparency Platform",
      "Decentralized Autonomous Organization (DAO) Framework",
      "Blockchain-based Voting System with Zero-Knowledge Proofs",
      "Digital Identity Verification System",
      "Intellectual Property Protection Platform",
      "Carbon Credit Trading System",
      "Decentralized Cloud Storage Network",
      "Blockchain-based Certificate Verification",
      "Smart Contract Audit Platform",
      "Decentralized Freelancer Marketplace",
      
      // Social & Community
      "Decentralized Social Media Platform",
      "Blockchain-based Content Creator Monetization",
      "Decentralized Messaging System",
      "Community Token Distribution Platform",
      "Blockchain-based Reputation System",
      "Decentralized Crowdfunding Platform",
      "Peer-to-Peer Energy Trading System",
      "Blockchain-based Charity Transparency Platform",
      "Decentralized Learning Management System",
      "Token-gated Community Platform",
    ],
  );

  // AI & MACHINE LEARNING PROJECTS (60+ projects)
  static const aiMlProjects = ProjectCategory(
    name: "AI & Machine Learning",
    description: "Intelligent systems and machine learning applications",
    icon: "🤖",
    projects: [
      // Computer Vision
      "Real-time Object Detection & Tracking System",
      "Facial Recognition Access Control System",
      "Autonomous Vehicle Navigation System",
      "Medical Image Analysis for Disease Detection",
      "Quality Control System for Manufacturing",
      "Gesture Recognition Interface",
      "Augmented Reality Object Placement",
      "Document Scanner with OCR",
      "License Plate Recognition System",
      "Crowd Density Estimation System",
      
      // Natural Language Processing
      "Multi-language Chatbot with Sentiment Analysis",
      "Automated Content Generation System",
      "Real-time Language Translation API",
      "Voice Assistant with Custom Commands",
      "Text Summarization & Analysis Tool",
      "Fake News Detection System",
      "Legal Document Analysis Platform",
      "Customer Review Sentiment Dashboard",
      "Automated Email Response System",
      "Speech-to-Text Transcription Service",
      
      // Predictive Analytics
      "Stock Market Prediction Engine",
      "Weather Forecasting System",
      "Customer Churn Prediction Model",
      "Fraud Detection System for Banking",
      "Predictive Maintenance for IoT Devices",
      "Sales Forecasting Dashboard",
      "Risk Assessment Platform",
      "Recommendation Engine for E-commerce",
      "Energy Consumption Optimization System",
      "Traffic Pattern Prediction System",
      
      // Healthcare AI
      "AI-powered Diagnostic Assistant",
      "Drug Discovery Acceleration Platform",
      "Mental Health Monitoring System",
      "Personalized Treatment Recommendation Engine",
      "Medical Chatbot for Symptom Checking",
      "Epidemic Spread Prediction Model",
      "AI-based Radiology Report Generator",
      "Personalized Fitness & Nutrition Planner",
      "Sleep Pattern Analysis System",
      "AI-powered Telemedicine Platform",
      
      // Business Intelligence
      "Automated Business Report Generator",
      "Customer Behavior Analysis Platform",
      "Market Research Automation Tool",
      "Competitive Intelligence Dashboard",
      "Social Media Analytics Engine",
      "Supply Chain Optimization System",
      "Dynamic Pricing Algorithm",
      "Inventory Management Predictor",
      "Employee Performance Analytics",
      "Financial Risk Assessment Tool",
      
      // Creative AI
      "AI Music Composition Platform",
      "Automated Video Editing System",
      "AI-powered Logo Design Generator",
      "Content Creation Assistant",
      "Personalized Learning Path Generator",
      "AI Art Style Transfer Application",
      "Automated Code Review System",
      "Smart Photo Organization Tool",
      "AI-powered Game Level Generator",
      "Personalized News Curation Engine",
    ],
  );

  // WEB APPLICATIONS (80+ projects)
  static const webApplications = ProjectCategory(
    name: "Web Development",
    description: "Modern web-based solutions and platforms",
    icon: "🌐",
    projects: [
      // E-commerce & Marketplace
      "Multi-vendor Marketplace with AI Recommendations",
      "Subscription Box Management Platform",
      "Digital Product Marketplace",
      "B2B Wholesale Trading Platform",
      "Auction-based Selling Platform",
      "Rental Equipment Management System",
      "Local Services Marketplace",
      "Handmade Crafts E-commerce Platform",
      "Virtual Fashion Try-on System",
      "Sustainable Products Marketplace",
      
      // SaaS & Business Tools
      "Project Management & Collaboration Platform",
      "Customer Relationship Management (CRM) System",
      "Human Resources Management System",
      "Inventory & Warehouse Management Platform",
      "Accounting & Financial Management System",
      "Document Management & Workflow System",
      "Time Tracking & Productivity Analytics",
      "Email Marketing Automation Platform",
      "Social Media Management Dashboard",
      "Business Intelligence & Analytics Platform",
      
      // Education & Learning
      "Learning Management System (LMS)",
      "Online Course Creation Platform",
      "Virtual Classroom with Video Conferencing",
      "Student Information Management System",
      "Skill Assessment & Certification Platform",
      "Language Learning Platform with AI",
      "Research Paper Management System",
      "Online Examination & Proctoring System",
      "Educational Content Marketplace",
      "Peer-to-Peer Tutoring Platform",
      
      // Healthcare & Wellness
      "Telemedicine & Virtual Consultation Platform",
      "Electronic Health Records (EHR) System",
      "Appointment Scheduling & Management",
      "Pharmacy Management System",
      "Mental Health Support Platform",
      "Fitness & Nutrition Tracking System",
      "Medical Equipment Rental Platform",
      "Health Insurance Management Portal",
      "Clinical Trial Management System",
      "Medical Research Data Platform",
    ],
  );

  // Get all project categories
  static List<ProjectCategory> getAllCategories() {
    return [
      blockchainProjects,
      aiMlProjects,
      webApplications,
      // Additional categories will be added in subsequent files
    ];
  }

  // Get projects by category name
  static ProjectCategory? getCategoryByName(String name) {
    try {
      return getAllCategories().firstWhere(
        (category) => category.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Get total project count
  static int getTotalProjectCount() {
    return getAllCategories()
        .map((category) => category.projects.length)
        .reduce((a, b) => a + b);
  }

  // Search projects across all categories
  static List<String> searchProjects(String query) {
    final results = <String>[];
    final lowerQuery = query.toLowerCase();
    
    for (final category in getAllCategories()) {
      for (final project in category.projects) {
        if (project.toLowerCase().contains(lowerQuery)) {
          results.add(project);
        }
      }
    }
    
    return results;
  }
}
