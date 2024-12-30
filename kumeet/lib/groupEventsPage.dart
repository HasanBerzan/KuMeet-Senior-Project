import 'package:flutter/material.dart';
import 'package:kumeet/event.dart';
import 'package:kumeet/eventDetail_page.dart';
import 'package:kumeet/group_service.dart';
import 'package:kumeet/group.dart';
import 'event_card.dart'; // Make sure this import points to your EventCard definition file

class GroupEventsPage extends StatefulWidget {
  final Group group;

  const GroupEventsPage({Key? key, required this.group}) : super(key: key);

  @override
  _GroupEventsPageState createState() => _GroupEventsPageState();
}

class _GroupEventsPageState extends State<GroupEventsPage> {
  Future<List<Event>> _getEventsForGroup() async {
    GroupService groupService = GroupService();
    try {
      return await groupService.getEventsforGroups(widget.group);
    } catch (e) {
      print('Failed to fetch events: $e');
      throw Exception('Failed to fetch events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events for ${widget.group.name}'),
      ),
      body: FutureBuilder<List<Event>>(
        future: _getEventsForGroup(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No events available.'));
          } else {
            final events = snapshot.data!;
            return ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(
                  event: event,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage(
                          event: event,
                          onAddToCalendar: () {}, // Placeholder callback
                          isAdded: false, // This would ideally check if the event is already added
                        ),
                      ),
                    );
                  },
                  cardWidth: MediaQuery.of(context).size.width - 32, // Adjust the width to fit the screen
                );
              },
            );
          }
        },
      ),
    );
  }
}
