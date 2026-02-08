import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocos_mobile_application/core/services/auth_service.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _authService = AuthService();
  final _nameController = TextEditingController();

  // Controllers for onboarding answers
  final _businessNameController = TextEditingController();
  final _targetAudienceController = TextEditingController();
  final _productsServicesController = TextEditingController();

  String _selectedBusinessType = '';
  String _selectedBrandTone = '';
  List<String> _selectedGoals = [];

  bool _isLoading = true;
  bool _isSaving = false;

  final List<String> _businessTypes = [
    'Restaurant/Café',
    'Retail Store',
    'Service Provider',
    'E-commerce',
    'Healthcare',
    'Education',
    'Technology',
    'Other',
  ];

  final List<String> _brandTones = [
    'Professional',
    'Friendly',
    'Playful',
    'Luxury',
    'Bold',
    'Minimalist',
  ];

  final List<String> _goalOptions = [
    'Increase Brand Awareness',
    'Drive Sales',
    'Build Community',
    'Share Updates',
    'Showcase Work',
    'Customer Engagement',
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Load display name
      _nameController.text = user.displayName ?? '';

      // Load onboarding answers from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data();
        final answers = data?['onboardingAnswers'] as Map<String, dynamic>?;

        if (answers != null) {
          setState(() {
            _businessNameController.text = answers['businessName'] ?? '';
            _selectedBusinessType = answers['businessType'] ?? '';
            _targetAudienceController.text = answers['targetAudience'] ?? '';
            _productsServicesController.text =
                answers['productsServices'] ?? '';
            _selectedBrandTone = answers['brandTone'] ?? '';
            _selectedGoals = List<String>.from(answers['mainGoals'] ?? []);
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Update display name in Firebase Auth
      await user.updateDisplayName(_nameController.text.trim());

      // Update onboarding answers in Firestore
      final updatedAnswers = {
        'businessName': _businessNameController.text.trim(),
        'businessType': _selectedBusinessType,
        'targetAudience': _targetAudienceController.text.trim(),
        'productsServices': _productsServicesController.text.trim(),
        'brandTone': _selectedBrandTone,
        'mainGoals': _selectedGoals,
      };

      await _authService.updateUserProfile(
        displayName: _nameController.text.trim(),
        onboardingAnswers: updatedAnswers,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving changes: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _businessNameController.dispose();
    _targetAudienceController.dispose();
    _productsServicesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade200,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade800),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Personal Details',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name Section
                  _buildSectionTitle('Display Name'),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _nameController,
                    hint: 'Your name',
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 32),

                  // Business Information
                  _buildSectionTitle('Business Information'),
                  const SizedBox(height: 12),

                  Text(
                    'Business Name',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _businessNameController,
                    hint: 'Your business name',
                    icon: Icons.business,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Business Type',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBusinessTypeSelector(),
                  const SizedBox(height: 20),

                  Text(
                    'Target Audience',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _targetAudienceController,
                    hint: 'Who are your customers?',
                    icon: Icons.people,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Products/Services',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _productsServicesController,
                    hint: 'What do you offer?',
                    icon: Icons.shopping_bag,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Brand Tone',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBrandToneSelector(),
                  const SizedBox(height: 20),

                  Text(
                    'Main Goals',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildGoalsSelector(),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Save Changes',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200, width: 2),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.poppins(fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
          prefixIcon: Icon(icon, color: Colors.green),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildBusinessTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _businessTypes.map((type) {
        final isSelected = _selectedBusinessType == type;
        return GestureDetector(
          onTap: () => setState(() => _selectedBusinessType = type),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.green.shade200,
                width: 2,
              ),
            ),
            child: Text(
              type,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBrandToneSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _brandTones.map((tone) {
        final isSelected = _selectedBrandTone == tone;
        return GestureDetector(
          onTap: () => setState(() => _selectedBrandTone = tone),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.green.shade200,
                width: 2,
              ),
            ),
            child: Text(
              tone,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGoalsSelector() {
    return Column(
      children: _goalOptions.map((goal) {
        final isSelected = _selectedGoals.contains(goal);
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.green : Colors.green.shade200,
                width: 2,
              ),
            ),
            child: CheckboxListTile(
              title: Text(
                goal,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              value: isSelected,
              activeColor: Colors.green,
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedGoals.add(goal);
                  } else {
                    _selectedGoals.remove(goal);
                  }
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }
}
