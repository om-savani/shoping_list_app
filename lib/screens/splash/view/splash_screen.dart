import '../../../headers.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed('/home');
    });
    return const Scaffold(
      body: Center(
        child: Text("Shoping List"),
      ),
    );
  }
}
