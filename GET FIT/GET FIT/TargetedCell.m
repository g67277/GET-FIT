//
//  TargetedCell.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "TargetedCell.h"

@implementation TargetedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) refreshCellWithInfo: (NSString*) workoutTitle{

    workTitle.text = workoutTitle;
    workTitle.textColor = [UIColor darkGrayColor];
    workTitle.font = [UIFont fontWithName:@"GoodTimesRg-Regular" size:15];
    
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
