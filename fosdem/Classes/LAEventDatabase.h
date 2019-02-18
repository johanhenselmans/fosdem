/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import <Foundation/Foundation.h>

#import "NSDate+Between.h"

#import "LAEvent.h"
#import "LAEventsXMLParser.h"

@interface LAEventDatabase : NSObject {
  
  NSMutableArray *events;
  
  NSMutableDictionary *eventsUserData;
  NSMutableArray *roomsData;

  //Caching CPU-intensive operations
  NSArray *cachedUniqueDays;
  NSMutableDictionary *eventsOnDayCache;
  NSArray *tracksCache;
  NSMutableDictionary *roomsDataCache;

}

+ (NSString *) eventDatabaseLocation;
+ (NSString *) userDataFileLocation;
+ (NSString *) roomsDataFileLocation;

+ (NSString* ) cachedDatabaseLocation;

+ (LAEventDatabase *) sharedEventDatabase;

//- (LAEventDatabase*) initWithDictionary: (NSDictionary *) dictionary;

- (LAEventDatabase *) initWithContentsOfFile: (NSString *) filePath;
- (void) parser: (LAEventsXMLParser *) parser foundEvent: (LAEvent *) event;
- (void) parserFinishedParsing:(LAEventsXMLParser *)parser;

- (NSArray *) uniqueDays;
- (NSArray *) eventsOnDay: (NSDate *) dayDate;

- (NSArray *) tracks;
- (NSArray *) eventsForTrack: (NSString*) trackName;
- (NSMutableArray *) starredEvents;
- (NSMutableArray *) videoEvents;
- (NSMutableArray *) freeEvents;

- (NSMutableDictionary *) userDataForEventWithIdentifier: (NSString *) identifier;
- (void) eventUpdated: (NSNotification *) notification;
- (void) updateEventWithUserData: (LAEvent *) event;
- (void) updateCurrentEventsWithRoomData;

- (NSArray *) eventsWhile:(NSDate *)whileDate;
- (NSArray *)eventsInTimeInterval:(NSTimeInterval) timeInterval afterDate:(NSDate *)startDate;
- (NSDate* ) setTheDate:(int)year month:(int)month day:(int)day hour:(int)hour minute:(int)minute;
// Clear out the caches
- (void) eventDatabaseUpdated;

+ (void) resetMainEventDatabase;

- (NSString*) mapHTMLForEvent: (LAEvent*) event;
- (NSString*) mapHTMLForConference;

@property (retain) NSMutableArray *events;
@property (retain) NSMutableDictionary *eventsUserData;
@property (retain) NSMutableArray *roomsData;

@end
