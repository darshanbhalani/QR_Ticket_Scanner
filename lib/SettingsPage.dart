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
  bool? flag1=false;
  bool isLoading=true;

  @override
  void initState() {
    if(controller1.dropDownValue == null){
      flag1=true;
      setState(() {});
    }
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
                dropField(context, "City", citiesList, controller1, true,true),
                dropField(context, "Metro Station", metroStationsList,
                    controller2, false,flag1 ?? false),
                dropField(context, "Gate", gateList, controller3, false,flag1 ?? false),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: FloatingActionButton.extended(
            elevation: 0,
            focusElevation: 0,
            hoverElevation: 0,
            highlightElevation: 0,
            disabledElevation: 0,
            onPressed: () async {
              if(_formkey.currentState!.validate()){
                cityName=controller1.dropDownValue!.value;
                stationName=controller2.dropDownValue!.value;
                gateName=controller3.dropDownValue!.value;
                setState(() {});
                isNull=flag;
                Navigator.pop(context);
                snackBar(context, Colors.green, "Data Saved...");}
              setState(() {
              });
            },
            label: Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                  color: c1, borderRadius: BorderRadius.circular(20)),
              child: const Center(
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )),
            ),
          ),
        ),
      ),
    );
  }

  dropField(context, String lable, List<DropDownValueModel> items,
      SingleValueDropDownController controller, bool condition,bool flag) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropDownTextField(
          onChanged: (value) async {
            isLoading=false;
            flag1=true;
            setState(() {});
            if (condition) {
              if (controller1.dropDownValue!.value.toString() == "Ahmedabad") {
                loading(context,isLoading);
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
          isEnabled: flag,
          clearOption: false,
          controller: controller,
          dropDownItemCount: 5,
          dropDownList: items,
          dropdownRadius: 0,
          textFieldDecoration: InputDecoration(
            labelStyle: TextStyle(color: flag ? Colors.black54:Colors.black12),
            labelText: lable,
            disabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black12,
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
                color: Colors.red,
              ),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black45),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

}
