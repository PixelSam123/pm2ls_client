import 'package:flutter/material.dart';
import 'package:pm2ls_client/sizes.dart' as sizes;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  static const String _appName = 'pm2ls_client';

  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.25),
        child: child!,
      ),
      title: _appName,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
      home: const HomePage(appName: _appName),
    );
  }
}

class HomePage extends StatefulWidget {
  final String appName;

  const HomePage({super.key, required this.appName});

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _host = TextEditingController();
  final TextEditingController _port = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.appName)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(sizes.largePadding),
          child: Column(
            children: [
              Text(
                'PM2LS',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: sizes.largePadding),
              TextField(
                controller: _host,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Host',
                ),
              ),
              const SizedBox(height: sizes.normalPadding),
              TextField(
                controller: _port,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  labelText: 'Port',
                ),
              ),
              const SizedBox(height: sizes.normalPadding),
              Row(
                children: [
                  SizedBox(
                    height: sizes.largeButtonHeight(
                      MediaQuery.of(context).textScaleFactor,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Connect'),
                    ),
                  ),
                  const SizedBox(width: sizes.normalPadding),
                  SizedBox(
                    height: sizes.largeButtonHeight(
                      MediaQuery.of(context).textScaleFactor,
                    ),
                    child: ElevatedButton(
                      onPressed: () {},
                      child: const Text('Mute'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
