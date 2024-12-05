import 'package:flutter/material.dart';
import 'package:kumeet/eventDetail_page2.dart';
import 'event.dart';
import 'event_service.dart';
import 'eventcard.dart';
import 'login_page.dart';

class OwnedEventsPage extends StatefulWidget {
  const OwnedEventsPage({super.key});

  @override
  _OwnedEventsPageState createState() => _OwnedEventsPageState();
}

class _OwnedEventsPageState extends State<OwnedEventsPage> {
  List<Event> ownedEvents = [];
  bool isLoading = true;
  final EventService eventService = EventService();
  String? userName = GlobalState().userName;

  @override
  void initState() {
    super.initState();
    fetchOwnedEvents();
  }

  Future<void> fetchOwnedEvents() async {
    try {
      final events = await eventService.getEventsByAdmin(userName!);
      setState(() {
        ownedEvents = events;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load owned events: $e')),
      );
    }
  }

  Future<void> _confirmDelete(Event event) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        isLoading = true;
      });

      final success = await eventService.deleteEvent(event);

      if (success) {
        setState(() {
          ownedEvents.remove(event);
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Event "${event.title}" deleted successfully.')),
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete event.')),
        );
      }
    }
  }

  void _editEvent(Event event) {
    // Implement edit functionality if needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Owned Events'),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
              ),
            )
          : OwnedEventsBody(
              ownedEvents: ownedEvents,
              onDelete: _confirmDelete,
              onEdit: _editEvent,
            ),
    );
  }
}

class OwnedEventsBody extends StatelessWidget {
  final List<Event> ownedEvents;
  final Future<void> Function(Event) onDelete;
  final void Function(Event) onEdit;

  const OwnedEventsBody({
    super.key,
    required this.ownedEvents,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Owned Events',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            for (var event in ownedEvents)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: EventCard(
                  event: event,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventDetailPage2(
                          event: event,
                          onEventUpdated: () async {
                            // await fetchOwnedEvents();
                          },
                          onEventDeleted: () async {
                            await onDelete(event);
                          },
                        ),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () => onEdit(event),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.white),
                        onPressed: () => onDelete(event),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
