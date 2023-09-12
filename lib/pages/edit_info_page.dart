import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Resources/text_form.dart';

import 'navigation_page.dart';

class EditInfo extends StatefulWidget {
  const EditInfo({super.key});

  @override
  State<EditInfo> createState() => _EditInfoState();
}


class _EditInfoState extends State<EditInfo> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController(text: actualUser.name);
  final _surnameController = TextEditingController(text: actualUser.surname);
  final _ageController = TextEditingController(text: actualUser.age);
  final _weeksController = TextEditingController(text: actualUser.weeks);
  final _previousPregController = TextEditingController(text: actualUser.prevPreg);
  final _numChildrenController = TextEditingController(text: actualUser.numChildren);

  String? _riskController = (actualUser.pregRisk).toString();
  List<String> riskLevels = ['LOW', 'HIGH'];

  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      uploadDatabase();

      actualUser.name = _nameController.text.trim();
      actualUser.surname = _surnameController.text.trim();
      actualUser.age = _ageController.text.trim();
      actualUser.weeks = _weeksController.text.trim();
      actualUser.prevPreg = _previousPregController.text.trim();
      actualUser.numChildren = _numChildrenController.text.trim();
      actualUser.pregRisk = (_riskController).toString();

      Navigator.of(context).pop(true);

    } else {
      setState(() {
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  Future uploadDatabase() async {
    var user = FirebaseAuth.instance.currentUser;
    int timestamp = DateTime
        .now()
        .millisecondsSinceEpoch;

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    await _firestore.collection('users').doc(user?.uid).update(
        {
          'name': _nameController.text.trim(),
          'surname': _surnameController.text.trim(),
          'age': _ageController.text.trim(),
          'weeks': _weeksController.text.trim(),
          'prevPreg': _previousPregController.text.trim(),
          'numChildren': _numChildrenController.text.trim(),
          'pregRisk': _riskController,
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[100],
        body: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          },
                        icon: const Icon(Icons.arrow_back_rounded),
                        color: (Colors.grey[800])!,),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 45.0, right: 45.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text('Edit profile',
                          style: TextStyle(color: Colors.grey[800],
                              fontSize: 45,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2.0),),
                        Text('Modify your profile information',
                          style: TextStyle(color: Colors.grey[800],
                              fontSize: 16,
                              letterSpacing: 2.0),),
                        const SizedBox(height: 40.0),
                        Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(
                                  20.0))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                            child: Column(children: [

                              Form(
                                key: _formKey,
                                child: FormUI(),
                                autovalidateMode: _autoValidate,
                              ),

                              const SizedBox(height: 30),

                              GestureDetector(
                                onTap: _validateInputs,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4c405c),
                                    borderRadius: BorderRadius.circular((12)),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Update profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),

                              ),


                            ],),
                          ),
                        ),

                        const SizedBox(height: 50,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }

  Widget FormUI() {
    return Column(children: [
      ParameterWidget(_nameController, _textValidator, 'NAME', textCap: true),
      const SizedBox(height: 20),
      ParameterWidget(_surnameController, _textValidator, 'SURNAME', textCap: true),
      const SizedBox(height: 20),
      ParameterWidget(_ageController, _numValidator, 'AGE'),
      const SizedBox(height: 20),
      ParameterWidget(_weeksController, _numValidator, 'HOW MANY WEEKS',
          variable2: 'PREGNANT ARE YOU?'),
      const SizedBox(height: 20),
      ParameterWidget(
          _previousPregController, _numValidator, 'NUMBER OF PREVIOUS',
          variable2: 'PREGNANCIES'),
      const SizedBox(height: 20),
      ParameterWidget(
          _numChildrenController, _numValidator, 'HOW MANY CHILDREN ARE',
          variable2: 'YOU EXPECTING?'),
      const SizedBox(height: 20),
      //ParameterWidget(_riskController, _textValidator, 'IS IT A HIGH-RISK PREGNANCY?'),
      Row(
        children: [
          Text('IS IT A HIGH-RISK PREGNANCY?',
            style: TextStyle(
                color: Colors.grey[700],
                letterSpacing: 2.0,
                fontSize: 15.0
            ),),
        ],
      ),

      const SizedBox(height: 7.0),

      DropdownButtonFormField(
        value: _riskController,
        hint: const Text('Choose one'),
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            _riskController = value;
          });
        },
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return "Please choose the value from the dropdown";
          } else {
            return null;
          }
        },
        items: riskLevels.map((String val) {
          return DropdownMenuItem(
            value: val,
            child: Text(val),
          );
        }).toList(),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(12)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF4c405c)),
            borderRadius: BorderRadius.circular(12),
          ),
          fillColor: Colors.grey[200],
          filled: true,
        ),
      ),


    ],);
  }

  String? _textValidator(String? value) {
    if (value!.isEmpty) {
      return 'Cannot be empty';
    }
    if (value.length < 2) {
      return 'Must be more than 2 charaters';
    } else {
      return null;
    }
  }

  String? _numValidator(String? value) {
    RegExp regex = RegExp(r"^\d+$");
    if (value!.isEmpty) {
      return 'Cannot be empty';
    }
    if (!regex.hasMatch(value)) {
      return 'Enter a number';
    } else {
      return null;
    }
  }
}
