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

class EditHabit extends StatefulWidget {
  final Habit habit;
  final DatabaseUser user;
  final DatabaseService dbService;
  const EditHabit({
    super.key,
    required this.habit,
    required this.user,
    required this.dbService,
  });

  @override
  State<EditHabit> createState() => _EditHabitState();
}

class _EditHabitState extends State<EditHabit> {
  late TextEditingController _controllerName;
  late TextEditingController _controllerNote;
  late String name = widget.habit.name;
  late String note = widget.habit.note;
  late String selectedDays = widget.habit.daysToDo;
  late String iconName = widget.habit.iconName;
  late IconData? selectedIcon = myCustomIcons[iconName]!.data;
  late DateTime notificationTime = widget.habit.notificationTime.toDate();
  late List<Timestamp> daysDone = widget.habit.daysDone;
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
    convertSelectedDaysToIsDaySelected();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          ],
        ),
      ),
      appBar: _appbarEditHabit(),
    );
  }

  AppBar _appbarEditHabit() {
    return AppBar(
      title: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: Text(
            "Editing habit",
            style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      centerTitle: true,
      toolbarHeight: 80.0,
      leading: _editHabitLeading(),
    );
  }

  Padding _editHabitLeading() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: primary, size: 30.0),
        onPressed: () {
          // Updates the habit by finding it by positionIndex
          // TODO: Insta update in edit_body
          for (int i = 0; i < widget.user.habitsInClass.length; i++) {
            if (widget.user.habitsInClass[i].positionIndex ==
                widget.habit.positionIndex) {
              widget.user.habitsInClass[i] = Habit(
                name: _controllerName.text,
                note: _controllerNote.text,
                daysToDo: convertIsDaySelectedToSelectedDays(),
                iconName: iconName,
                notificationTime: Timestamp.fromDate(notificationTime),
                daysDone: daysDone,
                positionIndex: widget.habit.positionIndex,
              );
              widget.dbService.updateUser(widget.user);
              break;
            }
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(visit: 1, dbUser: widget.user),
            ),
          );
        },
      ),
    );
  }

  ElevatedButton _notificationTimeSelect(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        TimeOfDay initial =
            notificationTime == DateTime(2007, 6, 12, 0, 0, 0)
                ? TimeOfDay.now()
                : TimeOfDay.fromDateTime(notificationTime);
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
                        color: cRed.withValues(alpha: 0.8),
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
        shape: const WidgetStatePropertyAll(
          CircleBorder(eccentricity: 0, side: BorderSide.none),
        ),
        backgroundColor: WidgetStatePropertyAll(
          isDaySelected[i - 1]
              ? secondary.withValues(alpha: 0.5)
              : tertiary.withValues(alpha: 0.3),
        ),
        padding: const WidgetStatePropertyAll(EdgeInsets.all(15.0)),
      ),
      child: Text(
        daysMap[i]!.substring(0, 3),
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  String convertIsDaySelectedToSelectedDays() {
    selectedDays = "";
    for (int i = 0; i < 7; i++) {
      if (isDaySelected[i]) {
        selectedDays += "${i + 1},";
      }
    }
    if (selectedDays != "") {
      selectedDays = selectedDays.substring(0, selectedDays.length - 1);
      return selectedDays;
    }
    return "";
  }

  void convertSelectedDaysToIsDaySelected() {
    for (int i = 1; i <= 7; i++) {
      if (selectedDays.contains("$i")) {
        isDaySelected[i - 1] = true;
      }
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
                fillColor: secondary..withValues(alpha: 0.4),
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
              fillColor: secondary..withValues(alpha: 0.4),
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
