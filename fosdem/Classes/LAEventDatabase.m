/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import "LAEventDatabase.h"
#import "fosdemAppDelegate.h"

@implementation LAEventDatabase{
	}

@synthesize events, eventsUserData;
static LAEventDatabase *mainEventDatabase = nil;
fosdemAppDelegate * myapp;


+ (LAEventDatabase *) sharedEventDatabase
{
  
  if(mainEventDatabase == nil) {
    
    // Initialise the database with data from the stored xcal file
    
    mainEventDatabase = [[LAEventDatabase alloc] initWithContentsOfFile: [self eventDatabaseLocation]];
    
    // Register for notficiations of the database getting updated
    
     [[NSNotificationCenter defaultCenter] postNotificationName: @"LAEventDatabaseUpdated" object: self];
  }
  
  return mainEventDatabase;
  
}

+ (void) resetMainEventDatabase {
  
  // Get rid of the old shared instance and create a new one
  
  mainEventDatabase = nil;
		mainEventDatabase = [[LAEventDatabase alloc] initWithContentsOfFile: [self eventDatabaseLocation]];
  
  [LAEventDatabase sharedEventDatabase];
  
}

- (LAEventDatabase*) init {
	if (self = [super init]) {
    events = [[NSMutableArray alloc] init];
    //stared = [[NSMutableArray alloc] init];
    myapp = (fosdemAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    eventsOnDayCache = [[NSMutableDictionary alloc] init];
    
    //[[NSNotificationCenter defaultCenter] addObserver: self
    //                                         selector: @selector(eventDatabaseUpdated)
    //                                             name: @"LAEventDatabaseUpdated"
    //                                           object: nil];
  }
  return self;
}

- (LAEventDatabase *) initWithContentsOfFile: (NSString *) filePath {
  if (self = [self init]) {
    
    // Before the parsing because the userInfo dict is needed to set the properties
    NSMutableDictionary *userDataDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile: [LAEventDatabase userDataFileLocation]];
    if (!userDataDictionary) {
      userDataDictionary = [[NSMutableDictionary alloc] init];
    }
    
    [self setEventsUserData: userDataDictionary];
    
    LAEventsXMLParser *xmlParser = [[LAEventsXMLParser alloc] initWithContentsOfFile: filePath delegate: self];
    [xmlParser parse];
    
    // We react to an update after parsing because we don't want to rewrite what has just been read while parsing
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(eventUpdated:)
                                                 name: @"LAEventUpdated"
                                               object: nil];
  }
  
  return self;
}

- (void) parser: (LAEventsXMLParser *) parser foundEvent: (LAEvent *) event {
  [events addObject: event];
  [self updateEventWithUserData: event];
}

- (void) parserFinishedParsing:(LAEventsXMLParser *)parser {
  [events sortUsingSelector: @selector(compareDateWithEvent:)];
}

- (void) parserDidFinishSchedule:(LAEventsXMLParser *)parser {
  
}

