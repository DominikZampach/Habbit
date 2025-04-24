import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/custom_icons.dart';
import 'package:habbit_app/models/database_user.dart';
import 'package:habbit_app/models/habit.dart';
import 'package:habbit_app/pages/home.dart';
import 'package:habbit_app/services/database.dart';
import 'package:habbit_app/widgets/toast.dart';

class AddHabitPage extends StatefulWidget {
  final DatabaseService dbService;
  final DatabaseUser? dbUser;

  const AddHabitPage({
    super.key,
    required this.dbService,
    required this.dbUser,
  });

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
  late DateTime? notificationTime = null;
  late IconData? selectedIcon = null;
  late List<bool> isDaySelected = [for (int i = 0; i < 7; i++) false];

  static final Map<int, String> daysMap = {
    1: "Monday",
    2: "Tuesday",
    3: "Wednesday",
    4: "Thursday",
    5: "Friday",
    6: "Saturday",
    7: "Sunday",
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
      widget.dbUser!.habitsInClass.add(
        Habit(
          name: _controllerName.text,
          note: _controllerNote.text,
          iconName: iconName,
          daysToDo: selectedDays,
          daysDone: [],
          positionIndex: widget.dbUser!.habitsInClass.length,
          notificationTime:
              notificationTime != null
                  ? Timestamp.fromDate(notificationTime!)
                  : Timestamp.fromDate(DateTime(2007, 6, 12, 0, 0, 0)),
        ),
      );
      widget.dbService.updateUser(widget.dbUser!);
      setState(() {});
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
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
              children: [_showIconPickerIcon(context), _nameField()],
            ),
            const SizedBox(height: 20),
            _daySelect(context),
            _noteField(),
            const SizedBox(height: 20.0),
            _notificationTimeSelect(context),
            const SizedBox(height: 20.0),
            // TODO: Edit this Create habit button
            _createHabitButton(),
          ],
        ),
      ),
    );
  }

  // TODO: Change design
  ElevatedButton _createHabitButton() {
    return ElevatedButton(
      onPressed: _createHabitFunc,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(secondary.withOpacity(0.5)),
      ),
      child: const Text(
        "Create Habit",
        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
      ),
    );
  }

  ElevatedButton _notificationTimeSelect(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        TimeOfDay initial =
            notificationTime == null
                ? TimeOfDay.now()
                : TimeOfDay.fromDateTime(notificationTime!);
        final TimeOfDay? time = await showTimePicker(
          context: context,
          initialTime: initial,
        );
        if (time != null) {
          notificationTime = DateTime(
            2024,
            DateTime.august,
            1,
            time.hour,
            time.minute,
            0,
            0,
            0,
          ); // Set to August 1. 2024 for unity all over
          setState(() {});
          //print(notificationTime.toString());
        }
      },
      child: Text(
        "Notification time",
        style: TextStyle(
          color: primary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () => _selectIcon(context),
              child:
                  selectedIcon == null
                      ? Icon(
                        Icons.add_circle_rounded,
                        size: 60,
                        color: cRed.withOpacity(0.8),
                      )
                      : Icon(selectedIcon!, size: 60, color: primary),
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
          children: [for (int i = 1; i < 5; i++) _dayButton(i)],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [for (int i = 5; i < 8; i++) _dayButton(i)],
        ),
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
          CircleBorder(eccentricity: 0, side: BorderSide.none),
        ),
        backgroundColor: MaterialStatePropertyAll(
          isDaySelected[i - 1]
              ? secondary.withOpacity(0.5)
              : tertiary.withOpacity(0.3),
        ),
        padding: const MaterialStatePropertyAll(EdgeInsets.all(15.0)),
      ),
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
        selectedDays += "${i + 1},";
      }
    }
    if (selectedDays != "") {
      selectedDays = selectedDays.substring(0, selectedDays.length - 1);
    }
  }

  void _selectIcon(BuildContext context) async {
    IconPickerIcon? newSelectedIcon = await showIconPicker(
      context,
      configuration: SinglePickerConfiguration(
        showSearchBar: false,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        showTooltips: true,
        iconSize: 55,
        iconColor: primary,
        iconPickerShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: BorderSide(color: primary, width: 0.5),
        ),
        iconPackModes: [IconPack.custom],
        customIconPack: myCustomIcons,
        barrierDismissible: false,
        title: Text('Pick an icon', style: TextStyle(color: primary)),
      ),
    );

    if (newSelectedIcon != null && newSelectedIcon.data != selectedIcon) {
      selectedIcon = newSelectedIcon.data;
      Iterable<String> myCustomIconsKeys = myCustomIcons.keys;
      for (var key in myCustomIconsKeys) {
        if (myCustomIcons[key]!.data == selectedIcon!) {
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
      leading: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: primary, size: 30.0),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
                fontSize: 20.0,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controllerName,
              obscureText: false,
              decoration: InputDecoration(
                filled: true,
                fillColor: secondary.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              style: TextStyle(
                color: primary,
                fontWeight: FontWeight.normal,
                fontSize: 20.0,
              ),
            ),
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
              color: primary,
              fontWeight: FontWeight.normal,
              fontSize: 20.0,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _controllerNote,
            obscureText: false,
            maxLines: 2,
            decoration: InputDecoration(
              filled: true,
              fillColor: secondary.withOpacity(0.4),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            style: TextStyle(
              color: primary,
              fontWeight: FontWeight.normal,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
