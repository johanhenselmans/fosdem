/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import "LAEventsXMLParser.h"


@implementation LAEventsXMLParser

@synthesize delegate;
@synthesize eventsXMLParser;
bool pentabarf = true;
NSDate *currentDate;
NSDate *totalStartDate;


- (LAEventsXMLParser *) initWithContentsOfFile: (NSString *) path delegate: (id) newDelegate {
  if (self = [super init]) {
    [self setDelegate: newDelegate];
    
    eventsXMLParser = [[NSXMLParser alloc] initWithContentsOfURL: [NSURL fileURLWithPath: path]];
    [eventsXMLParser setDelegate: self];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss vvvv"];
    // added two date formatters for the xml date formatting
    
    dateFormatterYMD = [[NSDateFormatter alloc] init];
    [dateFormatterYMD setDateFormat: @"yyyy-MM-dd"];
    
    dateFormatterHM = [[NSDateFormatter alloc] init];
    [dateFormatterHM setDateFormat: @"HH:mm"];
    
  }
  
  return self;
}

- (BOOL) parse {
  return [eventsXMLParser parse];
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
  if (!currentStringValue) {
    // currentStringValue is an NSMutableString instance variable
    currentStringValue = [[NSMutableString alloc] init];
  }
  [currentStringValue appendString:string];
}


- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
  //NSLog(@"in XML parsing didStartElement");
  if ([elementName isEqualToString: @"day"]) {
    // NSMutableArray *eventArray = [[NSMutableArray alloc] init];
    NSString *thisDate = [attributeDict objectForKey:@"date"];
    if (thisDate ){
      currentDate = [dateFormatterYMD dateFromString:thisDate];
    }
  }
  
  if ([elementName isEqualToString: @"link"]) {
//    NSLog(@"start videolink: %@",elementName);
    NSString *thisHref = (NSString *)[attributeDict objectForKey:@"href"];
//    NSLog(@"videolink: %@",thisHref);
    if (thisHref){
      NSRange textRange =[thisHref rangeOfString:@"video.fosdem.org"];
      if(textRange.location != NSNotFound)
      {
        [currentEvent setContentVideo: [NSString stringWithString: thisHref]];
//        NSLog(@"Added videolink: %@",thisHref);
      }
    }
  }
  
  
  if ([elementName isEqualToString: @"vevent"] || [elementName isEqualToString:@"event"]) {
    currentEvent = [[LAEvent alloc] init];
    // [currentEvent setIdentifier: [attributeDict objectForKey: @"pentabarf:event-id"]];
    //we make a distinction between the pentabarf XML file and the conference xml file
    if ([elementName isEqualToString: @"vevent"]) {
      pentabarf = true;
    } else {
      pentabarf = false;
      if ([elementName isEqualToString: @"event"]) {
        // NSMutableArray *eventArray = [[NSMutableArray alloc] init];
        NSString *thisID = [attributeDict objectForKey:@"id"];
        if (thisID)
          [currentEvent setIdentifier:thisID];
      }
    }
    // NSLog(@"pentabar: %d",pentabarf);
  }
  
  if (pentabarf){
    if ([elementName isEqualToString: @"pentabarf:event-id"] || [elementName isEqualToString: @"pentabarf:start"] || [elementName isEqualToString: @"pentabarf:end"] || [elementName isEqualToString: @"pentabarf:title"] || [elementName isEqualToString: @"location"] ||
        [elementName isEqualToString: @"pentabarf:subtitle"] || [elementName isEqualToString: @"abstract"] ||
        [elementName isEqualToString: @"pentabarf:track"] || [elementName isEqualToString: @"type"] ||
        [elementName isEqualToString: @"description"] || [elementName isEqualToString: @"attendee"]) {
      
      [currentStringValue setString: @""];
    }
  } else {
    if ([elementName isEqualToString: @"start"] || [elementName isEqualToString: @"duration"] ||
        [elementName isEqualToString: @"room"] || [elementName isEqualToString: @"title"] ||
        [elementName isEqualToString: @"subtitle"] || [elementName isEqualToString: @"track"] ||
        [elementName isEqualToString: @"type"] || [elementName isEqualToString: @"abstract"] ||
        [elementName isEqualToString: @"description"] || [elementName isEqualToString: @"person"]||
        [elementName isEqualToString: @"link"] ) {
      [currentStringValue setString: @""];
    }
    
  }
  
  /* if ([elementName isEqualToString: @"start"] || [elementName isEqualToString: @"duration"] ||
   [elementName isEqualToString: @"room"] || [elementName isEqualToString: @"title"] ||
   [elementName isEqualToString: @"subtitle"] || [elementName isEqualToString: @"track"] ||
   [elementName isEqualToString: @"type"] || [elementName isEqualToString: @"abstract"] ||
   [elementName isEqualToString: @"description"] || [elementName isEqualToString: @"person"]) {
   [currentStringValue setString: @""];
   }*/
  
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
  
  if (pentabarf) {
    if ([elementName isEqualToString: @"pentabarf:event-id"]) {
      [currentEvent setIdentifier: [NSString stringWithString: currentStringValue]];
    }
    
    if ([elementName isEqualToString: @"pentabarf:start"]) {
      NSDate *eventStartDate = [dateFormatter dateFromString: currentStringValue];
      [currentEvent setStartDate: eventStartDate];
    }
    
    if ([elementName isEqualToString: @"pentabarf:end"]) {
      NSDate *eventEndDate = [dateFormatter dateFromString: currentStringValue];
      [currentEvent setEndDate: eventEndDate];
    }
    
    if ([elementName isEqualToString: @"pentabarf:title"]) {
      [currentEvent setTitle: [NSString stringWithString: currentStringValue]];
    }
    
    if ([elementName isEqualToString: @"location"]) {
      [currentEvent setLocation: [NSString stringWithString: currentStringValue]];
    }
    
    if ([elementName isEqualToString: @"pentabarf:subtitle"]) {
      [currentEvent setSubtitle: [NSString stringWithString: currentStringValue]];
    }
    
    if ([elementName isEqualToString: @"pentabarf:track"]) {
      [currentEvent setTrack: [NSString stringWithString: currentStringValue]];
    }
    
    // Currently there dosn't seem to be an abstract object
    if ([elementName isEqualToString: @"abstract"]) {
      //[currentEvent setContentAbstract: [NSString stringWithString: currentStringValue]];
    }
    
    // Currently there dosn't seem to be a type object returning emtpy string atm
    if ([elementName isEqualToString: @"type"]) {
      //[currentEvent setType: [NSString stringWithString: currentStringValue]];
      [currentEvent setType: @""];
    }
    
    if ([elementName isEqualToString: @"description"]) {
      [currentEvent setContentDescription: [NSString stringWithString: currentStringValue]];
    }
    
    if ([elementName isEqualToString: @"attendee"]) {
      [currentEvent setSpeaker: [NSString stringWithString: currentStringValue]];
    }
    
    if ([elementName isEqualToString: @"vevent"]) {
      [delegate parser: self foundEvent: currentEvent];
    }
    
    if ([elementName isEqualToString: @"iCalendar"]) {
      [delegate parserDidFinishSchedule: self];
    }
  } else {
    // if ([elementName isEqualToString: @"event"]) {
    //   NSString *thisID = [attributeDict objectForKey:@"id"];
    //   [currentEvent setIdentifier: [NSString stringWithString: currentStringValue]];
    // }
    
    if ([elementName isEqualToString: @"start"]) {
      // TODO calculate date from day element + hm time
      NSCalendar* cal = [NSCalendar currentCalendar]; // get current calender
      NSDateComponents* totalYMDHM = [cal components:( NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit ) fromDate:currentDate];

      NSDate *eventStartDate = [dateFormatterHM dateFromString: currentStringValue];
      if (eventStartDate){
        NSDateComponents* currentHM = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:eventStartDate];
        [totalYMDHM setHour:[currentHM hour]];
        [totalYMDHM setMinute:[currentHM minute]];
      }
      totalStartDate = [cal dateFromComponents:totalYMDHM ];
      [currentEvent setStartDate: totalStartDate];
    }
    
    if ([elementName isEqualToString: @"duration"]) {
      // TODO: calculate time end from start+duration
      // duration is in HH:MM format
      NSDate *tmpDate = [dateFormatterHM dateFromString: currentStringValue];
      NSCalendar* cal = [NSCalendar currentCalendar]; // get current calender
      // make NSDateComponents
      NSDateComponents* currentHM = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit ) fromDate:tmpDate];
      NSTimeInterval theTimeInterval = 60*[currentHM minute]+3600*[currentHM hour];
      NSDate *eventEndDate = [totalStartDate dateByAddingTimeInterval:theTimeInterval];
      
      [currentEvent setEndDate: eventEndDate];
    }
    
    if ([elementName isEqualToString: @"title"]) {
      [currentEvent setTitle: [NSString stringWithString: currentStringValue]];
    }
    
    if ([elementName isEqualToString: @"room"]) {
      [currentEvent setLocation: [NSString stringWithString: currentStringValue]];
    }
    
    if ([elementName isEqualToString: @"subtitle"]) {
      [currentEvent setSubtitle: [NSString stringWithString: currentStringValue]];
    }
    
    if ([elementName isEqualToString: @"track"]) {
      [currentEvent setTrack: [NSString stringWithString: currentStringValue]];
    }
    
    // Currently there dosn't seem to be a type object returning emtpy string atm
    if ([elementName isEqualToString: @"type"]) {
      //[currentEvent setType: [NSString stringWithString: currentStringValue]];
      [currentEvent setType: @""];
    }

    if ([elementName isEqualToString: @"abstract"]) {
      if (currentEvent.contentDescription.length==0 ){
        [currentEvent setContentDescription: [NSString stringWithString: currentStringValue]];
      }
    }

    if ([elementName isEqualToString: @"description"]) {
      if (currentStringValue.length > 0){
        [currentEvent setContentDescription: [NSString stringWithString: currentStringValue]];
      }
    }
    
    if ([elementName isEqualToString: @"person"]) {
      [currentEvent setSpeaker: [NSString stringWithString: currentStringValue]];
    }


    
    if ([elementName isEqualToString: @"event"]) {
      [delegate parser: self foundEvent: currentEvent];
    }
    
    if ([elementName isEqualToString: @"schedule"]) {
      [delegate parserDidFinishSchedule: self];
    }
    
    //    if ([elementName isEqualToString: @"day"]) {
    //      [delegate parserDidFinishSchedule: self];
    //    }
    
  }
  
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
  
  [delegate parserFinishedParsing: self];
  
}

@end
