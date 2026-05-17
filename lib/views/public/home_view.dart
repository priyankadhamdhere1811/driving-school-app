import 'package:flutter/material.dart';

import '../../widgets/floating_cta_buttons.dart';
import 'sections/contact_section.dart';
import 'sections/courses_section.dart';
import 'sections/footer_section.dart';
import 'sections/hero_section.dart';
import 'sections/navbar_section.dart';
import 'sections/reviews_section.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scrollController = ScrollController();
  final _coursesKey = GlobalKey();
  final _reviewsKey = GlobalKey();
  final _contactKey = GlobalKey<ContactSectionState>();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(GlobalKey key) {
    final sectionContext = key.currentContext;
    if (sectionContext == null) {
      return;
    }

    Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _scrollToContact({String? course}) {
    if (course != null) {
      _contactKey.currentState?.selectCourse(course);
    }

    _scrollTo(_contactKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarSection(
        onCoursesTap: () => _scrollTo(_coursesKey),
        onReviewsTap: () => _scrollTo(_reviewsKey),
        onContactTap: _scrollToContact,
        onCallTap: _scrollToContact,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                HeroSection(
                  onCallTap: _scrollToContact,
                  onWhatsAppTap: _scrollToContact,
                  onCoursesTap: () => _scrollTo(_coursesKey),
                ),
                WhyChooseUsSection(onContactTap: _scrollToContact),
                CoursesSection(
                  key: _coursesKey,
                  onEnquireTap: (course) => _scrollToContact(course: course),
                ),
                ReviewsSection(key: _reviewsKey),
                ContactSection(key: _contactKey),
                FooterSection(
                  onCoursesTap: () => _scrollTo(_coursesKey),
                  onReviewsTap: () => _scrollTo(_reviewsKey),
                  onContactTap: _scrollToContact,
                ),
              ],
            ),
          ),
          FloatingCtaButtons(
            onCallTap: _scrollToContact,
            onWhatsAppTap: _scrollToContact,
          ),
        ],
      ),
    );
  }
}
