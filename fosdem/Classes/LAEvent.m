/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import "LAEvent.h"


@implementation LAEvent

@synthesize identifier, title, subtitle, speakers, speaker, location, track, type, contentVideo ,contentAbstract, contentDescription, startDate, endDate;

- (LAEvent *)init {

    if (self = [super init]) {

        // Set the following to an empty string in case they are not defined in the schedule file
        // Not doing this will reult in erroneous search results
        
        track = [[NSString alloc] init];
        speakers = [[NSMutableArray alloc] init];
        speaker = [[NSString alloc] init];
        
    }
    
    return self;

}

/*
- (NSMutableDictionary *) userData {
	return [[LAEventDatabase sharedEventDatabase] userDataForEventWithIdentifier: [self identifier]];
}*/

- (BOOL) isStarred {
    return starred;
}


- (void) setStarred:(BOOL) isStarred {
    starred = isStarred;
    NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys: [self identifier], @"identifier", [NSNumber  numberWithBool: isStarred], @"starred", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName: @"LAEventUpdated"
                                                        object: nil
                                                      userInfo: infoDict];
}

- (NSComparisonResult) compareDateWithEvent: (LAEvent *) otherEvent {
	return [[self startDate] compare: [otherEvent startDate]];
}

- (NSString *) speakerString{
  NSString * aSpeakerString = @"";
  for (int i = 0 ; i < speakers.count ; i++){
    // if there is more than one speaker, add a comma and the previous speakers.
    if (i > 0){
      aSpeakerString = [NSString stringWithFormat:@"%@,%@",aSpeakerString, (NSString *)speakers[i]];
    } else {
      aSpeakerString = [NSString stringWithFormat:@"%@", (NSString *)speakers[i]];
    }
  }
  return aSpeakerString;
}


@end
