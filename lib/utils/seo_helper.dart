import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

class SEOHelper {
  // Generate meta tags for web
  static Map<String, String> generateMetaTags({
    String? title,
    String? description,
    String? keywords,
    String? author,
    String? ogImage,
    String? canonicalUrl,
  }) {
    final metaTags = <String, String>{};

    // Basic meta tags
    metaTags['title'] = title ?? '${AppConfig.companyName} - ${AppConfig.companyTagline}';
    metaTags['description'] = description ?? AppConfig.companyDescription;
    metaTags['keywords'] = keywords ?? _getDefaultKeywords();
    metaTags['author'] = author ?? AppConfig.companyName;
    metaTags['viewport'] = 'width=device-width, initial-scale=1.0';
    metaTags['charset'] = 'UTF-8';

    // Open Graph tags
    metaTags['og:title'] = metaTags['title']!;
    metaTags['og:description'] = metaTags['description']!;
    metaTags['og:type'] = 'website';
    metaTags['og:site_name'] = AppConfig.companyName;
    if (ogImage != null) {
      metaTags['og:image'] = ogImage;
    }

    // Twitter Card tags
    metaTags['twitter:card'] = 'summary_large_image';
    metaTags['twitter:title'] = metaTags['title']!;
    metaTags['twitter:description'] = metaTags['description']!;
    if (ogImage != null) {
      metaTags['twitter:image'] = ogImage;
    }

    // Additional SEO tags
    metaTags['robots'] = 'index, follow';
    metaTags['language'] = 'en';
    metaTags['revisit-after'] = '7 days';
    
    if (canonicalUrl != null) {
      metaTags['canonical'] = canonicalUrl;
    }

    return metaTags;
  }

  // Generate structured data (JSON-LD)
  static Map<String, dynamic> generateOrganizationStructuredData() {
    return {
      '@context': 'https://schema.org',
      '@type': 'Organization',
      'name': AppConfig.companyName,
      'description': AppConfig.companyDescription,
      'url': 'https://stackova.com', // Replace with actual URL
      'logo': 'https://stackova.com/logo.png', // Replace with actual logo URL
      'contactPoint': {
        '@type': 'ContactPoint',
        'telephone': AppConfig.phone,
        'contactType': 'customer service',
        'email': AppConfig.email,
      },
      'address': {
        '@type': 'PostalAddress',
        'streetAddress': AppConfig.address,
      },
      'sameAs': [
        AppConfig.linkedinUrl,
        AppConfig.twitterUrl,
        AppConfig.githubUrl,
        AppConfig.instagramUrl,
      ],
    };
  }

  // Generate service structured data
  static Map<String, dynamic> generateServiceStructuredData({
    required String serviceName,
    required String description,
    String? serviceType,
  }) {
    return {
      '@context': 'https://schema.org',
      '@type': 'Service',
      'name': serviceName,
      'description': description,
      'serviceType': serviceType ?? 'Software Development',
      'provider': {
        '@type': 'Organization',
        'name': AppConfig.companyName,
      },
    };
  }

  // Generate project/portfolio structured data
  static Map<String, dynamic> generateCreativeWorkStructuredData({
    required String projectName,
    required String description,
    required List<String> technologies,
    String? projectUrl,
    String? imageUrl,
  }) {
    return {
      '@context': 'https://schema.org',
      '@type': 'CreativeWork',
      'name': projectName,
      'description': description,
      'creator': {
        '@type': 'Organization',
        'name': AppConfig.companyName,
      },
      'keywords': technologies.join(', '),
      if (projectUrl != null) 'url': projectUrl,
      if (imageUrl != null) 'image': imageUrl,
    };
  }

  // Generate FAQ structured data
  static Map<String, dynamic> generateFAQStructuredData(
    List<Map<String, String>> faqs,
  ) {
    return {
      '@context': 'https://schema.org',
      '@type': 'FAQPage',
      'mainEntity': faqs.map((faq) => {
        '@type': 'Question',
        'name': faq['question'],
        'acceptedAnswer': {
          '@type': 'Answer',
          'text': faq['answer'],
        },
      }).toList(),
    };
  }

