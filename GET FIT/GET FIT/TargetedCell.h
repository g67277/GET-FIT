//
//  TargetedCell.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TargetedCell : UITableViewCell{
    
    IBOutlet UILabel* workTitle;
}

- (void) refreshCellWithInfo: (NSString*) workoutTitle;

@end
