import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:QR_Ticket_Scanner/Const.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final controller1 = SingleValueDropDownController();
  final controller2 = SingleValueDropDownController();
  final controller3 = SingleValueDropDownController();
  final _formkey = GlobalKey<FormState>();
  bool flag = false;

  @override
  void initState() {
    // controller1.setDropDown(const DropDownValueModel(name: "Ahmedabad", value: "Ahmedabad"));
    // controller3.setDropDown(const DropDownValueModel(name: "Entry", value: "Entry"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cityName == null || stationName == null || gateName == null
            ? flag = false
            : flag = true;
        return flag;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
          backgroundColor: c1,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                dropField(context, "City", citiesList, controller1, true),
                dropField(context, "Metro Station", metroStationsList,
                    controller2, false),
                dropField(context, "Gate", gateList, controller3, false),
                const SizedBox(
                  height: 250,
                ),
                GestureDetector(
                  onTap: () async {
                    if(_formkey.currentState!.validate()){
                    cityName=controller1.dropDownValue!.value;
                    stationName=controller2.dropDownValue!.value;
                    gateName=controller3.dropDownValue!.value;
                    setState(() {
                    });
                    Navigator.pop(context);
                    snackBar(context, Colors.green, "Data Saved...");}
                    setState(() {
                    });
                  },
                  child: Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15), color: c1),
                    child: const Center(
                        child: Text(
                      "Save",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  dropField(context, String lable, List<DropDownValueModel> items,
      SingleValueDropDownController controller, bool condition) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropDownTextField(
          onChanged: (value) async {
            if (condition) {
              if (controller1.dropDownValue!.value.toString() == "Ahmedabad") {
                loading(context);
                await buildDataBase(
                    controller1.dropDownValue!.value.toString());
                setState(() {});
                Navigator.of(context).pop();
              } else {
                controller1.clearDropDown();
                setState(() {});
                snackBar(context, Colors.red,
                    "MetroX is not available in selected city.");
              }
            }
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select an option';
            }
            return null;
          },
          isEnabled: true,
          clearOption: false,
          controller: controller,
          dropDownItemCount: 5,
          dropDownList: items,
          dropdownRadius: 0,
          textFieldDecoration: InputDecoration(
            labelStyle: const TextStyle(color: Colors.black87),
            labelText: lable,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: c1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: c1,
              ),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

}
