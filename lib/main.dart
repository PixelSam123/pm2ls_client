import 'package:flutter/material.dart';
import 'package:mic_stream/mic_stream.dart';
import 'package:opus_dart/opus_dart.dart';
import 'package:opus_flutter/opus_flutter.dart' as opus_flutter;
import 'package:pm2ls_client/sizes.dart' as sizes;
import 'package:web_socket_channel/web_socket_channel.dart';

Future<void> main() async {
  initOpus(await opus_flutter.load());
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  static const _appName = 'pm2ls_client';

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
  final _host = TextEditingController();
  final _port = TextEditingController();

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

class _WSAudioStreamConfig {
  final int sampleRate;
  final int channels;
  final int app;
  final int frameDuration;
  final String serverAddress;
  final int serverPort;

  const _WSAudioStreamConfig({
    this.sampleRate = 48000,
    this.channels = 1,
    this.app = 2048,
    this.frameDuration = 20,
    this.serverAddress = "127.0.0.2",
    this.serverPort = 7619,
  });
}

class _WSAudioStream {
  final _WSAudioStreamConfig config;
  var _muted = false;

  _WSAudioStream(this.config);

  Future<void> start() async {
    final micStream = MicStream.microphone(
      channelConfig: config.channels <= 1
          ? ChannelConfig.CHANNEL_IN_MONO
          : ChannelConfig.CHANNEL_IN_STEREO,
      sampleRate: config.sampleRate,
    );

    final channel = WebSocketChannel.connect(Uri.parse(config.serverAddress));
    final encodedAudioStream = (await micStream)!.cast<List<int>>().transform(
          StreamOpusEncoder.bytes(
            frameTime: FrameTime.ms20,
            floatInput: false,
            sampleRate: config.sampleRate,
            channels: config.channels,
            application: Application.voip,
          ),
        );

    channel.sink.addStream(encodedAudioStream);
  }

  stop() {}

  setMuted(bool muted) {
    _muted = muted;
  }
}
