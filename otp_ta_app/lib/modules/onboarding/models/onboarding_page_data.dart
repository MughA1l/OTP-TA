/// Data class representing a single onboarding page's content
class OnboardingPageData {
  final String title;
  final String subtitle;
  final String iconAsset; // We'll use Icons instead of images
  final int iconCodePoint;

  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.iconAsset,
    required this.iconCodePoint,
  });
}
