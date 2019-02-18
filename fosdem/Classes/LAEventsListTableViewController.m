//
//  LAEventsListTableViewController.m
//  fosdem
//
//  Created by Adam Ziolkowski on 26/12/2012.
//
//

#import "LAEventsListTableViewController.h"



@interface LAEventsListTableViewController ()

@end

@implementation LAEventsListTableViewController

@synthesize timeDateFormatter;
@synthesize sectionDateFormatter;
@synthesize events;


-(id) init {
  
  self = [super init];
  
  if (self){
    [self setEvents: [[LAEventCollection alloc] init]];
  }
  
  return self;
  
}

- (void)viewDidLoad {
  
  [super viewDidLoad];
	
	
  timeDateFormatter = [[NSDateFormatter alloc] init];
  [timeDateFormatter setDateFormat: @"HH:mm"];
  [timeDateFormatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 3600]];
  
  sectionDateFormatter = [[NSDateFormatter alloc] init];
  [sectionDateFormatter setDateFormat: @"EEEE, MMMM d yyyy"];
  [sectionDateFormatter setTimeZone: [NSTimeZone timeZoneForSecondsFromGMT: 3600]];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 140.0;

	[[NSNotificationCenter defaultCenter] addObserver: self
																					 selector: @selector(eventUpdated:)
																							 name: @"LAEventUpdated"
																						 object: nil];


}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
	
}

- (void) eventUpdated: (NSNotification *) notification {
  dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates
  		[[self tableView] reloadData];
    });
	
	}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  // Return the number of unique days in the event collection.
  
  return [[events uniqueDays] count];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [[[events eventsOnDay] objectForKey: (NSDate*)[[events uniqueDays] objectAtIndex: section]] count];
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  static NSString *CellIdentifier = @"LAEventTableViewCell";
  
  NSDate *eventDate = [[events uniqueDays] objectAtIndex: [indexPath section]];
  LAEvent *event = [[[events eventsOnDay] objectForKey: eventDate] objectAtIndex: [indexPath row]];
  
  LAEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  
  if (cell == nil) {
    
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LAEventTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex: 0];
    
  }
	
 	cell.delegate = self;
	cell.cellIndex = indexPath.row; // Set indexpath if its a grouped table.

  [[(LAEventTableViewCell*)cell titleLabel] setText: [event title]];
  [[(LAEventTableViewCell*)cell subtitleLabel] setText: [event speakerString]];
  [[(LAEventTableViewCell*)cell timeLabel] setText: [timeDateFormatter stringFromDate: [event startDate]]];
	if (event.occupied == YES){
		[[(LAEventTableViewCell*)cell timeLabel] setTextColor:[UIColor redColor]];
	}
	if (event.contentVideo == nil){
		[[(LAEventTableViewCell*)cell videoImage] setHidden:YES];
	}
  if (event.contentVideo == nil){
    [[(LAEventTableViewCell*)cell videoImage] setHidden:YES];
  }
		if (event.starred == YES){
		[[(LAEventTableViewCell*)cell starButton] setHighlighted:YES];
		[[cell starButton] setImage:[UIImage imageNamed: @"starOn.png"] forState:(UIControlState)UIControlStateHighlighted];
	} else {
		[[(LAEventTableViewCell*)cell starButton] setHighlighted:NO];
		[[cell starButton] setImage:[UIImage imageNamed: @"starOff.png"] forState:(UIControlState)UIControlStateNormal];
	}
	[(LAEventTableViewCell*)cell setEvent:event];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	[cell setNeedsLayout];
	[cell layoutIfNeeded];
	// [cell setNeedsDisplay];
	
	return cell;
	
}

- (void)didClickOnStar:(NSInteger)cellIndex withData:(id)data
{
	//NSLog(@"Start at Index: %ld clicked.\n Data received : %@", (long)cellIndex, data);
	LAEvent *event = data;
	if ([ event isStarred]) {
		[ event setStarred: NO];
	}
	else {
		[ event setStarred: YES];
	}
	NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys: [event identifier], @"identifier", [NSNumber  numberWithBool: [ event isStarred]], @"starred", nil];
	[[NSNotificationCenter defaultCenter] postNotificationName: @"LAEventUpdated"
																											object: nil
																										userInfo: infoDict];
}


- (void)didClickOnEvent:(NSInteger)cellIndex withData:(id)data
{
	// Do additional actions as required.
	//NSLog(@"Cell at Index: %ld clicked.\n Data received : %@", (long)cellIndex, data);
	LAEvent *event = data;
		LAEventDetailViewController *eventDetailViewController = [[LAEventDetailViewController alloc] initWithNibName: @"LAEventDetailViewController" bundle: [NSBundle mainBundle]];
	 [eventDetailViewController setEvent: event];
	 [[self navigationController] pushViewController: eventDetailViewController animated: YES];

}

- (void)didClickOnVideo:(NSInteger)cellIndex withData:(id)data
{
	// Do additional actions as required.
	//NSLog(@"Video at Index: %ld clicked.\n Data received : %@", (long)cellIndex, data);
	LAEvent *event = data;
	
	VDLViewController *vdlViewController = [[VDLViewController alloc] initWithNibName: @"VDLViewController" bundle: [NSBundle mainBundle]];
	
  [vdlViewController setContentVideo: [event contentVideo]];
  [[self navigationController] pushViewController: vdlViewController animated: YES];
}



- (NSString *)tableView: (UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
  // Get the date of the section
  
  NSDate *date = [[events uniqueDays] objectAtIndex: section];
  
  // Return string from date
  
  return [sectionDateFormatter stringFromDate: date];
  
  
}

#pragma mark - Table view delegate
/*
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSDate *date = [[events uniqueDays] objectAtIndex: [indexPath section]];
  
  LAEvent *selectedEvent = [[[events eventsOnDay] objectForKey: date] objectAtIndex: [indexPath row]];
  
  LAEventDetailViewController *eventDetailViewController = [[LAEventDetailViewController alloc] initWithNibName: @"LAEventDetailViewController" bundle: [NSBundle mainBundle]];
  
  [eventDetailViewController setEvent: selectedEvent];
  [[self navigationController] pushViewController: eventDetailViewController animated: YES];
  
}
*/
@end
