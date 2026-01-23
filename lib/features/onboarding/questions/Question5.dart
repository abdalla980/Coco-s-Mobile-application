import 'package:cocos_mobile_application/features/dashboard/HomeScreen.dart';
import 'package:cocos_mobile_application/core/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Question5 extends StatefulWidget {
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4;
  const Question5({
    super.key,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
  });

  @override
  State<Question5> createState() => _Question5State();
}

class _Question5State extends State<Question5> {
  final _customController = TextEditingController();
  final _authService = AuthService();
  String? _selectedOption;
  bool _showCustomField = false;
  bool _isLoading = false;

  final List<String> _options = [
    'Increase Sales',
    'Build Awareness',
    'Customer Engagement',
    'Market Expansion',
  ];

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }

  void _selectOption(String option) {
    setState(() {
      _selectedOption = option;
      _showCustomField = false;
      _customController.clear();
    });
  }

  void _selectCustom() {
    setState(() {
      _selectedOption = 'Custom';
      _showCustomField = true;
    });
  }

  Future<void> _submitAnswers() async {
    String answer = '';
    if (_selectedOption == 'Custom') {
      answer = _customController.text.trim();
    } else {
      answer = _selectedOption ?? '';
    }

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter an answer')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare answers map
      final answers = {
        'businessType': widget.answer1,
        'targetAudience': widget.answer2,
        'productsServices': widget.answer3,
        'brandTone': widget.answer4,
        'mainGoals': answer,
      };

      // Save to Firestore
      await _authService.saveOnboardingAnswers(answers);

      // Navigate to HomeScreen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homescreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving answers: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "And we are done...",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 1.0,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 6,
              ),
              const SizedBox(height: 32),
              Text(
                "What are your main goals with this app?",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              // Pill buttons
              ..._options.map(
                (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildPillButton(option),
                ),
              ),
              const SizedBox(height: 8),
              _buildPillButton('Custom Answer', isCustom: true),
              if (_showCustomField) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _customController,
                  decoration: InputDecoration(
                    labelText: 'Your answer',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.green,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FloatingActionButton.extended(
                  onPressed: _isLoading ? null : _submitAnswers,
                  label: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Submit",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                  backgroundColor: Colors.green,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton(String text, {bool isCustom = false}) {
    final isSelected = isCustom
        ? _selectedOption == 'Custom'
        : _selectedOption == text;

    return GestureDetector(
      onTap: isCustom ? _selectCustom : () => _selectOption(text),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}
