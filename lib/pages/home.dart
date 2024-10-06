import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:habbit_app/const.dart';
import 'package:habbit_app/models/database_user.dart';
import 'package:habbit_app/pages/bodies/edit_body.dart';
import 'package:habbit_app/pages/bodies/home_body.dart';
import 'package:habbit_app/pages/bodies/settings_body.dart';
import 'package:habbit_app/services/auth.dart';
import 'package:habbit_app/services/database.dart';
import 'package:habbit_app/widgets/kralicek.dart';
import 'package:intl/intl.dart';

const List<TabItem> navbarItems = [
  TabItem(icon: Icons.home, title: "Home"),
  TabItem(icon: Icons.edit, title: "Edit"),
  TabItem(icon: Icons.settings, title: "Settings"),
  //TabItem(icon: Icons.account_circle, title: "Account"),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int visit = 0;
  DatabaseUser? dbUser;

  final User? user = AuthService().currentUser;

  late bool isCalendarShown;
  late DatabaseService databaseService;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    databaseService = DatabaseService();
    isCalendarShown = false;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      DatabaseUser? loadDbUser = await databaseService.getUser(user!.uid);
      if (context.mounted) {
        setState(() {
          dbUser = loadDbUser;
        }); // Trigger a rebuild to update the UI with the loaded data
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> signOut() async {
    await AuthService().signOut(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: selectAppBar(),
      bottomNavigationBar: navbar(),
      body: renderSelectedBody(),
    );
  }

  BottomBarDefault navbar() {
    return BottomBarDefault(
        items: navbarItems,
        backgroundColor: tertiary,
        color: primary.withOpacity(.5),
        colorSelected: primary,
        indexSelected: visit,
        paddingVertical: 16.0,
        iconSize: 38.0,
        pad: 0,
        titleStyle:
            const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
        enableShadow: false,
        onTap: (index) => setState(
              () {
                visit = index;
              },
            ));
  }

  AppBar _appBarHome() {
    return AppBar(
      title: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            getTitleDate(),
            style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      centerTitle: true,
      toolbarHeight: 80.0,
      leading: const Kralicek(height: 80.0, padding: 15.0),
      leadingWidth: 90.0,
      actions: [_calendarIcon()],
      flexibleSpace: const SizedBox(height: 5.0),
      bottom: PreferredSize(
        preferredSize: isCalendarShown
            ? const Size.fromHeight(90.0)
            : const Size.fromHeight(0.0),
        child: Placeholder(
          fallbackHeight: isCalendarShown ? 90.0 : 0.0,
          color: isCalendarShown ? Colors.green : Colors.red,
        ),
      ),
    );
  }

  AppBar _appBarOthers() {
    return AppBar(
      title: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            navbarItems[visit].title!,
            style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      centerTitle: true,
      toolbarHeight: 80.0,
      leading: const Kralicek(height: 80.0, padding: 15.0),
      leadingWidth: 90.0,
    );
  }

  GestureDetector _calendarIcon() {
    return GestureDetector(
      child: const Padding(
        padding: EdgeInsets.all(15.0),
        child: Icon(Icons.calendar_month, weight: 0.5, size: 55.0),
      ),
      onTap: () {
        print("Clicked on calendar");
        setState(() {
          isCalendarShown = !isCalendarShown;
        });
      },
    );
  }

  String getTitleDate() {
    DateTime now = DateTime.now();
    String day = DateFormat('EEE, d.M.').format(now);
    return day;
  }

  Widget renderSelectedBody() {
    if (visit == 0 && dbUser == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (visit == 0) {
      // Home
      return HomeBody(dbUser: dbUser, dbService: databaseService);
    } else if (visit == 1) {
      // Edit page
      return const EditBody();
    } else if (visit == 2) {
      // Settings page
      return SettingsBody();
    } else {
      return const Text(
        "Error",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
      );
    }
  }

  AppBar selectAppBar() {
    if (visit == 0) {
      return _appBarHome();
    } else {
      return _appBarOthers();
    }
  }

  SizedBox testDB() {
    return SizedBox(
      width: 500,
      height: 800,
      child: FutureBuilder(
          future: databaseService.getUser(user!.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('User not found'));
            } else {
              DatabaseUser userData = snapshot.data!;
              return ListView.builder(
                  itemCount: userData.habitsInClass.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                        title: Text(userData.habitsInClass[index].name));
                  }));
            }
          }),
    );
  }
}
