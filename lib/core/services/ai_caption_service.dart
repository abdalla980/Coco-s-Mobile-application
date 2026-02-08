import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:cocos_mobile_application/config/env_config.dart';

class AICaptionService {
  final Random _random = Random();

  /// Generate caption from image with user profile context
  /// Falls back to mock if feature flag is disabled or API fails
  Future<String> generateCaptionFromImage(
    File imageFile, {
    String? location,
    Map<String, dynamic>? userProfile,
  }) async {
    if (EnvConfig.enableRealAICaptions && EnvConfig.geminiApiKey.isNotEmpty) {
      try {
        return await _generateCaptionReal(
          imageFile,
          location: location,
          userProfile: userProfile,
        );
      } catch (e) {
        debugPrint('Error generating real caption: $e');
        debugPrint('Falling back to mock caption');
        return _generateCaptionMock(location: location);
      }
    } else {
      return _generateCaptionMock(location: location);
    }
  }

  /// Legacy method for backward compatibility
  String generateCaption({String? context, String? location}) {
    return _generateCaptionMock(location: location);
  }

  /// Generate caption using Google Gemini API
  Future<String> _generateCaptionReal(
    File imageFile, {
    String? location,
    Map<String, dynamic>? userProfile,
  }) async {
    // Using gemini-2.5-flash-lite for AI caption generation
    final model = GenerativeModel(
      model: 'gemini-2.5-flash-lite',
      apiKey: EnvConfig.geminiApiKey,
    );

    // Read image bytes
    final imageBytes = await imageFile.readAsBytes();

    // Build personalized prompt with user context
    final prompt = _buildPrompt(location: location, userProfile: userProfile);

    // Create content with image and prompt
    final content = [
      Content.multi([TextPart(prompt), DataPart('image/jpeg', imageBytes)]),
    ];

    // Generate caption
    final response = await model.generateContent(content);
    final caption = response.text?.trim() ?? '';

    if (caption.isEmpty) {
      throw Exception('Empty caption received from API');
    }

    return caption;
  }

  /// Build AI prompt with user profile personalization
  String _buildPrompt({String? location, Map<String, dynamic>? userProfile}) {
    // Extract user profile info
    final businessType = userProfile?['businessType'] ?? 'business';
    final targetAudience = userProfile?['targetAudience'] ?? 'general audience';
    final productsServices =
        userProfile?['productsServices'] ?? 'quality products and services';
    final brandTone = userProfile?['brandTone'] ?? 'professional';
    final mainGoals = userProfile?['mainGoals'] ?? 'showcasing work';

    final prompt =
        '''
You are a professional social media caption writer for small businesses.

USER'S BUSINESS PROFILE:
- Business Type: $businessType
- Target Audience: $targetAudience
- Products/Services: $productsServices
- Brand Tone: $brandTone
- Main Goals: $mainGoals

TASK:
Analyze this image and generate an engaging Instagram/Facebook caption that fits THIS specific type of business.

CRITICAL GUIDELINES:
- Adapt your language to the business type:
  * For trades/crafts (construction, woodworking, installation): Talk about quality, precision, attention to detail
  * For food businesses (restaurants, cafes, food carts, bakeries): Talk about taste, flavors, fresh ingredients, what you're serving
  * For retail (stores, boutiques, shops): Talk about products, collections, what's new, what customers will love
  * For services (hair salons, cleaning, repairs): Talk about the experience, results, how you help customers
  * For creative businesses (photography, art, design): Talk about the work, the vision, the story behind it

- Write from the perspective of a $businessType business owner
- Speak directly to $targetAudience in a $brandTone tone
- Be conversational and natural, like you're posting on your own account
- Use 1-3 relevant emojis that fit the business vibe
- Include ONLY 3 hashtags maximum (relevant to $businessType)
${location != null ? '- Mention this location naturally: $location' : ''}
- Length: 2-3 short, punchy sentences
- Sound human and authentic, not corporate

DO:
- Use emojis (1-3 total)
- Keep it simple and relatable
- Focus on what's in the image

DO NOT:
- Use corporate buzzwords like "solutions", "leverage", "synergy", "innovative"
- Use tech jargon
- Talk about "craftsmanship" unless it's a craft/trade business
- Use quotes around the caption
- Sound like a marketing agency

Generate ONLY the caption text:
''';

    return prompt;
  }

  /// Generate mock caption (existing implementation)
  String _generateCaptionMock({String? location}) {
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
