//
//  WorkoutViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutFeed.h"

@interface WorkoutViewController : UIViewController{
    
    IBOutlet UILabel *countDownLabel;
    IBOutlet UIImageView *animationImageView;
    
    BOOL resting;
    BOOL pauseWork;

    NSTimer* timer;
    
    int count;
    int workoutNum;
    int setNum;
    int numOfWorkoutSeconds;
    
    NSArray* allWorkouts;
    
    WorkoutFeed* workoutFeed;

}

- (IBAction)onClick:(UIButton*)sender;


@end
