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


@interface LAEvent : NSObject {

    NSString *identifier;
    
    NSString *title;
    NSString *subtitle;
    NSMutableArray *speakers;
    
    NSString *location;
    NSString *track;
    NSString *type;
    
    NSString *contentVideo;
    NSString *contentAbstract;
    NSString *contentDescription;
    
    NSDate *startDate;
    NSDate *endDate;
    
    BOOL starred;
    BOOL occupied;
}

//- (NSMutableDictionary *) userData;
- (NSComparisonResult) compareDateWithEvent: (LAEvent *) otherEvent;

@property (retain) NSString *identifier;
@property (retain) NSString *title;
@property (retain) NSString *subtitle;
@property (retain) NSMutableArray *speakers;
@property (retain) NSString *speaker;
@property (retain) NSString *location;
@property (retain) NSString *track;
@property (retain) NSString *type;
@property (retain) NSString *contentVideo;
@property (retain) NSString *contentAbstract;
@property (retain) NSString *contentDescription;

@property (retain) NSDate *startDate;
@property (retain) NSDate *endDate;

@property (assign, getter=isStarred) BOOL starred;
@property (assign, getter=isOccupied) BOOL occupied;
- (NSString *) speakerString;

@end
