//
//  YearTableViewController.m
//  fosdem
//
//  Created by Johan Henselmans on 12/11/14.
//
//

#import "YearTableViewController.h"
#import "YearTableViewCell.h"
#import "LAEventsTableViewController.h"

@interface YearTableViewController ()

@end


NSMutableArray *yearArray;
NSDateComponents* currentYearMonthDay ;
int lastYear;



@implementation YearTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Uncomment the following line to preserve selection between presentations.
  // self.clearsSelectionOnViewWillAppear = NO;
  
  // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
  // self.navigationItem.rightBarButtonItem = self.editButtonItem;
  NSDate *today = [NSDate date];
  NSCalendar* cal = [NSCalendar currentCalendar]; // get current calender
  currentYearMonthDay = [cal components:( NSYearCalendarUnit| NSMonthCalendarUnit| NSDayCalendarUnit  ) fromDate:today];
  if ([currentYearMonthDay month] > 8){
    // let's assume the next year is already available
    lastYear = (int)[currentYearMonthDay year]+1;
  }
  
  // first, get the most recent year. Next create an NSArray of years.
  yearArray = [NSMutableArray array];
  int i = 0;
  for (i = 2013; i <= lastYear; i++){
    [yearArray addObject:[NSNumber numberWithInt:i]];
  }
  // NSLog(@"yearArray: %@, currentyear: %ld", yearArray, (long)[currentYearMonthDay year]);
  
  [[NSNotificationCenter defaultCenter] addObserver: self
                                           selector: @selector(eventDatabaseUpdated)
                                               name: @"LAEventDatabaseUpdated"
                                             object: nil];
  
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) eventDatabaseUpdated {
  //TODO here we should set the current year as selected
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return yearArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YearCell" forIndexPath:indexPath];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YearCell"];
  
  if (cell == nil) {
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"YearTableViewCell" owner:self options:nil];
    cell = [nib objectAtIndex: 0];
  }
  
  // Configure the cell...
  [[ (YearTableViewCell *)cell yearLabel] setText: [yearArray[indexPath.row] stringValue]];
  
  return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
  NSNumber *selectedYear = yearArray[[indexPath row]];
  
  LAEventsTableViewController *eventsTableViewController = [[LAEventsTableViewController alloc] initWithNibName: @"LAEventsTableViewController" bundle: [NSBundle mainBundle]];
  BOOL currentyear = true;
  if ([selectedYear integerValue]!= lastYear){
    currentyear = false;
  }
  //[eventsTableViewController setYear: selectedYear : currentyear ];
  [eventsTableViewController setYear:selectedYear currentYear:currentyear];
  [[self navigationController] pushViewController: eventsTableViewController animated: YES];
  
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
