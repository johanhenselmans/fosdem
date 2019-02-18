//
//  RoomData.m
//  fosdem
//
//  Created by Johan Henselmans on 17/02/2019.
//

#import <Foundation/Foundation.h>
#import "RoomData.h"

@implementation RoomData

@synthesize identifier, title, speakers, location, measureDate, occupied;

- (RoomData *)init {

    if (self = [super init]) {

        // Set the following to an empty string in case they are not defined in the schedule file
        // Not doing this will reult in erroneous search results
			
        title = [[NSString alloc] init];
        speakers = [[NSMutableArray alloc] init];
			
    }
	
    return self;
}

@end
