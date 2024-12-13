import 'package:ticketlelo/constants/cloudStorageConstants.dart';
import 'package:ticketlelo/exceptions/cloud_storage_exceptions.dart';
import 'package:ticketlelo/services/cloud/cloud_event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

import 'package:ticketlelo/services/cloud/cloud_ticket.dart';


class FirebaseCloudStorage
{
  static final FirebaseCloudStorage _shared=FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage()=>_shared;


  final events =FirebaseFirestore.instance.collection('events');
  final tickets=FirebaseFirestore.instance.collection('tickets');
  
  
  //events.orderBy(field)

  Future<CloudEvent?> createEvent(String organizerUserId,String organizerUserName,String eventName, String eventDescription,String eventCategory,int price,String eventPosterURL,String eventLocation,String eventCity,String eventCountry, DateTime startDt,DateTime endDt, int maxParticipants, String settlementAcc)
  async
  {
    try{final doc=await events.add({
      eventNameField: eventName,
      eventDescriptionField: eventDescription,
      eventCategoryField:eventCategory,
      eventPriceField:price,
      organizerIdField:organizerUserId,
      organizerUserNameField:organizerUserName,
      eventPosterURLField:eventPosterURL,
      eventLocationField:eventLocation,
      eventCityField:eventCity,
      eventCountryField:eventCountry,
      startDtField:startDt,
      endDtField:endDt,
      maxParticipantsField:maxParticipants,
      currParticipantsField:0,
      approvedField:0,
      settlementAccField:settlementAcc,

    });
    final snapshot=await doc.get();//this will get the document snapshot from doc
    if(snapshot.exists) {
      return CloudEvent(
        eventId:snapshot.id,
        eventName:snapshot.data()![eventNameField] as String,
        eventCategory:snapshot.data()![eventCategoryField] as String,
        eventDescription:snapshot.data()![eventDescriptionField] as String,
        eventPrice: snapshot.data()![eventPriceField] as int,
        eventPosterURL:snapshot.data()![eventPosterURLField] as String,
        eventLocation:snapshot.data()![eventLocationField] as String,
        eventCity:snapshot.data()![eventCityField] as String,
        eventCountry:snapshot.data()![eventCountryField] as String,
        organizerId:snapshot.data()![organizerIdField] as String,
        organizerUserName:snapshot.data()![organizerUserNameField] as String,
        start_dt:snapshot.data()![startDtField].toDate() as DateTime,
        end_dt:snapshot.data()![endDtField].toDate() as DateTime,
        max_participants:snapshot.data()![maxParticipantsField] as int,
        curr_participants:snapshot.data()![currParticipantsField] as int,
        approved: snapshot.data()![approvedField] as int,
        settlementAcc: snapshot.data()![settlementAccField] as String,
      );
    }
    return null;
    }
    catch(e)
    {
      developer.log("\n\n\n\nException from Cloud File:"+ e.toString()+"\n\n\n\n");
      rethrow;
    }
    //creating an Event

  }


  Future<Iterable<CloudEvent>> getEvents({required String organizerId})
  async{
    try {

      return await events.where(organizerIdField, isEqualTo: organizerId).get()
          .then((value)=>value.docs.map(
              (doc){
                return CloudEvent.fromSnapshot(doc);
          }
      ));
    }
    catch(e)
    {
      throw CouldNotGetAllEventsException();
    }
  }

  Stream<Iterable<CloudEvent>> allEventsApproved({required String organizerId})
  {
    return events.snapshots().map((event)=>event.docs.map((doc)=>CloudEvent.fromSnapshot(doc))
        .where((event)=>event.organizerId==organizerId&&event.approved==1));
  }



  Stream<Iterable<CloudEvent>> allEventsUnApproved({required String organizerId})
  {
    return events.snapshots().map((event)=>event.docs.map((doc)=>CloudEvent.fromSnapshot(doc))
        .where((event)=>event.organizerId==organizerId&&event.approved==0));
  }

  Stream<Iterable<CloudTicket>> FirstFourTicketsUpcoming(String userId)
  {
    final firstFourtickets=FirebaseFirestore.instance.collection('tickets').orderBy('ticket_start_dt',descending: true).limit(4);
    return firstFourtickets.snapshots().map((ticket)=>ticket.docs.map((doc)=>CloudTicket.fromSnapshot(doc))
        .where((ticket)=>ticket.userID==userId&&ticket.ticketEndDT.isAfter(DateTime.now())));
  }


  Stream<Iterable<CloudTicket>> FirstFourTicketsHistory(String userId)
  {
    final firstFourtickets=FirebaseFirestore.instance.collection('tickets').orderBy('ticket_start_dt',descending: true).limit(5);
    return firstFourtickets.snapshots().map((ticket)=>ticket.docs.map((doc)=>CloudTicket.fromSnapshot(doc))
        .where((ticket)=>ticket.userID==userId&&ticket.ticketEndDT.isBefore(DateTime.now())));
  }


