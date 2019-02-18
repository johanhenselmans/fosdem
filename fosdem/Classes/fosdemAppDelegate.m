/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import "fosdemAppDelegate.h"
#include <stdlib.h>

@implementation fosdemAppDelegate

@synthesize window, tabBarController, currentyear, selectedyear, downloadString, occupancyString, occupancyDownloadDate, today;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	
	// set the currentyear, so we have a reference
	today = [NSDate date];
	// for testing only: notice times are in UTC
	//today = [[LAEventDatabase sharedEventDatabase] setTheDate:2019 month:2 day:2 hour:11 minute:24];

	NSCalendar* cal = [NSCalendar currentCalendar]; // get current calender
	NSDateComponents* currentYearMonthDay = [cal components:( NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay  ) fromDate:today];
	// let's assume the next year is already available in september
	if ([currentYearMonthDay month] > 8){
		// let's assume the next year is already available
		currentyear = [NSNumber numberWithInt:((int)[currentYearMonthDay year]+1)];
	} else {
		currentyear = [NSNumber numberWithInteger:[currentYearMonthDay year]];
	}
	//downloadString = [NSString stringWithFormat:@"%@%d%@", @"https://fosdem.org/", currentyear.intValue ,@"/schedule/xml"];
	occupancyString = [NSString stringWithFormat:@"%@", @"https://api.fosdem.org/roomstatus/v1/listrooms"];
	
	[self getOccupancy];
	// set a timer to run between 10 and 12 minutes to update the roomData.
	// As most of the meetings are at least half an hour, that should be enough
	[NSTimer scheduledTimerWithTimeInterval:600.0+arc4random_uniform(120)
    target:self
    selector:@selector(getOccupancy)
    userInfo:nil
    repeats:YES];
	// when we start, the selected year is the current year
	selectedyear = currentyear;
	// Set the root view controller to the tab bar controller
	[[self window] setRootViewController: tabBarController];
	

}


/*
 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
 }
 */

/*
 // Optional UITabBarControllerDelegate method
 - (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed {
 }
 */
- (void) getOccupancy  {
	NSError* error = nil;
	NSData *data = [NSData dataWithContentsOfURL: [NSURL URLWithString:self.occupancyString] options:kNilOptions error:&error];
	if (error) {
    NSLog(@"%@", [error localizedDescription]);
	}
	if (data != nil){
		[[NSFileManager defaultManager] createDirectoryAtPath: [[LAEventDatabase roomsDataFileLocation] stringByDeletingLastPathComponent] withIntermediateDirectories: NO attributes: nil error: nil];
	 	[data writeToFile: [LAEventDatabase roomsDataFileLocation] atomically: NO];
//		occupancyDownloadDate = [NSDate date];

	}
	// Only reset and load the database the first time: afterwards, just update the events that are current
	if( occupancyDownloadDate== nil){
		[LAEventDatabase resetMainEventDatabase];
	} else {
		[[LAEventDatabase sharedEventDatabase] updateCurrentEventsWithRoomData];
	}
	occupancyDownloadDate = [NSDate date];
	    NSLog(@"tried to pickup roomdata at: %@", occupancyDownloadDate );

}


@end

