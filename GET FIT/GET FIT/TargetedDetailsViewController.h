//
//  TargetedDetailsViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TargetedListViewController.h"
#import "WorkoutInfo.h"

@interface TargetedDetailsViewController : UIViewController{
    
    IBOutlet UILabel* dTitle;
    IBOutlet UIImageView* dImages;
    
    NSArray* animationImages;
    
}

@property (nonatomic, strong) WorkoutInfo* currentCell;

@end
