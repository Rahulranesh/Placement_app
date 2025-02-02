import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/container.dart';
import 'package:place/utils/button.dart';

class AdminUploadPlacementInfoScreen extends StatefulWidget {
  final bool uploadOnly;
  const AdminUploadPlacementInfoScreen({this.uploadOnly = false, Key? key})
      : super(key: key);

  @override
  _AdminUploadPlacementInfoScreenState createState() =>
      _AdminUploadPlacementInfoScreenState();
}

class _AdminUploadPlacementInfoScreenState
    extends State<AdminUploadPlacementInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  String companyName = '';
  String eligibility = '';
  String description = '';
  DateTime? placementDate;

  Future<void> _uploadPlacementInfo() async {
    if (_formKey.currentState!.validate() && placementDate != null) {
      _formKey.currentState!.save();
      try {
        await DatabaseService().addPlacementInfo(
          infoData: {
            'companyName': companyName,
            'eligibility': eligibility,
            'description': description,
            'placementDate': placementDate!.toIso8601String(),
          },
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Placement info uploaded successfully!")),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error uploading placement info: $e")),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = initialDate;
    DateTime lastDate = initialDate.add(Duration(days: 365));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null && picked != placementDate) {
      setState(() {
        placementDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Placement Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NeumorphicContainer(
          borderRadius: BorderRadius.circular(20),
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Company Name'),
                  onSaved: (value) => companyName = value!.trim(),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter company name'
                      : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Eligibility Criteria'),
                  onSaved: (value) => eligibility = value!.trim(),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter eligibility criteria'
                      : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value!.trim(),
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Enter description'
                      : null,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        placementDate != null
                            ? 'Selected Date: ${DateFormat.yMd().format(placementDate!)}'
                            : 'No date selected',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _selectDate,
                      child: Text('Select Date'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                neumorphicButton(
                  onPressed: _uploadPlacementInfo,
                  child: Center(child: Text('Upload Placement Info')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
