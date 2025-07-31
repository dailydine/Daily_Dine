import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import '../bloc/profile_bloc.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}



class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _dateOfBirthController;
  String _selectedGender = '';
  File? _selectedImage;
  String? _phoneError; // For phone validation error
  final ImagePicker _picker = ImagePicker();
  bool _controllersInitialized = false;
  
  // State for editable fields
  bool _isEmailEditing = false;
  bool _isPhoneEditing = false;
  bool _isNameEditing = false;
  
  // Store original values for cancel functionality
  String _originalEmail = '';
  String _originalPhone = '';
  
  // Focus nodes for auto-focus functionality
  late FocusNode _nameFocusNode;
  late FocusNode _emailFocusNode;
  late FocusNode _phoneFocusNode;
  
  // Helper method to cancel edit mode and reset fields
  void _cancelEditModeAndReset() {
    setState(() {
      // Store current edit states before canceling
      bool wasEmailEditing = _isEmailEditing;
      bool wasPhoneEditing = _isPhoneEditing;
      
      // Cancel all edit modes
      _isNameEditing = false;
      _isEmailEditing = false;
      _isPhoneEditing = false;
      
      // Reset email field if it was being edited
      if (wasEmailEditing) {
        if (_originalEmail.isEmpty) {
          // If field was empty, reset to empty
          _emailController.text = '';
        } else {
          // If field had a value, revert to original
          _emailController.text = _originalEmail;
        }
      }
      
      // Reset phone field if it was being edited
      if (wasPhoneEditing) {
        if (_originalPhone.isEmpty) {
          // If field was empty, reset to empty
          _phoneController.text = '';
        } else {
          // If field had a value, revert to original
          _phoneController.text = _originalPhone;
        }
      }
    });
  }
  




  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _dateOfBirthController = TextEditingController();
    
    // Initialize focus nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    
    // Dispose focus nodes
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          // Only initialize controllers once when the page loads
          if (!_controllersInitialized) {
            _nameController.text = state.user.fullDisplayName.isNotEmpty 
                ? state.user.fullDisplayName 
                : state.user.displayName.isNotEmpty 
                    ? state.user.displayName 
                    : '';
            _emailController.text = state.user.email;
            // Remove +91 prefix if present for display
            String phoneNumber = state.user.phoneNumber ?? '';
            if (phoneNumber.startsWith('+91')) {
              phoneNumber = phoneNumber.substring(3);
            }
            _phoneController.text = phoneNumber;
            
            // Format date as DD/MM/YYYY
            if (state.user.dateOfBirth != null) {
              final date = state.user.dateOfBirth!;
              _dateOfBirthController.text = '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
            } else {
              _dateOfBirthController.text = '';
            }
            
            // Set gender to empty initially, only show if user has selected one
            if (state.user.gender?.isNotEmpty == true && ['Male', 'Female', 'Other'].contains(state.user.gender)) {
              _selectedGender = state.user.gender!;
            } else {
              _selectedGender = ''; // Empty by default
            }
            _controllersInitialized = true;
          }

          return _buildEditProfileContent(context, state.user);
        }

        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return const Scaffold(
          body: Center(child: Text('Error loading profile')),
        );
      },
    );
  }

  Widget _buildEditProfileContent(BuildContext context, UserModel user) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF0E6), // Lighter orange background
      resizeToAvoidBottomInset: true, // Handle keyboard properly
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(context),
            
            // Profile form (scrollable)
            Expanded(
              child: SingleChildScrollView(
                child: _buildProfileForm(context),
              ),
            ),
            
            // Save button at bottom (fixed)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Navigation and title
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Back button
              IconButton(
                onPressed: () => context.go('/profile'),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 24,
                ),
              ),
              
              // Title
              Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              
              // Home button
              IconButton(
                onPressed: () {
                  // TODO: Navigate to home
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Home - Coming Soon')),
                  );
                },
                icon: const Icon(
                  Icons.home,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Avatar section
          Column(
            children: [
              Stack(
                children: [
                  // Avatar circle
                  GestureDetector(
                    onTap: _showImagePickerDialog,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD84315), // Burnt orange color
                        shape: BoxShape.circle,
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _selectedImage == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 40,
                            )
                          : null,
                    ),
                  ),
                  
                  // Edit button
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _showImagePickerDialog,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Add Photo caption
              const SizedBox(height: 8),
              Text(
                'Add Photo',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field
            _buildNameField(context),
            
            const SizedBox(height: 16),
            
            // Email field
            _buildEmailField(context),
            
            const SizedBox(height: 16),
            
            // Phone field with country code
            _buildPhoneFieldWithEdit(context),
            
            const SizedBox(height: 16),
            
            // Date of Birth field
            _buildDateOfBirthField(context),
            
            const SizedBox(height: 16),
            
            // Gender field
            _buildGenderField(context),
          ],
        ),
      ),
    );
  }



  Widget _buildEmailField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isEmailEditing ? Colors.orange[300]! : Colors.grey[300]!,
              width: _isEmailEditing ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _emailController,
                  focusNode: _emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: !_isEmailEditing,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Enter email address',
                  ),
                ),
              ),
              if (!_isEmailEditing)
                IconButton(
                  onPressed: () {
                    // Cancel any other edit modes and reset fields
                    _cancelEditModeAndReset();
                    
                    setState(() {
                      _isEmailEditing = true;
                      // Store original value for cancel functionality
                      _originalEmail = _emailController.text;
                    });
                    
                    // Auto-focus on the email field
                    _emailFocusNode.requestFocus();
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.grey,
                    size: 20,
                  ),
                )
              else
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        _handleEmailDone();
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4), // Reduced spacing
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isEmailEditing = false;
                          // Reset to original value
                          _emailController.text = _originalEmail;
                        });
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneFieldWithEdit(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone no',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isPhoneEditing ? Colors.orange[300]! : Colors.grey[300]!,
              width: _isPhoneEditing ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              // Phone number input
              TextFormField(
                controller: _phoneController,
                focusNode: _phoneFocusNode,
                keyboardType: TextInputType.phone,
                readOnly: !_isPhoneEditing,
                style: const TextStyle(fontSize: 16),
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  hintText: 'Enter phone number',
                  prefixText: _phoneController.text.isNotEmpty ? '+91 ' : null,
                  prefixStyle: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                onChanged: (value) {
                  // Validate Indian mobile format (6,7,8,9 + 10 digits)
                  if (value.isNotEmpty && !RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                    // Show validation error
                    setState(() {
                      _phoneError = 'Please enter a valid mobile number';
                    });
                  } else {
                    setState(() {
                      _phoneError = null;
                    });
                  }
                },
              ),
              // Edit/Cancel/Done buttons
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!_isPhoneEditing)
                      IconButton(
                        onPressed: () {
                          // Cancel any other edit modes and reset fields
                          _cancelEditModeAndReset();
                          
                          setState(() {
                            _isPhoneEditing = true;
                            // Store original value for cancel functionality
                            _originalPhone = _phoneController.text;
                          });
                          
                          // Auto-focus on the phone field
                          _phoneFocusNode.requestFocus();
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 20,
                        ),
                      )
                    else
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            onPressed: () {
                              _handlePhoneDone();
                            },
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _isPhoneEditing = false;
                                // Reset to original value
                                _phoneController.text = _originalPhone;
                                _phoneError = null;
                              });
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Error message
        if (_phoneError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              _phoneError!,
              style: TextStyle(
                color: Colors.red[600],
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }



  Widget _buildNameField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Name',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _isNameEditing ? Colors.orange[300]! : Colors.grey[300]!,
              width: _isNameEditing ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  keyboardType: TextInputType.name,
                  readOnly: !_isNameEditing,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    hintText: 'Enter your name',
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  // Cancel any other edit modes and reset fields
                  _cancelEditModeAndReset();
                  
                  setState(() {
                    _isNameEditing = true;
                  });
                  
                  // Auto-focus on the name field
                  _nameFocusNode.requestFocus();
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date of Birth',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            controller: _dateOfBirthController,
            readOnly: true,
            onTap: () {
              // Cancel edit mode for text fields when interacting with dropdown
              _cancelEditModeAndReset();
              _selectDate(context);
            },
            style: const TextStyle(fontSize: 16),
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Select Date of Birth',
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: TextFormField(
            readOnly: true,
            controller: TextEditingController(text: _selectedGender.isEmpty ? '' : _selectedGender),
            style: const TextStyle(fontSize: 16),
            onTap: () {
              // Cancel edit mode for text fields when interacting with dropdown
              _cancelEditModeAndReset();
              _showGenderPicker(context);
            },
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              hintText: 'Select Gender',
              suffixIcon: Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showGenderPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Gender'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['Male', 'Female', 'Other'].map((String gender) {
              return ListTile(
                title: Text(gender),
                onTap: () {
                  setState(() {
                    _selectedGender = gender;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1997, 4, 28),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Photo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 300,
        maxHeight: 300,
        imageQuality: 80,
      );
      
      if (image != null) {
        if (mounted) {
          setState(() {
            _selectedImage = File(image.path);
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Close any active editing states
      setState(() {
        _isNameEditing = false;
        _isEmailEditing = false;
        _isPhoneEditing = false;
      });
      
      // Save profile data directly (no OTP for regular save)
      _saveProfileData();
    }
  }

  void _saveProfileData() {
    // Add +91 prefix to phone number
    final fullPhoneNumber = _phoneController.text.isNotEmpty 
        ? '+91${_phoneController.text}'
        : '';
        
    context.read<ProfileBloc>().add(
      UpdateProfile(
        name: _nameController.text,
        email: _emailController.text,
        phoneNumber: fullPhoneNumber,
        dateOfBirth: _dateOfBirthController.text,
        gender: _selectedGender,
        avatarPath: _selectedImage?.path,
      ),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile updated successfully!'),
        backgroundColor: Colors.green,
      ),
    );
    
    context.go('/profile');
  }

  // Validation methods
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  

  
  void _handleEmailDone() {
    final email = _emailController.text.trim();
    
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }
    
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }
    
    _showEmailChangeConfirmation();
  }
  
  void _handlePhoneDone() {
    final phone = _phoneController.text.trim();
    
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }
    
    // Validate Indian mobile format (6,7,8,9 + 10 digits)
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(phone)) {
      setState(() {
        _phoneError = 'Please enter a valid Indian mobile number';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid Indian mobile number')),
      );
      return;
    }
    
    setState(() {
      _phoneError = null;
    });
    
    _showPhoneChangeConfirmation();
  }
  
  void _showPhoneChangeConfirmation() {
    final fullPhoneNumber = _phoneController.text.isNotEmpty 
        ? '+91${_phoneController.text}'
        : '';
        
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Change Phone Number',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to change your phone number to "$fullPhoneNumber"?',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Revert to original value when cancelled
                _phoneController.text = _originalPhone;
                setState(() {
                  _isPhoneEditing = false;
                });
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showOTPVerificationDialog(context, false, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _showEmailChangeConfirmation() {
    final email = _emailController.text.trim();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Change Email',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to change your email to "$email"?',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Revert to original value when cancelled
                _emailController.text = _originalEmail;
                setState(() {
                  _isEmailEditing = false;
                });
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showOTPVerificationDialog(context, true, false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }



  void _showOTPVerificationDialog(BuildContext context, bool emailChanged, bool phoneChanged) {
    final List<TextEditingController> otpControllers = List.generate(
      4, 
      (index) => TextEditingController(),
    );
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Timer state management
            int timeRemaining = 60;
            Timer? dialogTimer;
            
            // Start timer only once when dialog is created
            dialogTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
              if (timeRemaining > 0) {
                setState(() {
                  timeRemaining--;
                });
              } else {
                timer.cancel();
                setState(() {
                  timeRemaining = 0;
                });
                // Revert to original values when timer expires
                if (emailChanged) {
                  _emailController.text = _originalEmail;
                }
                if (phoneChanged) {
                  _phoneController.text = _originalPhone;
                }
                // Reset edit states
                this.setState(() {
                  _isEmailEditing = false;
                  _isPhoneEditing = false;
                });
              }
            });
            
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Title
                    Text(
                      'Verify Changes',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Description
                    Text(
                      emailChanged && phoneChanged
                          ? 'We\'ve sent OTP to your email and phone for verification'
                          : emailChanged
                              ? 'We\'ve sent OTP to your email for verification'
                              : 'We\'ve sent OTP to your phone for verification',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Timer
                    Text(
                      'Time remaining: ${timeRemaining}s',
                      style: TextStyle(
                        color: timeRemaining <= 10 ? Colors.red : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(4, (index) {
                        return SizedBox(
                          width: 50,
                          child: TextFormField(
                            controller: otpControllers[index],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            maxLength: 1,
                            enabled: timeRemaining > 0,
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                            ),
                            onChanged: (value) {
                              if (value.length == 1 && index < 3) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 24),
                    
                    // Resend button (only show when timer expires)
                    if (timeRemaining == 0)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TextButton(
                          onPressed: () {
                            // Reset timer and resend OTP
                            dialogTimer?.cancel();
                            timeRemaining = 60;
                            setState(() {});
                            dialogTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
                              if (timeRemaining > 0) {
                                setState(() {
                                  timeRemaining--;
                                });
                              } else {
                                timer.cancel();
                                setState(() {
                                  timeRemaining = 0;
                                });
                                // Revert to original values when timer expires
                                if (emailChanged) {
                                  _emailController.text = _originalEmail;
                                }
                                if (phoneChanged) {
                                  _phoneController.text = _originalPhone;
                                }
                                // Reset edit states
                                this.setState(() {
                                  _isEmailEditing = false;
                                  _isPhoneEditing = false;
                                });
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('OTP resent successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          child: const Text(
                            'Resend OTP',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    
                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              dialogTimer?.cancel();
                              Navigator.of(context).pop();
                              // Revert to original values when cancelled
                              if (emailChanged) {
                                _emailController.text = _originalEmail;
                              }
                              if (phoneChanged) {
                                _phoneController.text = _originalPhone;
                              }
                              // Reset edit states
                              this.setState(() {
                                _isEmailEditing = false;
                                _isPhoneEditing = false;
                              });
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: timeRemaining > 0 ? () {
                              // Verify OTP (mock verification)
                              final otp = otpControllers.map((c) => c.text).join('');
                              if (otp.length == 4) {
                                dialogTimer?.cancel();
                                Navigator.of(context).pop();
                                _saveProfileData();
                                // Reset edit states
                                this.setState(() {
                                  _isEmailEditing = false;
                                  _isPhoneEditing = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('OTP verified successfully!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter valid OTP'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: timeRemaining > 0 ? AppTheme.primaryColor : Colors.grey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              timeRemaining > 0 ? 'Verify' : 'Expired',
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
