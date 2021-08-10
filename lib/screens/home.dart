import '../widgets/drawerClass.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        height: _height,
        child: Stack(
          children: [
            Container(
              height: _height * 0.8,
              alignment: Alignment.topCenter,
              child: const GoogleMap(
                myLocationButtonEnabled: false,
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.42796133580664, -122.085749655962),
                  zoom: 14.4746,
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          padding: const EdgeInsets.only(
                              left: 10, right: 20, top: 20),
                          child: Column(
                            children: [
                              const TextField(
                                  decoration: InputDecoration(
                                hintText: 'Hamitkoy, lefkosa, cyprus',
                                labelText: 'Where are you going to?',
                                hintStyle: TextStyle(fontSize: 18),
                                labelStyle: TextStyle(fontSize: 18),
                                icon: Icon(Icons.location_searching_rounded),
                              )),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  //    Image.asset('../../assets/images/solanCar.png')
                                ],
                              )
                            ],
                          ),
                        );
                      });
                },
                child: Container(
                  height: _height * 0.13,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const DrawerClass(),
    );
  }
}
