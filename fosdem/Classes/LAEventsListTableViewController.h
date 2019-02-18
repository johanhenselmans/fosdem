//
//  LAEventsListTableViewController.h
//  fosdem
//
//  Created by Adam Ziolkowski on 26/12/2012.
//
//

#import <UIKit/UIKit.h>
#import "LAEvent.h"
#import "LAEventTableViewCell.h"
#import "LAEventDetailViewController.h"
#import "LAEventCollection.h"
#import "VDLViewController.h"

@class LAEventCollection;

@interface LAEventsListTableViewController : UITableViewController <CellDelegate>

-(id) init;

@property (nonatomic, retain) LAEventCollection *events;
@property (nonatomic, retain) NSDateFormatter *timeDateFormatter;
@property (nonatomic, retain) NSDateFormatter *sectionDateFormatter;
- (void)didClickOnStar:(NSInteger)cellIndex withData:(id)data;
- (void)didClickOnEvent:(NSInteger)cellIndex withData:(id)data;
- (void)didClickOnVideo:(NSInteger)cellIndex withData:(id)data;

@end
