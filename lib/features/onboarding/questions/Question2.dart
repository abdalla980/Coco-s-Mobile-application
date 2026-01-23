import 'package:cocos_mobile_application/features/onboarding/questions/Question3.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Question2 extends StatefulWidget {
  final String answer1;
  const Question2({super.key, required this.answer1});

  @override
  State<Question2> createState() => _Question2State();
}

class _Question2State extends State<Question2> {
  final _customController = TextEditingController();
  String? _selectedOption;
  bool _showCustomField = false;

  final Map<String, Map<String, dynamic>> _options = {
    'Teens': {'size': 105.0, 'top': 10.0, 'left': 25.0, 'fontSize': 14.0},
    'Young\nAdults': {
      'size': 135.0,
      'top': 5.0,
      'left': 155.0,
      'fontSize': 16.0,
    },
    'Families': {'size': 125.0, 'top': 150.0, 'left': 5.0, 'fontSize': 17.0},
    'Seniors': {'size': 110.0, 'top': 155.0, 'left': 185.0, 'fontSize': 15.0},
  };

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

  void _next() {
    String answer = '';
    if (_selectedOption == 'Custom') {
      answer = _customController.text.trim();
    } else {
      answer = _selectedOption?.replaceAll('\n', ' ') ?? '';
    }

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select or enter an answer')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            Question3(answer1: widget.answer1, answer2: answer),
      ),
    );
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
                "One More...",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.4,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 6,
              ),
              const SizedBox(height: 32),
              Text(
                "Who is your target audience?",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 32),
              // Chaotic bubble layout
              SizedBox(
                height: 290,
                child: Stack(
                  children: _options.entries.map((entry) {
                    return Positioned(
                      top: entry.value['top'],
                      left: entry.value['left'],
                      child: _buildBubbleButton(
                        entry.key,
                        entry.value['size'],
                        entry.value['fontSize'],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              // Custom option as pill button
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
                  onPressed: _next,
                  label: Text(
                    "Next",
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

  Widget _buildBubbleButton(String text, double size, double fontSize) {
    final isSelected = _selectedOption == text;

    return GestureDetector(
      onTap: () => _selectOption(text),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: fontSize,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.black87,
                height: 1.1,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPillButton(String text, {bool isCustom = false}) {
    final isSelected = isCustom && _selectedOption == 'Custom';

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
