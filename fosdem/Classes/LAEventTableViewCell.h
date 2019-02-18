/* ----------------------------------------------------------------------------
* "THE BEER-WARE LICENSE" (Revision 42):
* Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
* wrote this file. As long as you retain this notice you
* can do whatever you want with this stuff. If we meet some day, and you think
* this stuff is worth it, you can buy us a beer in return.
* ----------------------------------------------------------------------------
*/

#import <UIKit/UIKit.h>
#import "LAEventDatabase.h"
#import "LAEvent.h"
@protocol CellDelegate <NSObject>
- (void)didClickOnStar:(NSInteger)cellIndex withData:(id)data;
- (void)didClickOnEvent:(NSInteger)cellIndex withData:(id)data;
- (void)didClickOnVideo:(NSInteger)cellIndex withData:(id)data;
@end

@interface LAEventTableViewCell : UITableViewCell
@property (weak, nonatomic) id<CellDelegate>delegate;
@property (assign, nonatomic) NSInteger cellIndex;

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (nonatomic, retain) IBOutlet UIButton *starButton;

@property (retain) NSString *identifier;
@property (retain) LAEvent *event;
-(IBAction) toggleStarred: (id) sender;
-(IBAction) selectEvent: (UIButton *) sender;
-(IBAction) selectVideo: (UIButton *) sender;

- (void) eventUpdated: (NSNotification *) notification;

@end

