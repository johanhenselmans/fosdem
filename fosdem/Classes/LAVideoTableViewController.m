/*
 * ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import "LAVideoTableViewController.h"


@implementation LAVideoTableViewController



- (void)viewDidLoad {
    
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(eventDatabaseUpdated)
                                                 name: @"LAEventDatabaseUpdated"
                                               object: nil];
    
}


- (void)eventDatabaseUpdated {

    [[self tableView] reloadData];

}


- (void)didReceiveMemoryWarning {
    
	// Releases the view if it doesn't have a superview.
    
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
    
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
    return [[[LAEventDatabase sharedEventDatabase] videoEvents] count];

}

- (LAEvent *)eventForRowAtIndexPath:(NSIndexPath *)indexPath {
  LAEvent *event = nil;
  event = [[[LAEventDatabase sharedEventDatabase] videoEvents] objectAtIndex: indexPath.row];
  return event;
}

- (NSString *)tableView: (UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return nil;
}


@end

