import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String output = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Expanded(
              child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                output,
                style: const TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          )),
          Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 175, 16, 215),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                )),
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getButton("AC"),
                        getButton("%"),
                        getButton("Q"),
                        getButton("/"),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getButton("7"),
                        getButton("8"),
                        getButton("9"),
                        getButton("*"),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getButton(
                          "4",
                        ),
                        getButton("5"),
                        getButton("6"),
                        getButton("￣"),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getButton("1"),
                        getButton("2"),
                        getButton("3"),
                        getButton("+"),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        getButton(
                          "00",
                        ),
                        getButton("0"),
                        getButton("."),
                        getButton("=", buttonColor: Colors.green),
                      ]),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget getButton(String title, {Color? buttonColor = Colors.black}) {
    return MaterialButton(
      elevation: 5,
      onPressed: () {
        // setState(() {
        //   output = output + title;
        // });
        calculate(title);
      },
      color: buttonColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(20),
      child: Text(
        title,
        style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
    );
  }

  void calculate(String value) {
    switch (value) {
      case "AC":
        output = "";
        break;
      case "Q":
        output = output.substring(0, output.length - 1);
        break;
      case "=":
        double result = evaluateExpression(output);
        output = "$result";
        break;

      // 1234.subString(0, 3-1=2)
      default:
        output = output + value;
    }
    setState(() {});
  }

  double evaluateExpression(String expression) {
    expression = expression.replaceAll(' ', ''); // Remove any spaces
    return _evaluateAdditionSubtraction(expression);
  }

  double _evaluateAdditionSubtraction(String expression) {
    List<String> terms = [];
    String currentTerm = '';
    int parenthesesLevel = 0;

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (char == '(') {
        parenthesesLevel++;
      } else if (char == ')') {
        parenthesesLevel--;
      }

      if ((char == '+' || char == '-') && parenthesesLevel == 0) {
        terms.add(currentTerm);
        terms.add(char);
        currentTerm = '';
      } else {
        currentTerm += char;
      }
    }
    terms.add(currentTerm);

    double result = _evaluateMultiplicationDivision(terms[0]);

    for (int i = 1; i < terms.length; i += 2) {
      String operator = terms[i];
      double nextTerm = _evaluateMultiplicationDivision(terms[i + 1]);

      if (operator == '+') {
        result += nextTerm;
      } else if (operator == '-') {
        result -= nextTerm;
      }
    }

    return result;
  }

  double _evaluateMultiplicationDivision(String expression) {
    List<String> factors = [];
    String currentFactor = '';
    int parenthesesLevel = 0;

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (char == '(') {
        parenthesesLevel++;
      } else if (char == ')') {
        parenthesesLevel--;
      }

      if ((char == '*' || char == '/') && parenthesesLevel == 0) {
        factors.add(currentFactor);
        factors.add(char);
        currentFactor = '';
      } else {
        currentFactor += char;
      }
    }
    factors.add(currentFactor);

    double result = _evaluateParentheses(factors[0]);

    for (int i = 1; i < factors.length; i += 2) {
      String operator = factors[i];
      double nextFactor = _evaluateParentheses(factors[i + 1]);

      if (operator == '*') {
        result *= nextFactor;
      } else if (operator == '/') {
        result /= nextFactor;
      }
    }

    return result;
  }

  double _evaluateParentheses(String expression) {
    if (expression.startsWith('(') && expression.endsWith(')')) {
      return evaluateExpression(expression.substring(1, expression.length - 1));
    }
    return double.tryParse(expression) ?? 0.0;
  }
}
