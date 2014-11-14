//
//  YearTableViewCell.m
//  fosdem
//
//  Created by Johan Henselmans on 12/11/14.
//
//

#import "YearTableViewCell.h"

@implementation YearTableViewCell

@synthesize yearLabel;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    
  }
  return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
