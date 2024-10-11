import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/icon_picker_icon.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/models/habit.dart';
import 'package:habbit_app/widgets/toast.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  late TextEditingController _controllerName;
  late String name = "";
  late String selectedDays = "";
  late List<int> alreadySelected = [];
  late int iconIndex;
  late IconData? selectedIcon = null;

  static final List<Map<int, String>> days = [
    //Getting brain damage from this, but dont want to make it look normal
    {1: "Monday"},
    {2: "Tuesday"},
    {3: "Wednesday"},
    {4: "Thursday"},
    {5: "Friday"},
    {6: "Saturday"},
    {7: "Sunday"}
  ];
  static List<MultiSelectItem<int>> daysItems = [];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controllerName = TextEditingController(text: name);

    daysItems = days.map((day) {
      final key = day.keys.first;
      final value = day.values.first;
      return MultiSelectItem<int>(key, value);
    }).toList();
  }

  void _createHabitFunc() {
    if (_controllerName.text.length > 22) {
      // Name too long
      showToast("Name is too long, make it under 22 characters");
      // TODO: Else if (at least 1 day has to be chosen, There must be selected icon, selected category)
    } else {
      // Get back to edit page and create new habit, that will be added to user and then into database
      showToast("Everything is alright.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _nameField(),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
              onPressed: () => _daySelect(context),
              child: const Text(
                "Select days",
                style: TextStyle(fontSize: 24),
              )),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
            onPressed: () => _selectIcon(context),
            child: selectedIcon == null
                ? const Text("Choose icon", style: TextStyle(fontSize: 24))
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Selected icon: ",
                        style: TextStyle(fontSize: 24),
                      ),
                      Icon(selectedIcon, size: 40),
                    ],
                  ),
          ),
          // Select icon and save iconIndex
          // Note
          // Select category: Morning, Afternoon, Evening
          // Notification time
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
              onPressed: _createHabitFunc, child: const Text("Create Habit"))
        ],
      ),
    );
  }

  void _daySelect(BuildContext context) async {
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (ctx) {
          return MultiSelectBottomSheet(
            title: const Text("Select days:"),
            items: daysItems,
            initialValue: alreadySelected,
            onConfirm: (values) {
              selectedDays = "";
              alreadySelected.clear();

              List<int> intValues = values.cast<int>();
              intValues.sort();
              if (values.isEmpty) {
                return;
              }
              for (int value in intValues) {
                selectedDays += "$value,";
                alreadySelected.add(value);
              }
              if (selectedDays.isNotEmpty) {
                selectedDays =
                    selectedDays.substring(0, selectedDays.length - 1);
                print(selectedDays);
              }
            },
            minChildSize: 0.2,
            maxChildSize: 0.8,
          );
        });
  }

  void _selectIcon(BuildContext context) async {
    selectedIcon = await showIconPicker(
      context,
      showSearchBar: false,
      iconColor: primary,
      iconPickerShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      iconPackModes: [IconPack.custom],
      //TODO create own IconPack, implement maybe that in db will be saved icon code (or name that will be saved in that list - that actually make more sense), it will be easier to work with it
    );

    setState(() {});
  }

  AppBar _appBar() {
    return AppBar(
      title: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "New Habbit",
            style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      centerTitle: true,
      toolbarHeight: 80.0,
    );
  }

  Padding _nameField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Habit name",
            style: TextStyle(
                color: primary, fontWeight: FontWeight.normal, fontSize: 20.0),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _controllerName,
            obscureText: false,
            decoration: InputDecoration(
                filled: true,
                fillColor: secondary.withOpacity(0.4),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10))),
            style: TextStyle(
                color: primary, fontWeight: FontWeight.normal, fontSize: 20.0),
          )
        ],
      ),
    );
  }
}
