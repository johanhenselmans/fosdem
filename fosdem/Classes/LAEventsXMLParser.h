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

#import "LAEvent.h"

@interface LAEventsXMLParser : NSObject <NSXMLParserDelegate> {
	
	NSString *currentDayString;
	NSMutableString *currentStringValue;
	LAEvent *currentEvent;
	NSDateFormatter *dateFormatter;
	NSDateFormatter *dateFormatterYMD;
	NSDateFormatter *dateFormatterHM;
}

- (LAEventsXMLParser *) initWithContentsOfFile: (NSString *) path delegate: (id) newDelegate;
//- (BOOL) parse;

@property (retain) id delegate;
@property (retain) NSXMLParser *eventsXMLParser;
@end


// The delegate interface
@interface NSObject (LAEventsXMLParser)

- (void) parser: (LAEventsXMLParser *) parser foundEvent: (LAEvent *) event;
- (void) parserFinishedParsing:(LAEventsXMLParser *)parser;
- (void) parserDidFinishSchedule: (LAEventsXMLParser *) parser;
@end
