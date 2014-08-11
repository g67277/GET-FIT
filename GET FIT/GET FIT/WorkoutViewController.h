//
//  WorkoutViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutFeed.h"
static const int DEFAULT_WORKOUT_TIME = 30;
static const int DEFAULT_RESTING = 10;

@interface WorkoutViewController : UIViewController{
    
    IBOutlet UILabel *workTitle;
    IBOutlet UILabel *countDownLabel;
    IBOutlet UIImageView *animationImageView;
    
    IBOutlet UIButton* pause;
    
    BOOL resting;
    BOOL pauseWork;

    NSTimer* timer;
    
    int count;
    int workoutNum;
    int setNum;
    int numOfWorkoutSeconds;
    
    NSArray* allWorkouts;
    NSMutableArray* workoutImages;
    
    WorkoutFeed* workoutFeed;

}

- (IBAction)onClick:(UIButton*)sender;


@end
