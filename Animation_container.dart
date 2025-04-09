import 'package:flutter/material.dart'; // this package provide widgets and styling
// for building ui components.


// Entry point for the flutter app.It launches the app with MyApp().
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: SquareAnimation(),// Set SquareAnimation as A first screen
    ); //Root widget
  }
}

// For adding animation we have to use Stateful widget because ui will change dynamically square moving from one place to another.
class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  _SquareAnimationState createState() => _SquareAnimationState();
}

class _SquareAnimationState extends State<SquareAnimation> {
  double _position = 0.5; // 0.0 (Left) to 1.0 (Right)
  bool _isAnimating = false; // preventing multiple animation running at sametime.

  void _moveSquare(bool toRight) {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
    });

    double targetPosition = toRight ? 1.0 : 0.0;

    // Start animation
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _position = targetPosition;
          _isAnimating = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;// Getting the screen width
    double squareSize = 50.0;// Set the size of moving square
    double minX = 20.0; // Left edge margin
    double maxX = screenWidth - squareSize - 20.0; // Right edge margin

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // It is used to animate square movement smoothly
                AnimatedPositioned(
                  duration: const Duration(seconds: 1),// time taken by animation to complete
                  left: minX + (_position * (maxX - minX)),// calculate the square horizontal position
                  child: Container(
                    width: squareSize,
                    height: squareSize,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: (!_isAnimating && _position > 0.0)
                      ? () => _moveSquare(false) // Re-enables the button and animation
                      : null,
                     //Moves the square left (_position > 0.0 ensures it isn't already at the left edge).
                     //Disables the button (null) when the animation is running or at the left edge.
                  child: const Text("To Left"),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: (!_isAnimating && _position < 1.0)
                      ? () => _moveSquare(true)
                      : null,
                //Moves the square right (_position < 1.0 ensures it isn't already at the right edge).
                //Disables the button (null) when the animation is running or at the right edge.
                  child: const Text("To Right"),
                ),
              ],
            ),
          ),
        ],
      ),
    );// Provides tha app structure(AppBar,Body etc)
  }
}