  // Generate breadcrumb structured data
  static Map<String, dynamic> generateBreadcrumbStructuredData(
    List<Map<String, String>> breadcrumbs,
  ) {
    return {
      '@context': 'https://schema.org',
      '@type': 'BreadcrumbList',
      'itemListElement': breadcrumbs.asMap().entries.map((entry) {
        final index = entry.key;
        final breadcrumb = entry.value;
        return {
          '@type': 'ListItem',
          'position': index + 1,
          'name': breadcrumb['name'],
          'item': breadcrumb['url'],
        };
      }).toList(),
    };
  }

  // Get default keywords
  static String _getDefaultKeywords() {
    return [
      'web development',
      'mobile app development',
      'software development',
      'flutter development',
      'react development',
      'custom software solutions',
      'digital transformation',
      'technology consulting',
      AppConfig.companyName.toLowerCase(),
    ].join(', ');
  }

  // Generate sitemap data
  static List<Map<String, dynamic>> generateSitemapData() {
    return [
      {
        'url': '/',
        'priority': 1.0,
        'changefreq': 'weekly',
        'lastmod': DateTime.now().toIso8601String(),
      },
      {
        'url': '/services',
        'priority': 0.9,
        'changefreq': 'monthly',
        'lastmod': DateTime.now().toIso8601String(),
      },
      {
        'url': '/portfolio',
        'priority': 0.8,
        'changefreq': 'weekly',
        'lastmod': DateTime.now().toIso8601String(),
      },
      {
        'url': '/about',
        'priority': 0.7,
        'changefreq': 'monthly',
        'lastmod': DateTime.now().toIso8601String(),
      },
      {
        'url': '/contact',
        'priority': 0.6,
        'changefreq': 'monthly',
        'lastmod': DateTime.now().toIso8601String(),
      },
    ];
  }

  // Validate meta tags
  static Map<String, List<String>> validateMetaTags(Map<String, String> metaTags) {
    final issues = <String, List<String>>{};

    // Check title length
    final title = metaTags['title'];
    if (title != null) {
      if (title.length < 30) {
        issues.putIfAbsent('title', () => []).add('Title is too short (recommended: 30-60 characters)');
      } else if (title.length > 60) {
        issues.putIfAbsent('title', () => []).add('Title is too long (recommended: 30-60 characters)');
      }
    }

    // Check description length
    final description = metaTags['description'];
    if (description != null) {
      if (description.length < 120) {
        issues.putIfAbsent('description', () => []).add('Description is too short (recommended: 120-160 characters)');
      } else if (description.length > 160) {
        issues.putIfAbsent('description', () => []).add('Description is too long (recommended: 120-160 characters)');
      }
    }

    // Check for missing essential tags
    final essentialTags = ['title', 'description', 'keywords'];
    for (final tag in essentialTags) {
      if (!metaTags.containsKey(tag) || metaTags[tag]!.isEmpty) {
        issues.putIfAbsent('missing', () => []).add('Missing essential tag: $tag');
      }
    }

    return issues;
  }

  // Log SEO information for debugging
  static void logSEOInfo(Map<String, String> metaTags) {
    if (kDebugMode) {
      print('=== SEO Meta Tags ===');
      metaTags.forEach((key, value) {
        print('$key: $value');
      });
      
      final issues = validateMetaTags(metaTags);
      if (issues.isNotEmpty) {
        print('=== SEO Issues ===');
        issues.forEach((category, issueList) {
          print('$category:');
          for (final issue in issueList) {
            print('  - $issue');
          }
        });
      }
    }
  }

  // Generate robots.txt content
  static String generateRobotsTxt() {
    return '''
User-agent: *
Allow: /

# Sitemap
Sitemap: https://stackova.com/sitemap.xml

# Crawl-delay
Crawl-delay: 1
''';
  }

  // Generate manifest.json for PWA
  static Map<String, dynamic> generateWebManifest() {
    return {
      'name': '${AppConfig.companyName} - ${AppConfig.companyTagline}',
      'short_name': AppConfig.companyName,
      'description': AppConfig.companyDescription,
      'start_url': '/',
      'display': 'standalone',
      'background_color': '#ffffff',
      'theme_color': '#1E3A8A',
      'icons': [
        {
          'src': '/icons/icon-192x192.png',
          'sizes': '192x192',
          'type': 'image/png',
        },
        {
          'src': '/icons/icon-512x512.png',
          'sizes': '512x512',
          'type': 'image/png',
        },
      ],
    };
  }
}