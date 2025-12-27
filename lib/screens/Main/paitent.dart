import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/dashboard_provider.dart';
import '../../models/patient_model.dart';

class PatientRegistrationScreen extends StatefulWidget {
  final Patient? patient;

  const PatientRegistrationScreen({super.key, this.patient});

  @override
  State<PatientRegistrationScreen> createState() =>
      _PatientRegistrationScreenState();
}

class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _diseaseController;

  late String _selectedGender;
  late String _selectedBloodGroup;
  bool _isLoading = false;
  late bool _isEditMode;

  final List<String> genders = ['Male', 'Female', 'Other'];
  final List<String> bloodGroups = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _isEditMode = widget.patient != null;

    if (_isEditMode) {
      print('EDIT MODE - Patient: ${widget.patient!.name}');
      _nameController = TextEditingController(text: widget.patient!.name);
      _ageController = TextEditingController(text: widget.patient!.age);
      _phoneController = TextEditingController(text: widget.patient!.phoneNumber);
      _addressController = TextEditingController(text: widget.patient!.address);
      _diseaseController = TextEditingController(text: widget.patient!.disease);
      _selectedGender = widget.patient!.gender;
      _selectedBloodGroup = widget.patient!.bloodGroup;
    } else {
      print('ADD MODE');
      _nameController = TextEditingController();
      _ageController = TextEditingController();
      _phoneController = TextEditingController();
      _addressController = TextEditingController();
      _diseaseController = TextEditingController();
      _selectedGender = 'Male';
      _selectedBloodGroup = 'A+';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _diseaseController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (_nameController.text.isEmpty ||
        _ageController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _diseaseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final dashboardProvider =
      Provider.of<DashboardProvider>(context, listen: false);

      if (_isEditMode) {
        final updatedPatient = Patient(
          id: widget.patient!.id,
          name: _nameController.text,
          disease: _diseaseController.text,
          time: widget.patient!.time,
          status: widget.patient!.status,
          age: _ageController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          gender: _selectedGender,
          bloodGroup: _selectedBloodGroup,
        );

        await dashboardProvider.updatePatient(widget.patient!.id, updatedPatient);

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient updated successfully!')),
        );

        Navigator.pop(context, true);
      } else {
        final patient = Patient(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: _nameController.text,
          disease: _diseaseController.text,
          time: TimeOfDay.now().format(context),
          status: 'Pending',
          age: _ageController.text,
          phoneNumber: _phoneController.text,
          address: _addressController.text,
          gender: _selectedGender,
          bloodGroup: _selectedBloodGroup,
        );

        await dashboardProvider.addPatient(patient);

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Patient registered successfully!')),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      print('Save error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: Text(
          _isEditMode ? 'Edit Patient' : 'Register New Patient',
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Full Name'),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter patient name',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.person, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Age'),
                      TextField(
                        controller: _ageController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Age',
                          hintStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Gender'),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedGender,
                          isExpanded: true,
                          underline: Container(),
                          dropdownColor: const Color(0xFF1A1A2E),
                          items: genders.map((gender) {
                            return DropdownMenuItem(
                              value: gender,
                              child: Text(
                                gender,
                                style: const TextStyle(color: Colors.white),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedGender = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            _buildLabel('Phone Number'),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.phone, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Blood Group'),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButton<String>(
                value: _selectedBloodGroup,
                isExpanded: true,
                underline: Container(),
                dropdownColor: const Color(0xFF1A1A2E),
                items: bloodGroups.map((group) {
                  return DropdownMenuItem(
                    value: group,
                    child: Text(
                      group,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBloodGroup = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Address'),
            TextField(
              controller: _addressController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter address',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.location_on, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            _buildLabel('Disease/Complaint'),
            TextField(
              controller: _diseaseController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter disease or complaint',
                hintStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.medical_services, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _savePatient,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  _isEditMode ? 'Update Patient' : 'Save Patient',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }
}
