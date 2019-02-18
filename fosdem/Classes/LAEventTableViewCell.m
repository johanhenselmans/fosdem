/* ----------------------------------------------------------------------------
 * "THE BEER-WARE LICENSE" (Revision 42):
 * Adam Ziolkowski <adam@adsized.com> and Leon Handreke <leon.handreke@gmail.com>
 * wrote this file. As long as you retain this notice you
 * can do whatever you want with this stuff. If we meet some day, and you think
 * this stuff is worth it, you can buy us a beer in return.
 * ----------------------------------------------------------------------------
 */

#import "LAEventTableViewCell.h"


@implementation LAEventTableViewCell

@synthesize titleLabel, subtitleLabel, timeLabel, videoImage, starButton, identifier, event;


- (void) eventUpdated: (NSNotification *) notification {
  NSDictionary *infoDict = [notification userInfo];
  if (event.identifier == [infoDict objectForKey: @"identifier"]){
		if ([infoDict objectForKey: @"starred"]) {
			[starButton setImage:[UIImage imageNamed: @"starOn.png"] forState:(UIControlState)UIControlStateHighlighted];
			[self setNeedsDisplay];
		}
	}
	
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
			 [[NSNotificationCenter defaultCenter] addObserver: self
                                           selector: @selector(eventUpdated:)
                                               name: @"LAEventUpdated"
                                             object: nil];
    }
    return self;
}

/*
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
*/


-(IBAction) selectEvent: (UIButton *) sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnEvent:withData:)]) {
        [self.delegate didClickOnEvent:_cellIndex withData:event];
    }
}

-(IBAction) selectVideo: (UIButton *) sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnVideo:withData:)]) {
        [self.delegate didClickOnVideo:_cellIndex withData:event];
    }
}



-(IBAction) toggleStarred: (UIButton *) sender {
  if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnStar:withData:)]) {
        [self.delegate didClickOnStar:_cellIndex withData:event];
    }
/*
  if ([[self event] isStarred]) {
    [[self event] setStarred: NO];
  }
  else {
    [[self event] setStarred: YES];
  }
  NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys: [event identifier], @"identifier", [NSNumber  numberWithBool: [[self event] isStarred]], @"starred", nil];
  [[NSNotificationCenter defaultCenter] postNotificationName: @"LAEventUpdated"
                                                      object: nil
                                                    userInfo: infoDict];
*/
  }


@end