- (NSArray *) uniqueDays {
  
  if (cachedUniqueDays != nil) {
    return cachedUniqueDays;
  }
  
  NSEnumerator *eventsEnumerator = [events objectEnumerator];
  LAEvent *currentEvent;
  
  NSMutableArray *uniqueDays = [[NSMutableArray alloc] init];
  NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
  
  while (currentEvent = [eventsEnumerator nextObject]) {
    if (currentEvent.startDate ){
      NSDateComponents *currentEventDateComponents = [calendar components: (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate: [currentEvent startDate]];
      // We have the date of the event. Now we have to loop through the existing unique dates to see if there already is a date like that.
      NSEnumerator *uniqueDaysEnumerator = [uniqueDays objectEnumerator];
      NSDate *currentUniqueDay;
      
      BOOL foundMatchingDay = NO;
      
      while (currentUniqueDay = [uniqueDaysEnumerator nextObject]) {
        NSDateComponents *uniqueDayDateComponents = [calendar components: (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate: currentUniqueDay];
        // Does the current looped unique day match the one we have from the event?
        if([uniqueDayDateComponents day] == [currentEventDateComponents day] && \
           [uniqueDayDateComponents month] == [currentEventDateComponents month] && \
           [uniqueDayDateComponents year] == [currentEventDateComponents year]) {
          // Our event does not have a unique date
          foundMatchingDay = YES;
          break;
          
        }
      }
      
      // If the day was already in the uniqueDays, we would have found it by now
      if (!foundMatchingDay) {
        // The event day is unique! Let's insert it!
        // Same shit, different day
        [currentEventDateComponents setSecond: 0];
        [currentEventDateComponents setMinute: 0];
        [currentEventDateComponents setHour: 0];
        
        [uniqueDays addObject: [calendar dateFromComponents: currentEventDateComponents]];
      }
    }
  }
  
  cachedUniqueDays = uniqueDays;
  return uniqueDays;
}

- (NSArray *) eventsOnDay: (NSDate *) dayDate {
  
  // Not really the way to do it but it probably works fine
  if ([eventsOnDayCache objectForKey: dayDate] != nil) {
    return [eventsOnDayCache objectForKey: dayDate];
  }
  
  NSEnumerator *eventsEnumerator = [events objectEnumerator];
  LAEvent *currentEvent;
  
  NSMutableArray *eventsOnDay = [NSMutableArray array];
  
  NSCalendar *calendar = [NSCalendar autoupdatingCurrentCalendar];
  
  while (currentEvent = [eventsEnumerator nextObject]) {
    NSDateComponents *currentEventDateComponents = [calendar components: (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate: [currentEvent startDate]];
    NSDateComponents *eventDateComponents = [calendar components: (NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate: dayDate];
    
    if([eventDateComponents day] == [currentEventDateComponents day] && \
       [eventDateComponents month] == [currentEventDateComponents month] && \
       [eventDateComponents year] == [currentEventDateComponents year]) {
      // Obviously the event is on the same day
      [eventsOnDay addObject: currentEvent];
    }
  }
  
  [eventsOnDayCache setObject: eventsOnDay forKey: dayDate];
  //NSLog(@"BOOM");
  return eventsOnDay;
}

-(NSArray *) tracks {
  
  if (tracksCache != nil) {
    return tracksCache;
  }
  
  NSEnumerator *eventsEnumerator = [events objectEnumerator];
  LAEvent *currentEvent;
  
  NSMutableArray *tracks = [[NSMutableArray alloc] init];
  
  while (currentEvent = [eventsEnumerator nextObject]){
    
    if (![tracks containsObject: [NSString stringWithFormat: @"%@", [currentEvent track]]]) {
      [tracks addObject: [NSString stringWithFormat: @"%@", [currentEvent track]]];
    }
    
  }
  //tracksCache = tracks;
  //return tracks;
  // we sort the tracks, so that we have a nice overview
  tracksCache = [tracks sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
  NSArray *trackssorted = [tracks sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
  return trackssorted;
}

- (NSMutableArray *) starredEvents {
  
  /*if (starredCache != nil) {
   return starredCache;
   }*/
  
  NSEnumerator *eventsEnumerator = [events objectEnumerator];
  LAEvent *currentEvent;
  
  NSMutableArray *starredEvents = [NSMutableArray array];
  
  while (currentEvent = [eventsEnumerator nextObject]){
    
    if ([currentEvent isStarred]) {
      [starredEvents addObject: currentEvent];
    }
  }
  
  //starredCache = starredEvents;
  
  return starredEvents;
  
}

- (NSMutableArray *) videoEvents {
  
  NSEnumerator *eventsEnumerator = [events objectEnumerator];
  LAEvent *currentEvent;
  
  NSMutableArray *videoEvents = [NSMutableArray array];
  
  while (currentEvent = [eventsEnumerator nextObject]){
    
    if ( [currentEvent contentVideo]!=nil ) {
      [videoEvents addObject: currentEvent];
    }
  }
  
  
  return videoEvents;
  
}


-(NSArray *) eventsForTrack: (NSString*) trackName {
  
  NSEnumerator *eventsEnumerator = [events objectEnumerator];
  LAEvent *currentEvent;
  
  NSMutableArray *eventsForTrackName = [NSMutableArray array];
  
  while (currentEvent = [eventsEnumerator nextObject]){
    
    if ([[currentEvent track] isEqualToString: trackName]) {
      [eventsForTrackName addObject: currentEvent];
    }
    
  }
  
  return eventsForTrackName;
  
}

+ (NSString *) eventDatabaseLocation {
  NSString *cacheFileLocation = [self cachedDatabaseLocation];
  if ([[NSFileManager defaultManager] fileExistsAtPath: cacheFileLocation]) {
    return cacheFileLocation;
  }
  
  NSString *resourcesDirectory = [[NSBundle mainBundle] bundlePath];
  //  NSString *schedulefile =[NSString stringWithFormat:@"fosdem_schedule%d.xml",2015];
  NSString *schedulefile =[NSString stringWithFormat:@"fosdem_schedule%d.xml",myapp.selectedyear.intValue];
  NSString *resourceFileLocation = [resourcesDirectory stringByAppendingPathComponent:schedulefile];
  return resourceFileLocation;
  
}

+ (NSString* ) cachedDatabaseLocation {
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *cachesDirectory = [paths objectAtIndex:0];
  NSString *cacheFileLocation = [cachesDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"fosdem_schedule%d.xml",myapp.selectedyear.intValue]];
  
  return cacheFileLocation;
  
}


+ (NSString *) userDataFileLocation {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentDirectory = [paths objectAtIndex:0];
  NSString *userDataFileLocation = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"userData%d.plist",myapp.selectedyear.intValue]];
  
  return userDataFileLocation;
}


- (NSMutableDictionary *) userDataForEventWithIdentifier: (NSString *) identifier {
  if ([eventsUserData objectForKey: identifier] == nil) {
    [eventsUserData setObject: [NSMutableDictionary dictionary] forKey: identifier];
  }
  return [eventsUserData objectForKey: identifier];
}

- (void) eventUpdated: (NSNotification *) notification {
  NSDictionary *infoDict = [notification userInfo];
  NSMutableDictionary *userData = [self userDataForEventWithIdentifier: [infoDict objectForKey: @"identifier"]];
  
  if ([infoDict objectForKey: @"starred"]) {
    // Change in the starred property
    [userData setObject: [infoDict objectForKey: @"starred"] forKey: @"starred"];
  }
  
  [[NSFileManager defaultManager] createDirectoryAtPath: [[LAEventDatabase userDataFileLocation] stringByDeletingLastPathComponent] withIntermediateDirectories: NO attributes: nil error: nil];
  
  [[self eventsUserData] writeToFile: [LAEventDatabase userDataFileLocation] atomically: NO];
}

- (void) updateEventWithUserData: (LAEvent *) event {
  
  NSMutableDictionary *userData = [self userDataForEventWithIdentifier: [event identifier]];
  if ([userData objectForKey: @"starred"]) {
    [event setStarred: [(NSNumber *)[userData objectForKey: @"starred"] boolValue]];
  }
}

- (NSArray *)eventsInTimeInterval:(NSTimeInterval) timeInterval afterDate:(NSDate *)startDate {
  NSMutableArray *selectedEvents = [NSMutableArray array];
  
  NSEnumerator *eventsEnumerator = [events objectEnumerator];
  LAEvent *currentEvent;
  
  while (currentEvent = [eventsEnumerator nextObject]){
    
    if ([[currentEvent startDate] isBetweenDate: startDate andDate: [startDate dateByAddingTimeInterval:timeInterval]]) {
      [selectedEvents addObject: currentEvent];
    }
  }
  return selectedEvents;
}

- (NSArray *) eventsWhile:(NSDate *)whileDate {
  
  NSMutableArray *selectedEvents = [NSMutableArray array];
  
  NSEnumerator *eventsEnumerator = [events objectEnumerator];
  LAEvent *currentEvent;
  
  while (currentEvent = [eventsEnumerator nextObject]){
    
    if ([whileDate isBetweenDate:[currentEvent startDate] andDate:[currentEvent endDate]]) {
      [selectedEvents addObject: currentEvent];
    }
  }
  return selectedEvents;
}


- (void) eventDatabaseUpdated: (NSNotification *) notification {
  
  // Clear out all the caches
  
  tracksCache = nil;
  cachedUniqueDays = nil;
  eventsOnDayCache = nil;
  
  eventsOnDayCache = [[NSMutableDictionary alloc] init];
  
}

- (NSString*) mapHTMLForEvent: (LAEvent*) event {
  
  //if ([[NSFileManager defaultManager] fileExistsAtPath: [NSString stringWithFormat: @"%@%@", [[NSBundle mainBundle] resourcePath], [event location]]])
  //NSLog([NSString stringWithFormat: @"%@/%@.png", [[NSBundle mainBundle] resourcePath], [event location]]);
  
  /* String for the path
   
   [NSString stringWithFormat: @"%@/%@.png", [[NSBundle mainBundle] resourcePath], [event location]];
   
   */
  
  if ([[NSFileManager defaultManager] fileExistsAtPath: [NSString stringWithFormat: @"%@/%@.png", [[NSBundle mainBundle] resourcePath], [event location]]]) {
    
    return [NSString stringWithFormat: @"<img src=\"%@/%@.png\" />", [[NSBundle mainBundle] resourcePath], [event location]];
    
  }
		
  return @"Map Not Found!";
  
}

- (NSString*) mapHTMLForConference {
  
  //if ([[NSFileManager defaultManager] fileExistsAtPath: [NSString stringWithFormat: @"%@%@", [[NSBundle mainBundle] resourcePath], [event location]]])
  //NSLog([NSString stringWithFormat: @"%@/%@.png", [[NSBundle mainBundle] resourcePath], [event location]]);
  
  /* String for the path
   
   [NSString stringWithFormat: @"%@/%@.png", [[NSBundle mainBundle] resourcePath], [event location]];
   
   */
  
  if ([[NSFileManager defaultManager] fileExistsAtPath: [NSString stringWithFormat: @"%@/%@", [[NSBundle mainBundle] resourcePath], @"ulb_solbosch.png"]]) {
    
    return [NSString stringWithFormat: @"<img src=\"%@/%@\" />", [[NSBundle mainBundle] resourcePath], @"ulb_solbosch.png"];
    
  }
		
  return @"Map Not Found!";
  
}


@end
