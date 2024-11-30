import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/custom_icons.dart';
import 'package:habbit_app/widgets/toast.dart';

enum Categories { morning, afternoon, evening }

class AddHabitPage extends StatefulWidget {
  const AddHabitPage({super.key});

  @override
  State<AddHabitPage> createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  late TextEditingController _controllerName;
  late TextEditingController _controllerNote;
  late String name = "";
  late String note = "";
  late String selectedDays = "";
  late String iconName = "";
  late DateTime notificationTime;
  late IconData? selectedIcon = null;
  late Categories? selectedCategory = Categories.morning;
  late List<bool> isDaySelected = [for (int i = 0; i < 7; i++) false];

  static final Map<int, String> daysMap = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday"
  };

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerNote.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controllerName = TextEditingController(text: name);
    _controllerNote = TextEditingController(text: note);
  }

  void _createHabitFunc() {
    convertIsDaySelectedToSelectedDays();
    if (_controllerName.text.length > 22) {
      showToast("Name is too long, make it under 22 characters");
    } else if (_controllerName.text.isEmpty) {
      showToast("You must enter habit name");
    } else if (selectedIcon == null) {
      showToast("You must choose an icon");
    } else if (selectedDays == "") {
      showToast("You must choose at least 1 day");
    } else {
      //TODO: Get back to edit page and create new habit, that will be added to user and then into database
      showToast("Everything is alright");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _showIconPickerIcon(context),
                _nameField(),
              ],
            ),
            const SizedBox(height: 20),
            _daySelect(context),
            _noteField(),
            const SizedBox(height: 10.0),
            _categorySelect(),
            //TODO: Notification time
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: _createHabitFunc, child: const Text("Create Habit"))
          ],
        ),
      ),
    );
  }

  Padding _categorySelect() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Category",
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.normal,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: RadioListTile.adaptive(
                  value: Categories.morning,
                  groupValue: selectedCategory,
                  onChanged: (Categories? value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  title: const Text(
                    "Morning",
                    style: TextStyle(fontSize: 12.0),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                ),
              ),
              Expanded(
                child: RadioListTile.adaptive(
                  value: Categories.afternoon,
                  groupValue: selectedCategory,
                  onChanged: (Categories? value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  title: const Text(
                    "Afternoon",
                    style: TextStyle(fontSize: 12.0),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                ),
              ),
              Expanded(
                child: RadioListTile.adaptive(
                  value: Categories.evening,
                  groupValue: selectedCategory,
                  onChanged: (Categories? value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  title: const Text(
                    "Evening",
                    style: TextStyle(fontSize: 12.0),
                  ),
                  contentPadding: const EdgeInsets.all(0),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Flexible _showIconPickerIcon(BuildContext context) {
    return Flexible(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            GestureDetector(
              onTap: () => _selectIcon(context),
              child: selectedIcon == null
                  ? Icon(
                      Icons.add_circle_rounded,
                      size: 60,
                      color: cRed.withOpacity(0.8),
                    )
                  : Icon(
                      selectedIcon!,
                      size: 60,
                      color: primary,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _daySelect(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 1; i < 5; i++) _dayButton(i),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 5; i < 8; i++) _dayButton(i),
          ],
        )
      ],
    );
  }

  TextButton _dayButton(int i) {
    return TextButton(
      onPressed: () {
        isDaySelected[i - 1] = !isDaySelected[i - 1];
        setState(() {});
      },
      style: ButtonStyle(
          shape: const MaterialStatePropertyAll(
              CircleBorder(eccentricity: 0, side: BorderSide.none)),
          backgroundColor: MaterialStatePropertyAll(isDaySelected[i - 1]
              ? secondary.withOpacity(0.5)
              : tertiary.withOpacity(0.3)),
          padding: const MaterialStatePropertyAll(EdgeInsets.all(15.0))),
      child: Text(
        daysMap[i]!.substring(0, 3),
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  void convertIsDaySelectedToSelectedDays() {
    selectedDays = "";
    for (int i = 0; i < 7; i++) {
      if (isDaySelected[i]) {
        selectedDays += "$i,";
      }
    }
    if (selectedDays != "") {
      selectedDays = selectedDays.substring(0, selectedDays.length - 1);
    }
  }

  void _selectIcon(BuildContext context) async {
    IconData? newSelectedIcon = await showIconPicker(
      context,
      showSearchBar: false,
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      showTooltips: true,
      iconSize: 55,
      iconColor: primary,
      iconPickerShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: primary, width: 0.5)),
      iconPackModes: [IconPack.custom],
      customIconPack: myCustomIcons,
      barrierDismissible: false,
      title: Text(
        'Pick an icon',
        style: TextStyle(color: primary),
      ),
    );

    if (newSelectedIcon != null && newSelectedIcon != selectedIcon) {
      selectedIcon = newSelectedIcon;
      Iterable<String> myCustomIconsKeys = myCustomIcons.keys;
      for (var key in myCustomIconsKeys) {
        if (myCustomIcons[key] == selectedIcon!) {
          iconName = key;
          break;
        }
      }
      print("iconName: $iconName");
      setState(() {});
    }
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

  Flexible _nameField() {
    return Flexible(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Habit name",
              style: TextStyle(
                  color: primary,
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0),
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
                  color: primary,
                  fontWeight: FontWeight.normal,
                  fontSize: 20.0),
            )
          ],
        ),
      ),
    );
  }

  Padding _noteField() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 15.0, right: 15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Note",
            style: TextStyle(
                color: primary, fontWeight: FontWeight.normal, fontSize: 20.0),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            controller: _controllerNote,
            obscureText: false,
            maxLines: 2,
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
