//
//  Constants.h
//  Instagigs
//
//  Created by Jerry Phillips on 8/17/15.
//  Copyright (c) 2015 Elevate Management & Marketing Inc. All rights reserved.
//

#ifndef Instagigs_Constants_h
#define Instagigs_Constants_h


// Color

#define INSTABLUE [UIColor colorWithRed:0 green:0.439 blue:0.929 alpha:1]
#define FAINTGRAY [UIColor colorWithRed:0.63 green:0.63 blue:0.63 alpha:1.0]
#define GREEN [UIColor colorWithRed:0.04 green:0.67 blue:0.06 alpha:1.0]
//Fonts



#ifdef TALENT
#define _ENVIRONMENT @"TALENT"
#elif ADMIN
#define _ENVIRONMENT @"ADMIN"
#else
#define _ENVIRONMENT @"RNDC"
#endif


//Parse Constants
#define USERNAME @"username"
#define FIRSTNAME @"firstName"
#define LASTNAME @"lastName"
#define GENDER @"gender"
#define PASSWORD @"password"
#define ADDRESSLINE1 @"addressLine1"
#define ADDRESSLINE2 @"addressLine2"
#define CITY @"city"
#define STATE @"state"
#define ZIP @"ZIP"
#define ZIPCODE @"zipCode"  //For events
#define EMAIL @"email"
#define DATEOFBIRTH @"dateOfBirth"
#define PROFILE1 @"profile1"
#define PROFILE2 @"profile2"
#define PROFILE3 @"profile3"
#define PROFILE4 @"profile4"
#define PROFILE5 @"profile5"
#define PROFILE6 @"profile6"
#define PROFILE7 @"profile7"
#define PROFILE8 @"profile8"
#define PROFILE9 @"profile9"
#define INSTAGRAM @"instagramHandle"
#define TWITTER @"twitterHandle"
#define BIO @"bio"
#define BARTENDINGEXPERIENCE @"bartendingExperience"
#define PRIMARYLANGUAGE @"primaryLanguage"
#define SECONDARYLANGUAGE @"secondLanguage"
#define YEARSBARTENDING @"yearsBarTending"
#define AGE @"age"
#define HEIGHT @"height"
#define WEIGHT @"weight"
#define SHIRTSIZE @"shirtSize"
#define VALIDDRIVERSLICENSE @"validDriversLicence"
#define ISADMIN @"isAdmin"
#define TATTOOS @"tattoos"
#define FACEBOOKID @"facebookID"
#define EVENTMANAGER @"EventManager"
#define EVENTDATE @"eventDate"
#define BRANDNAME @"brandName"
#define BRANDIMAGE @"brandImage"
#define UPDATEDAT @"updatedAt"
#define BRANDS @"Brands"
#define JOBTITLES @"JobTitles"
#define JOBTITLE @"jobTitle"
#define PAYRATE @"payRate"
#define EVENTTITLE @"eventTitle"
#define EVENTTYPE @"eventType"
#define STARTTIME @"startTime"
#define ENDTIME @"endTime"
#define NUMBEROFTALENT @"numberOfTalent" 
#define NOTES @"notes"
#define EVENTADDRESS @"eventAddress"
#define SCHEDULED @"scheduled"
#define STAFFED @"staffed"
#define COMPLETED @"completed" 
#define VENUENAME @"venueName"
#define GEOPOINT @"InstagigGeoPoint"
#define STAFFMANAGER @"staffManager"
#define STAFFEDPERSEON @"staffedPersonObjectID"
#define EVENTOBJECT @"eventObjectId"
#define ARRIVALTIME @"arrivalTime"
#define EXITTIME @"exitTime"
#define SPOTSREMAINING @"spotsRemaining"
#define REPORTS @"Reports"
#define CUSTOMERFEEDBACK @"customerFeedback"
#define TOTALSAMPLED @"totalSampled"
#define ACCOUNTSPEND @"accountSpend"
#define TOTALATTENDED @"totalAttended"
#define RECEIPT @"receipt"
#define TABLESETUP @"tableSetup"
#define REPORTEE  @"reportee"
#define REPORTEVENT @"reportForEvent"
#define BOTTLEINVENTORY @"bottleInventory"
#define SHELFDISPLAY @"shelfDisplay"
#define CUSTOMER1  @"customer1"
#define CUSTOMER2  @"customer2"
#define CUSTOMER3 @"customer3"
#define APPROVED @"approved"
#define DECLINED @"declined"
#define ETHNICITY @"ethnicity"
#define PHONENUMBER @"phoneNumber"
#define CONTACTPERSON @"contactPerson"
#define CONTACTPHONE @"contactPhone"
#define OBJECTID @"objectId"

// FOURSQUARE
#define FSCLIENTKEY @"2XQHY5ESJOJ5TCUZNFZEXYQBWKQ2DMWEPUIW4BPZXLL20NN5"
#define FSCLIENTSECRET @"2TIFJ2XEHPQ0MEGDVXSYDRNFVGKLF0BTZWXDX5EEMV2H3VHQ"
#define VENUE @"venue"
#define NAME  @"name"
#define LOCATION @"location"
#define LAT @"lat"
#define LNG @"lng"
#define ADDRESS  @"address"
#define CATEGORIES @"categories"

//NSNOTIFICATIONS

#define PROFILEPICUPDATED @"profilePicUpdated"
#define MOVECONTENT @"moveContent"
#define DISMISSKEYBOARD @"dismissKeyboard"
#define EVENTSUPDATED @"eventsUpdated"
#define NEWEVENTCREATED @"newEventCreated"
#define EVENTEDITED @"eventEdited"
#define EVENTDELETED @"eventDeleted"
#define PUSHPCONTROLLER @"pushProfile"
#define SEARCHCOMPLETED @"searchCompleted"
#define SHOWCREATEEVENT @"showCreateEvent"
#define SHOWHUD @"showHUD"
#define HIDEHUD @"hideHUD"
#define UPDATEVENUETEXT @"updateVenueText"
#define UPDATEBRANDTEXT @"updateBrandText"
#define UPDATEJOBTEXT @"updateJobText"
#define SHOWSETTINGS @"showSettings"
#define SHOWAVAILABLE @"showAvailable"

#endif
