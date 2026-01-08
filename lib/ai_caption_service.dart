import 'dart:math';

class AICaptionService {
  final Random _random = Random();

  // Generate caption with context (location, work type, etc.)
  String generateCaption({String? context, String? location}) {
    final captions = _getCaptionTemplates(location);
    return captions[_random.nextInt(captions.length)];
  }

  List<String> _getCaptionTemplates(String? location) {
    final locationTag = location != null
        ? '#${location.split(',')[0].replaceAll(' ', '')}'
        : '';

    return [
      'Another beautiful view installed${location != null ? ' in $locationTag' : ''}! 📱✨\n\nWe just fitted this custom double-glazing unit. Perfect insulation for winter and crystal clear views.\n\n#GlasereiMüller #Handwerk #NewWindows',

      'Fresh installation complete${location != null ? ' here in $locationTag' : ''}! 🏗️\n\nQuality craftsmanship meets modern design. Our team takes pride in every detail.\n\n#ProfessionalInstallation #Construction #QualityWork',

      'Project spotlight${location != null ? ' - $locationTag' : ''}! ⚡\n\nAnother satisfied client with premium materials and expert installation. This is what we do best!\n\n#InstallationExperts #Craftsmanship #HomeImprovement',

      'Today\'s work${location != null ? ' in $locationTag' : ''}: Perfection in progress! 🔨\n\nFrom concept to completion, we deliver excellence. Swipe to see the transformation!\n\n#BeforeAndAfter #ProfessionalWork #Installation',

      'Just wrapped up this amazing project${location != null ? ' in $locationTag' : ''}! 🌟\n\nOur commitment to quality shows in every installation. Proud of how this turned out!\n\n#WorkWithPride #ProfessionalServices #QualityCraftsmanship',
    ];
  }
}
