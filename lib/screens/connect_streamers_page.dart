import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/config.dart';
import 'package:multistreamer_pomodoro/models/twitch_interface.dart';
import 'package:multistreamer_pomodoro/screens/show_participants_page.dart';
import 'package:twitch_manager/twitch_manager.dart';

class ConnectedStreamersPage extends StatefulWidget {
  const ConnectedStreamersPage({super.key});

  static const route = '/connect-streamers-page';

  @override
  State<ConnectedStreamersPage> createState() => _ConnectedStreamersPageState();
}

class _ConnectedStreamersPageState extends State<ConnectedStreamersPage> {
  void _connectStreamer({required String streamerId}) async {
    final manager = await showDialog<TwitchManager>(
      context: context,
      builder: (context) => Dialog(
          child: TwitchAuthenticationScreen(
        mockOptions: TwitchInterface.instance.mockOptions,
        onFinishedConnexion: (manager) => Navigator.pop(context, manager),
        appInfo: TwitchInterface.instance.appInfo,
        loadPreviousSession: false,
      )),
    );
    if (!mounted || manager == null) return;

    await TwitchInterface.instance
        .addStreamer(streamerId: streamerId, manager: manager);
    if (!mounted) return;

    if (TwitchInterface.instance.connectedStreamerIds.length == nbStreamers) {
      Navigator.of(context).pushReplacementNamed(ShowParticipantsPage.route);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),
            Text('Connect all the streamers',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            for (int i = 0; i < nbStreamers; i++)
              _buildStreamerButton(streamerIndex: i),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamerButton({required int streamerIndex}) {
    final connectedStreamers = TwitchInterface.instance.connectedStreamerIds;
    final streamerId = streamerIndex.toString();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
          onPressed: connectedStreamers.contains(streamerId)
              ? null
              : () => _connectStreamer(streamerId: streamerId),
          child: Text('Connect streamer ${streamerIndex + 1}')),
    );
  }
}
