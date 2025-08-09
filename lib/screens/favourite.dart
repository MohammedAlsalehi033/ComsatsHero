import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

import '../theme/Colors.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {

  Future<void> isInstalled() async {
    // Removed whatsapp_share functionality
    // (Functionality disabled)
  }

  Future<void> share() async {
    // Removed whatsapp_share functionality
    // (Functionality disabled)
  }





  @override
  Widget build(BuildContext context) {

    final myColors = Provider.of<MyColors>(context);

    return Scaffold(appBar: AppBar(),
      body: Column(
        children: [ElevatedButton(onPressed: ()async{/* whatsapp_share removed */ }, child: Text("sdafasdf")),

          Text("just testing for now"),
          Container(alignment: Alignment.bottomCenter,
            height: Material.defaultSplashRadius,
            child: WaveWidget(
              config: CustomConfig(
                colors: [
                  myColors.primaryColorLight,
                  myColors.primaryColor,


                ],
                durations: [
                  5000,
                  3000,

                ],
                heightPercentages: [
                  0.2,
                  0.5,

                ],
              ),
              size: Size(double.infinity, 100.0),
              waveAmplitude: 0,
            ),
          ),
        ],
      ),
    );
  }
}
