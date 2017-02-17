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


@implementation fosdemAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize currentyear;
@synthesize selectedyear;
@synthesize downloadString;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
  
    // set the currentyear, so we have a reference
    NSDate *today = [NSDate date];
    NSCalendar* cal = [NSCalendar currentCalendar]; // get current calender
    NSDateComponents* currentYearMonthDay = [cal components:( NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit  ) fromDate:today];
    // let's assume the next year is already available in september
  if ([currentYearMonthDay month] > 8){
    // let's assume the next year is already available
    currentyear = [NSNumber numberWithInt:((int)[currentYearMonthDay year]+1)];
  } else {
    currentyear = [NSNumber numberWithInteger:[currentYearMonthDay year]];
  }
  downloadString = [NSString stringWithFormat:@"%@%d%@", @"https://fosdem.org/", currentyear.intValue ,@"/schedule/xml"];
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


@end

