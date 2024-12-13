import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:ticketlelo/provider/create_event_provider.dart';
import 'package:ticketlelo/services/auth/auth_service.dart';
import 'package:country_state_city/models/country.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as developer;

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {

  late TextEditingController _eventNameController;
  late TextEditingController _eventDescriptionController;
  late TextEditingController _eventCategoryController;
  late TextEditingController _eventLocationController;
  late TextEditingController _eventCityController;
  late TextEditingController _eventCountryController;
  late TextEditingController _startDatePickerController;
  late TextEditingController _endDatePickerController;
  late TextEditingController _maxParticipantController;
  late TextEditingController _settlementAccController;
  String? _city;
  String? _country;
  String? _state;
  late AuthService _authService;
  late DateTime? _startDateRaw;
  late DateTime? _endDateRaw;
  int _price=0;
  String settlement='N/A';
  late TextEditingController _priceController;

  @override
  void initState() {
    _authService=AuthService.Firebase();
    _eventNameController=TextEditingController();
    _eventDescriptionController=TextEditingController();
    _eventCategoryController=TextEditingController();
    _eventLocationController=TextEditingController();
    _eventCityController=TextEditingController();
    _eventCountryController=TextEditingController();
    _maxParticipantController=TextEditingController();
    _priceController=TextEditingController();
    _startDatePickerController=TextEditingController();
    _endDatePickerController=TextEditingController();
    _settlementAccController=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDescriptionController.dispose();
    _eventCategoryController.dispose();
    _eventLocationController.dispose();
    _eventCityController.dispose();
    _eventCountryController.dispose();
    _maxParticipantController.dispose();
    _settlementAccController.dispose();

    _startDatePickerController.dispose();
    _endDatePickerController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final freePaidProv=Provider.of<FreePaidProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(

      ),
      body:SingleChildScrollView(
        child:Container(
          margin: const EdgeInsets.only(left: 13,right: 13),
          child: Column(

            children: [
              const Center(child: Text('Create Event')),
              TextFormField(
                controller: _eventNameController,
                decoration: const InputDecoration(

                  label: Text('Event Name'),
                ),
              ),
              TextField(
                controller: _eventDescriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                    label: Text('Event Description')

                ),
              ),

              TextFormField(
                controller: _eventCategoryController,
                decoration: const InputDecoration(
                  label: Text('Event Category')
                ),
              ),

              Consumer<FreePaidProvider>(
                builder: (context,value,child)
                {
                  return Column(children: [
                    RadioListTile<bool>(
                        title: const Text('Free to Participate Event'),
                        value: true,
                        groupValue:value.free ,
                        onChanged: value.setFree
                    ),
                    RadioListTile<bool>(
                        title: const Text('Paid Ticket Event'),
                        value: false,
                        groupValue: value.free,
                        onChanged: value.setFree
                    ),
                    if (!value.free) Column(
                      children: [
                        TextFormField( controller:_priceController , keyboardType: TextInputType.number,decoration: InputDecoration(hintText: 'Ticket Price')),
                        TextField(
                          controller: _settlementAccController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: const InputDecoration(
                              label: Text('Settlement Account Details')

                          ),
                        ),

                      ],
                    ) else Container(),


                  ],);
                },

              ),



              TextFormField(
                controller: _maxParticipantController,
                keyboardType: TextInputType.number,

                decoration: const InputDecoration(
                  hintText: 'Max Participant Count',
                  label: Text('Max Participant Count'),

                ),

              ),



              TextFormField(
                controller: _eventLocationController,
                decoration: const InputDecoration(
                  label:Text('Event Venue Address'),
                ),
              ),

              const Text('Venue Location Details:'),

              Consumer<CreateEventProvider>(builder: (context,value,child){
                return Column(
                  children: [
                    CSCPicker(

                      onCountryChanged: (country)
                      {
                        _country=country;
                      },
                      onCityChanged: (city)
                      {
                        _city=city;
                      },
                      onStateChanged: (state)
                      {
                        _state=state;
                      },
                      countryDropdownLabel: 'Select Country for Event',
                      stateDropdownLabel: 'Select State for the Event',
                      cityDropdownLabel: 'Select City for Event',
                      layout: Layout.vertical,


                    ),
                    TextFormField(
                      readOnly: true,//user cant edit this, only system can edit text
                      controller: _startDatePickerController,
                      onTap: () async{
                        //final DateTime? _pickedDate= await showDatePicker(context: context, firstDate: DateTime(2024), lastDate: DateTime(2030));
                        _startDateRaw= await showBoardDateTimePicker(

                          context: context,
                          pickerType: DateTimePickerType.datetime,
                        );
                        value.setStartDate(_startDateRaw);

                        _startDatePickerController.text=value.startDtText;

                      },
                      decoration: const InputDecoration(
                        label: Text('Select Start Date and Time'),
                      ),
                    ),
                    TextFormField(
                readOnly: true,//user cant edit this, only system can edit text
                controller: _endDatePickerController,
                onTap: () async{
                _endDateRaw = await showBoardDateTimePicker(

                context: context,
                pickerType: DateTimePickerType.datetime,
                );
                value.setEndDate(_endDateRaw);

                _endDatePickerController.text=value.endDtText;

                },
                decoration: const InputDecoration(
                label: Text('Select End Date and Time'),
                ),
                ),
                    InkWell(
                      onTap: ()async{
                        await value.getImageFromGallery();
                      },
                      child: Container(
                        height: 100,
                        margin: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: value.image!=null ? Image.file(value.image!.absolute) :const Center(child:Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image),
                            Text('Select Image')
                          ],
                        )),
                      ),
                    ),


                    Container(
                      margin: const EdgeInsets.all(16),
                      width:double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.indigoAccent, // background color
                            foregroundColor: Colors.white,//text color

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )
                        ),
                        onPressed: ()async {
                          if((!(freePaidProv.free))&&(_priceController.text!=null))
                          {
                            _price=int.parse(_priceController.text);
                            if(_settlementAccController.text!=null)
                             {
                               settlement=_settlementAccController.text;
                             }
                            else
                             {
                               settlement='N/A';
                             }


                          }
                          else if(freePaidProv.free)
                          {
                            _price=0;
                            settlement='N/A';
                          }
                          value.submit(context,_eventNameController.text, _eventDescriptionController.text, _eventCategoryController.text, _price,_eventLocationController.text, _country!, _city!, _startDateRaw!, _endDateRaw!, int.parse(_maxParticipantController.text),settlement);
                        },
                        child:(value.loader)?
                            CircularProgressIndicator(color: Colors.white,)
                            : const Text('Create Event'),
                      ),
                    ),

                  ],
                );


              }),






            ],
          ),
        ),
      ) ,
    );

  }
}

