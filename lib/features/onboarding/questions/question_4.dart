import 'package:cocos_mobile_application/features/onboarding/questions/question_5.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Question4 extends StatefulWidget {
  final String answer1;
  final String answer2;
  final String answer3;
  const Question4({
    super.key,
    required this.answer1,
    required this.answer2,
    required this.answer3,
  });

  @override
  State<Question4> createState() => _Question4State();
}

class _Question4State extends State<Question4> {
  final _customController = TextEditingController();
  String? _selectedOption;
  bool _showCustomField = false;

  final Map<String, Map<String, dynamic>> _options = {
    'Profes-\nsional': {
      'size': 130.0,
      'top': 8.0,
      'left': 8.0,
      'fontSize': 15.5,
    },
    'Friendly': {'size': 115.0, 'top': 12.0, 'left': 178.0, 'fontSize': 16.0},
    'Creative': {'size': 122.0, 'top': 148.0, 'left': 2.0, 'fontSize': 17.0},
    'Luxury': {'size': 108.0, 'top': 160.0, 'left': 190.0, 'fontSize': 15.0},
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
      answer = _selectedOption?.replaceAll('\n', '') ?? '';
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
        builder: (context) => Question5(
          answer1: widget.answer1,
          answer2: widget.answer2,
          answer3: widget.answer3,
          answer4: answer,
        ),
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
                "Nearly Done...",
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: 0.8,
                backgroundColor: Colors.grey.shade300,
                color: Colors.green,
                minHeight: 6,
              ),
              const SizedBox(height: 32),
              Text(
                "What is the tone or style of your brand?",
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
