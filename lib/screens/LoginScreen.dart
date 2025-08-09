import 'package:flutter/material.dart';
import 'package:comsats_hero/theme/Colors.dart';
import 'package:provider/provider.dart';
import '../services/FireBaseAuth.dart';

class SignningWidget extends StatefulWidget {
  const SignningWidget({Key? key}) : super(key: key);

  @override
  _SignningWidgetState createState() => _SignningWidgetState();
}

class _SignningWidgetState extends State<SignningWidget> with SingleTickerProviderStateMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final myColors = Provider.of<MyColors>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: myColors.backgroundColor,
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return ClipPath(
                clipper: WaveClipper(animationValue: _controller.value),
                child: Container(
                  height: size.height * 0.3, // Adapts to 30% of the screen height
                  color: myColors.primaryColorLight,
                ),
              );
            },
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04), // Padding adapts to screen width
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    "HELLO",
                    style: TextStyle(
                      color: myColors.primaryColorLight,
                      fontSize: size.width * 0.09, // Adapts to screen width
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "not all heroes wear capes, some help you with papers",
                    style: TextStyle(
                      color: myColors.black,
                      fontSize: size.width * 0.04, // Dynamic font size
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: size.height * 0.05),
                  Image.asset('assets/login.png', height: size.height * 0.25), // Dynamic image size
                  SizedBox(height: size.height * 0.05),
                  ElevatedButton(
                    onPressed: () async {
                      await MyFireBaseAuth.signInWithGoogle(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: myColors.primaryColorLight,
                      minimumSize: Size(double.infinity, size.height * 0.07), // Dynamic button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      textStyle: TextStyle(
                        fontSize: size.width * 0.04, // Dynamic font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/google_icon.png', height: size.height * 0.03), // Dynamic icon size
                        SizedBox(width: size.width * 0.02),
                        Text("Sign In with Google"),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Facebook sign-in will be added later')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize: Size(double.infinity, size.height * 0.07), // Dynamic button size
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      textStyle: TextStyle(
                        fontSize: size.width * 0.04, // Dynamic font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('assets/facebook_icon.png', height: size.height * 0.03), // Dynamic icon size
                        SizedBox(width: size.width * 0.02),
                        Text("Sign In with Facebook"),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animationValue;

  WaveClipper({required this.animationValue});

  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 40);
    var firstControlPoint = Offset(size.width / 4, size.height + 30 * animationValue);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 90 - 30 * animationValue);
    var secondEndPoint = Offset(size.width, size.height - 60);

    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
