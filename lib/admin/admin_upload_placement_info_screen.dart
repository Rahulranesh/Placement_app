import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:place/services/database_services.dart';
import 'package:place/utils/neumorphic_widget.dart';
import 'package:place/utils/custom_appbar.dart';

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
        await DatabaseService().addPlacementInfo(infoData: {
          'companyName': companyName,
          'eligibility': eligibility,
          'description': description,
          'placementDate': placementDate!.toIso8601String(),
        });
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Placement info uploaded successfully!")));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error uploading placement info: $e")));
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
      appBar: CustomAppBar(title: 'Upload Placement Info'),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: NeumorphicContainer(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  NeumorphicTextField(
                    label: 'Company Name',
                    onSaved: (value) => companyName = value.trim(),
                  ),
                  SizedBox(height: 15),
                  NeumorphicTextField(
                    label: 'Eligibility Criteria',
                    onSaved: (value) => eligibility = value.trim(),
                  ),
                  SizedBox(height: 15),
                  NeumorphicTextField(
                    label: 'Description',
                    onSaved: (value) => description = value.trim(),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          placementDate != null
                              ? 'Selected Date: ${DateFormat.yMd().format(placementDate!)}'
                              : 'No date selected',
                          style: TextStyle(fontSize: 16),
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
                      child: Text('Upload Placement Info',
                          style: TextStyle(fontSize: 18))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
