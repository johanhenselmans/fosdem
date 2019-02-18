/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import <UIKit/UIKit.h>

#import "LAEventDatabase.h"
#import "LAEventsTableViewController.h"

@interface fosdemAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	
	IBOutlet LAEventsTableViewController *eventsTableViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) NSNumber *currentyear;
@property (nonatomic, retain) NSNumber *selectedyear;
@property (nonatomic, retain) NSString *downloadString;
@property (nonatomic, retain) NSString *occupancyString;
@property (retain) NSDate *occupancyDownloadDate;
@property (retain) NSDate *today;

- (void) getOccupancy;

@end
