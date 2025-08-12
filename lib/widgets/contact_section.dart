import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../bloc/contact/contact_bloc.dart';
import '../bloc/contact/contact_event.dart';
import '../bloc/contact/contact_state.dart';
import '../config/app_config.dart';
import '../utils/validation_helper.dart';
import '../utils/analytics_helper.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Initialize the contact BLoC
    final contactBloc = context.read<ContactBloc>();
    contactBloc.add(const InitializeContact());
    contactBloc.initializeAnimationController(this);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3) {
      context.read<ContactBloc>().add(
        const ContactVisibilityChanged(true),
      );
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        // Track analytics
        AnalyticsHelper().trackContactFormSubmission(
          name: _nameController.text,
          email: _emailController.text,
          success: true,
        );

        // Handle form submission
        context.read<ContactBloc>().add(SubmitContactForm({
          'name': ValidationHelper.sanitizeInput(_nameController.text),
          'email': ValidationHelper.sanitizeEmail(_emailController.text),
          'message': ValidationHelper.sanitizeInput(_messageController.text),
        }));
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Thank you for your message! We\'ll get back to you soon.',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
        
        // Clear form
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
      } catch (e) {
        // Track error
        AnalyticsHelper().trackError('Contact form submission failed: $e');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to send message. Please try again.',
              style: GoogleFonts.inter(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).isMobile;
    final isTablet = ResponsiveBreakpoints.of(context).isTablet;

    return BlocBuilder<ContactBloc, ContactState>(
      builder: (context, state) {
        final contactBloc = context.read<ContactBloc>();
        final animationController = contactBloc.animationController;

        // Create animations
        final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animationController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
          ),
        );

        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animationController,
          curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
        ));

        return VisibilityDetector(
          key: const Key('contact-section'),
          onVisibilityChanged: _onVisibilityChanged,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : (isTablet ? 40 : 80),
              vertical: isMobile ? 60 : 100,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF8FAFC),
                  Color(0xFFE2E8F0),
                ],
              ),
            ),
            child: Column(
              children: [
                // Section Header
                AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: SlideTransition(
                        position: slideAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Get In Touch',
                              style: GoogleFonts.inter(
                                fontSize: isMobile ? 32 : (isTablet ? 40 : 48),
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF1E293B),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Container(
                              constraints: BoxConstraints(
                                maxWidth: isMobile ? double.infinity : 600,
                              ),
                              child: Text(
                                'Ready to start your next project? Let\'s discuss how we can help bring your ideas to life.',
                                style: GoogleFonts.inter(
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF64748B),
                                  height: 1.6,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 60),

                // Contact Content
                if (isMobile || isTablet) ...[
                  // Mobile/Tablet Layout
                  _buildContactInfo(isMobile, isTablet, animationController, fadeAnimation, slideAnimation),
                  const SizedBox(height: 40),
                  _buildContactForm(isMobile, isTablet, animationController, fadeAnimation, slideAnimation),
                ] else ...[
                  // Desktop Layout
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: _buildContactInfo(isMobile, isTablet, animationController, fadeAnimation, slideAnimation),
                      ),
                      const SizedBox(width: 60),
                      Expanded(
                        flex: 1,
                        child: _buildContactForm(isMobile, isTablet, animationController, fadeAnimation, slideAnimation),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactInfo(bool isMobile, bool isTablet, AnimationController animationController, Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Column(
              crossAxisAlignment: isMobile || isTablet 
                  ? CrossAxisAlignment.center 
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  'Let\'s Start a Conversation',
                  style: GoogleFonts.inter(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E293B),
                  ),
                  textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
                ),

                const SizedBox(height: 24),

                Text(
                  'We\'re here to help you transform your ideas into reality. Reach out to us and let\'s discuss your project.',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF64748B),
                    height: 1.6,
                  ),
                  textAlign: isMobile || isTablet ? TextAlign.center : TextAlign.left,
                ),

                const SizedBox(height: 32),

                // Contact Items
                _buildContactItem(
                  FontAwesomeIcons.envelope,
                  'Email',
                  AppConfig.email,
                  isMobile || isTablet,
                ),
                const SizedBox(height: 20),
                _buildContactItem(
                  FontAwesomeIcons.phone,
                  'Phone',
                  AppConfig.phone,
                  isMobile || isTablet,
                ),
                const SizedBox(height: 20),
                _buildContactItem(
                  FontAwesomeIcons.locationDot,
                  'Address',
                  AppConfig.address,
                  isMobile || isTablet,
                ),

                const SizedBox(height: 32),

                // Social Links
                Row(
                  mainAxisAlignment: isMobile || isTablet 
                      ? MainAxisAlignment.center 
                      : MainAxisAlignment.start,
                  children: [
                    _buildSocialIcon(FontAwesomeIcons.linkedin),
                    const SizedBox(width: 16),
                    _buildSocialIcon(FontAwesomeIcons.twitter),
                    const SizedBox(width: 16),
                    _buildSocialIcon(FontAwesomeIcons.github),
                    const SizedBox(width: 16),
                    _buildSocialIcon(FontAwesomeIcons.instagram),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildContactItem(IconData icon, String title, String value, bool centered) {
    return Row(
      mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF374151),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: const Color(0xFF3B82F6),
        size: 20,
      ),
    );
  }

  Widget _buildContactForm(bool isMobile, bool isTablet, AnimationController animationController, Animation<double> fadeAnimation, Animation<Offset> slideAnimation) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimation,
          child: SlideTransition(
            position: slideAnimation,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      validator: ValidationHelper.validateName,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _emailController,
                      label: 'Email Address',
                      keyboardType: TextInputType.emailAddress,
                      validator: ValidationHelper.validateEmail,
                    ),
                    const SizedBox(height: 20),
                    _buildTextField(
                      controller: _messageController,
                      label: 'Message',
                      maxLines: 5,
                      validator: (value) => ValidationHelper.validateMinLength(value, 10, fieldName: 'Message'),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Send Message',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.inter(
        fontSize: 16,
        color: const Color(0xFF374151),
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF64748B),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }
}