  Stream<Iterable<CloudTicket>> allTicketsHistory(String userId)
  {
    final ticketsHistory=FirebaseFirestore.instance.collection('tickets').orderBy('ticket_start_dt',descending: false);
    return tickets.snapshots().map((ticket)=>ticket.docs.map((doc)=>CloudTicket.fromSnapshot(doc))
        .where((ticket)=>ticket.userID==userId&&ticket.ticketEndDT.isBefore(DateTime.now())));
  }


  Stream<Iterable<CloudTicket>> allTicketsUpcoming(String userId)
  {
    final upcomingTickets=FirebaseFirestore.instance.collection('tickets').orderBy('ticket_start_dt',descending: false);
    return upcomingTickets.snapshots().map((ticket)=>ticket.docs.map((doc)=>CloudTicket.fromSnapshot(doc))
        .where((ticket)=>ticket.userID==userId&&ticket.ticketEndDT.isAfter(DateTime.now())));
  }


  Stream<Iterable<CloudEvent>> allEventsUniversalUpcoming()
  {
    final Sortedevents=FirebaseFirestore.instance.collection('events').orderBy('start_dt',descending: false);
    return Sortedevents.snapshots().map((event)=>event.docs.map((doc)=>CloudEvent.fromSnapshot(doc))
    .where((event)=>event.start_dt.isAfter(DateTime.now())&&event.isApproved()));
    //change isBefore to isAfter
  }

  Future<void> updateEvent({required String documentId, required String text})
  async{
   /* try{
      await events.doc(documentId).update({textFieldName:text});

    }
    catch(e)
    {
      throw CouldNotUpdateEventException();
    }*/

  }

  Future<void> deleteEvent({required String eventId, required String organizer})
  async{
    try
    {
      deleteTicketsForEvent(eventId);
      events.doc(eventId).delete();
    }
    catch(e)
    {
     throw CouldNotDeleteEventException();
    }

  }

  Future<void> deleteTicketsForEvent(String eventId) async {
    try {
      // Query the tickets collection where event_id matches the eventId
      QuerySnapshot querySnapshot = await tickets.where('event_id', isEqualTo: eventId).get();

      // Check if there are any documents to delete
      if (querySnapshot.docs.isEmpty) {
        developer.log('No tickets found for event ID: $eventId');
        return;
      }

      // Iterate over the documents and delete each one
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
        developer.log('Deleted ticket with ID: ${doc.id}');
      }

      developer.log('All tickets for event ID: $eventId have been deleted.');
    } catch (e) {
      // Handle errors
      developer.log('Error deleting tickets: $e');
      throw CouldNotDeleteTicketsException();
    }
  }

  Future<void> incrementParticipants(String eventId) async {
    try {
      // Reference to the specific event document
      DocumentReference eventRef = events.doc(eventId);

      // Update the curr_participants field by incrementing it by 1
      await eventRef.update({
        'curr_participants': FieldValue.increment(1),
      });

      developer.log('Successfully incremented participants for event ID: $eventId');
    } catch (e) {
      // Handle errors
      developer.log('Error incrementing participants: $e');
      throw CouldNotUpdateParticipantsException();
    }
  }







  Future<CloudTicket?> createTicket(String eventID,String userID,String userName, int ticketNumber,String eventName,String eventPosterURL,DateTime ticketStartDT,DateTime ticketEndDT,String eventVenue,String eventCity,int price)
  async
  {
    try{

      final event=events.doc(eventID).get();
      final doc=await tickets.add({
      eventIDField:eventID,
      userIDField:userID,
      ticketUserNameField:userName,
      ticketNumberField:ticketNumber,
      ticketEventNameField:eventName,
      ticketEventPhotoURLField:eventPosterURL,
      ticketStartDTField: ticketStartDT,
      ticketEndDTField:ticketEndDT,
      ticketEventVenueField:eventVenue,
      ticketEventCityField:eventCity,
      ticketPriceField:price,

    });
      await incrementParticipants(eventID);


    final snapshot=await doc.get();//this will get the document snapshot from doc
    if(snapshot.exists) {



      return CloudTicket(
        ticketID: snapshot.id,
        eventName: snapshot.data()![ticketEventNameField] as String,
        eventID: snapshot.data()![eventIDField] as String,
        userID: snapshot.data()![userIDField] as String,
        userName: snapshot.data()![ticketUserNameField] as String,
        ticketNumber: snapshot.data()![ticketNumberField] as int,
        eventPosterURL: snapshot.data()![ticketEventPhotoURLField] as String,
        ticketStartDT: snapshot.data()![ticketStartDTField].toDate() as DateTime,
        ticketEndDT: snapshot.data()![ticketEndDTField].toDate() as DateTime,
        eventVenue: snapshot.data()![ticketEventVenueField] as String,
        eventCity: snapshot.data()![ticketEventCityField] as String,
        price: snapshot.data()![ticketPriceField] as int,
      );


    }
    return null;
    }
    catch(e)
    {
      developer.log("\n\n\n\nException from Cloud File:"+ e.toString()+"\n\n\n\n");
      rethrow;
    }
    //creating an Event

  }
}