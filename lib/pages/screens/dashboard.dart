import 'package:design/app_colors.dart';
import 'package:design/utils/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// ignore: unused_import
import 'package:location/location.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .refFromURL('https://sigfox-4a13d-default-rtdb.firebaseio.com')
      .child('WiFi_Devices')
      .child('AE01')
      .child('Last Update');
  final User? user = FirebaseAuth.instance.currentUser;

  String? selectedValue;
  List<String> listItem = ['Device 1', 'Device 2', 'Device 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.textfields.withOpacity(0.3),
      drawer: Drawer(
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.textfields.withOpacity(0.3),
              ),
              child: const Text(
                'Hey \n\nUsername!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'My Farm',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.myfarmRoute);
              },
            ),
            ListTile(
              title: const Text(
                'My Devices',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pushNamed(context, MyRoutes.mydevicesRoute);
              },
            ),
            ListTile(
              title: const Text(
                'History',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Add your logic for handling item 1 tap
              },
            ),
            ListTile(
              title: const Text(
                'Settings',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                // Add your logic for handling item 1 tap
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 60,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              color: Colors.black,
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Open the drawer
              },
              icon: const Icon(Icons.menu),
            );
          },
        ),
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 75),
          child: Text(
            'AigroCare',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            color: Colors.black,
            onPressed: () {},
            icon: const Icon(Icons.notifications),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.textfields.withOpacity(0.3),
              ),
              width: double.infinity,
              height: 140,
              child: const Padding(
                padding: EdgeInsets.only(top: 20, left: 35),
                child: Column(
                  children: [Row()],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                //Navigator.pushNamed(context, MyRoutes.mycropsRoute);
              },
              child: Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.darkgreen, AppColors.textfields],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.darkgreen,
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: Colors.white,
                          value: selectedValue,
                          hint: const Text(
                            'Select Device',
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ), // Optional: Text to display when no option is selected
                          onChanged: (newValue) {
                            setState(() {
                              selectedValue = newValue;
                            });
                          },

                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          items: listItem.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: const TextStyle(color: Colors.black)),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(
                        width: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 0, right: 20),
                child: StreamBuilder(
                  stream: databaseReference.onValue,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data!.snapshot.value;
                      final epochTime = data != null &&
                              (data as Map<dynamic, dynamic>)['DT'] != null
                          ? int.parse((data)['DT'].toString())
                          : null;

                      String formattedDateTime = '';
                      if (epochTime != null) {
                        final dateTime =
                            DateTime.fromMillisecondsSinceEpoch(epochTime);
                        formattedDateTime = dateTime.toString();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(right: 100),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 45),
                              child: Text(
                                "Device Updates",
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2),
                              child: Text(
                                'Last updated on: $formattedDateTime',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                )),
            const SizedBox(
              height: 0,
            ),
            Expanded(
              child: buildWidget(context),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildWidget(BuildContext context) {
  final DatabaseReference databaseReference = FirebaseDatabase.instance
      .refFromURL('https://sigfox-4a13d-default-rtdb.firebaseio.com')
      .child('WiFi_Devices')
      .child('AE01')
      .child('Last Update');

  return StreamBuilder(
    stream: databaseReference.onValue,
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        // ignore: unused_local_variable
        final data = snapshot.data!.snapshot.value;

        return SizedBox(
          height: 360,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.textfields.withOpacity(0.3),
                        boxShadow: [
                          //bottom left shadow - darker
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 1),
                          //top left shadow - lighter
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1),
                        ],
                      ),
                      child: SizedBox(
                        height: 165,
                        width: 165,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, right: 80),
                          child: Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15, left: 82),
                                child: StreamBuilder(
                                  stream: databaseReference.onValue,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data =
                                          snapshot.data!.snapshot.value;
                                      final batteryData = data != null &&
                                              (data as Map<dynamic, dynamic>)[
                                                      'BT'] !=
                                                  null
                                          ? data['BT'].toString()
                                          : '';

                                      return CircularPercentIndicator(
                                        radius: 55,
                                        lineWidth: 9,
                                        percent: data != null
                                            ? (double.tryParse(batteryData) ??
                                                    0.0) /
                                                100.0
                                            : 0.0,
                                        progressColor: AppColors.darkgreen,
                                        backgroundColor: Colors.white,
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        center: Center(
                                          child: Text(
                                            '$batteryData%',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.darkgreen,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.textfields.withOpacity(0.3),
                        boxShadow: [
                          //bottom left shadow - darker
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 1),
                          //top left shadow - lighter
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1),
                        ],
                      ),
                      child: SizedBox(
                        height: 165,
                        width: 165,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: StreamBuilder(
                            stream: databaseReference.onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!.snapshot.value;
                                final soilPH = data != null
                                    ? (data as Map<dynamic, dynamic>)['PH']
                                    : '';

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Soil pH:',
                                      style: TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15, left: 5),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            'assets/images/ph-meter.png',
                                            height: 60,
                                            width: 35,
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            soilPH,
                                            style: const TextStyle(
                                              fontSize: 35,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.textfields.withOpacity(0.3),
                        boxShadow: [
                          //bottom left shadow - darker
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 1),
                          //top left shadow - lighter
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1),
                        ],
                      ),
                      child: SizedBox(
                        height: 165,
                        width: 165,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: StreamBuilder(
                            stream: databaseReference.onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!.snapshot.value;
                                final soilTemperature = data != null
                                    ? (data as Map<dynamic, dynamic>)['ST']
                                        as String
                                    : '';

                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Soil Temperature:',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 5),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/soiltemp.png',
                                                  height: 60,
                                                  width: 40,
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  soilTemperature,
                                                  style: const TextStyle(
                                                    fontSize: 35,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.textfields.withOpacity(0.3),
                        boxShadow: [
                          //bottom left shadow - darker
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 1),
                          //top left shadow - lighter
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1),
                        ],
                      ),
                      child: SizedBox(
                        height: 165,
                        width: 165,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: StreamBuilder(
                            stream: databaseReference.onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!.snapshot.value;
                                final soilMoisture = data != null
                                    ? (data as Map<dynamic, dynamic>)['SM']
                                        as String
                                    : '';

                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Soil Moisture:',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15, left: 5),
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/images/moisture.png',
                                                  height: 60,
                                                  width: 45,
                                                ),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                Text(
                                                  soilMoisture,
                                                  style: const TextStyle(
                                                    fontSize: 35,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.textfields.withOpacity(0.3),
                        boxShadow: [
                          //bottom left shadow - darker
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 1),
                          //top left shadow - lighter
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1),
                        ],
                      ),
                      child: SizedBox(
                        height: 165,
                        width: 165,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: StreamBuilder(
                            stream: databaseReference.onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!.snapshot.value;
                                final electricalConductivity = data != null
                                    ? (data as Map<dynamic, dynamic>)['EC']
                                        as String
                                    : '';

                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Electrical \nConductivity:',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 35, left: 35),
                                            child: Text(
                                              electricalConductivity,
                                              style: const TextStyle(
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.textfields.withOpacity(0.3),
                        boxShadow: [
                          //bottom left shadow - darker
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 1),
                          //top left shadow - lighter
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1),
                        ],
                      ),
                      child: SizedBox(
                        height: 165,
                        width: 165,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: StreamBuilder(
                            stream: databaseReference.onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!.snapshot.value;
                                final epochTime = data != null &&
                                        (data as Map<dynamic, dynamic>)['DT'] !=
                                            null
                                    ? (data)['T'].toString()
                                    : '';

                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Ambient\nTemperature:',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 35, left: 5),
                                            child: Text(
                                              epochTime,
                                              style: const TextStyle(
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.textfields.withOpacity(0.3),
                        boxShadow: [
                          //bottom left shadow - darker
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 1),
                          //top left shadow - lighter
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1),
                        ],
                      ),
                      child: SizedBox(
                        height: 165,
                        width: 165,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: StreamBuilder(
                            stream: databaseReference.onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!.snapshot.value;
                                final humidity = data != null &&
                                        (data as Map<dynamic, dynamic>)['H'] !=
                                            null
                                    ? data['H'].toString()
                                    : '';

                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Humidity:',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 35, left: 35),
                                            child: Text(
                                              humidity,
                                              style: const TextStyle(
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColors.textfields.withOpacity(0.3),
                        boxShadow: [
                          //bottom left shadow - darker
                          BoxShadow(
                              color: Colors.grey.shade400,
                              offset: const Offset(2, 2),
                              blurRadius: 4,
                              spreadRadius: 1),
                          //top left shadow - lighter
                          const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-2, -2),
                              blurRadius: 3,
                              spreadRadius: 1),
                        ],
                      ),
                      child: SizedBox(
                        height: 165,
                        width: 165,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 15, left: 15),
                          child: StreamBuilder(
                            stream: databaseReference.onValue,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data!.snapshot.value;
                                final lightIntensity = data != null &&
                                        (data as Map<dynamic, dynamic>)['LI'] !=
                                            null
                                    ? data['LI'].toString()
                                    : '';

                                return Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            'Lite Intensity:',
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 35, left: 35),
                                            child: Text(
                                              lightIntensity,
                                              style: const TextStyle(
                                                fontSize: 35,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                return const CircularProgressIndicator();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}
