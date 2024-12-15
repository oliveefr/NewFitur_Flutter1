import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Correct import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // URL media sosial
  final String instagramUrl = 'https://www.instagram.com/oliveefr_';
  final String githubUrl = 'https://github.com/oliveefr';

  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString(), forceSafariVC: true, forceWebView: true);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PORTOFOLIO'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        titleTextStyle:
            const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      endDrawer: Drawer(
        child: Column(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const UserAccountsDrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                accountName: Text(
                  'Olive',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                accountEmail: Text('oliveframitha@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: AssetImage('assets/gwen.jpg'),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ListTile(
                    leading: const Icon(Icons.home, color: Colors.deepPurple),
                    title: const Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.link, color: Colors.pink),
                    title: const Text('Instagram'),
                    onTap: () => _launchURL(instagramUrl),
                  ),
                  ListTile(
                    leading: const Icon(Icons.code, color: Colors.black),
                    title: const Text('GitHub'),
                    onTap: () => _launchURL(githubUrl),
                  ),
                  ListTile(
                    leading: const Icon(Icons.calculate, color: Colors.green),
                    title: const Text('Calculator'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CalculatorPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout successful!')),
                );
              },
            ),
          ],
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/gwen.jpg'),
            ),
            SizedBox(height: 20),
            Text(
              'Olive',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Flutter Developer | Mobile App Enthusiast',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Text(
              'Selamat datang di aplikasi portofolio pribadi saya! '
              'Di sini, Anda dapat melihat hasil portofolio yang saya buat untuk project UTS dengan fitur- fitur menarik didalamnya '
              'Jangan ragu untuk terhubung dengan saya melalui link yang tersedia. ENJOY!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),
            Divider(color: Colors.grey),
          ],
        ),
      ),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _input = '';
  String _result = '0';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == '=') {
        _calculate();
      } else if (value == 'C') {
        _input = '';
        _result = '0';
      } else {
        _input += value;
      }
    });
  }

  void _calculate() {
    try {
      final parsedResult = _evaluateExpression(_input);
      setState(() {
        _result = parsedResult.toString();
      });
    } catch (e) {
      setState(() {
        _result = 'Error';
      });
    }
  }

  double _evaluateExpression(String expression) {
    final tokens = RegExp(r'([+\-*/])|([0-9.]+)')
        .allMatches(expression)
        .map((e) => e.group(0)!)
        .toList();

    if (tokens.isEmpty) return 0.0;

    final stack = <double>[];
    double? currentNumber;
    String? currentOperator;

    for (var token in tokens) {
      if (RegExp(r'[0-9.]').hasMatch(token)) {
        currentNumber = double.tryParse(token);
        if (currentOperator == null) {
          stack.add(currentNumber!);
        } else {
          final previousNumber = stack.removeLast();
          switch (currentOperator) {
            case '+':
              stack.add(previousNumber + currentNumber!);
              break;
            case '-':
              stack.add(previousNumber - currentNumber!);
              break;
            case '*':
              stack.add(previousNumber * currentNumber!);
              break;
            case '/':
              stack.add(previousNumber / currentNumber!);
              break;
          }
          currentOperator = null;
        }
      } else {
        currentOperator = token;
      }
    }

    return stack.isNotEmpty ? stack.last : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _input,
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              _result,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: [
                ...[
                  '7',
                  '8',
                  '9',
                  '/',
                  '4',
                  '5',
                  '6',
                  '*',
                  '1',
                  '2',
                  '3',
                  '-',
                  'C',
                  '0',
                  '=',
                  '+'
                ]
                    .map((e) => ElevatedButton(
                          onPressed: () => _onButtonPressed(e),
                          child: Text(e),
                        ))
                    ,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
