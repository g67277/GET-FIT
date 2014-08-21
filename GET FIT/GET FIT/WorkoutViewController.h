//
//  WorkoutViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "WorkoutFeed.h"
#import "settings.h"
#import "SettingsViewController.h"
static const int DEFAULT_WORKOUT_TIME = 4;
//static const int DEFAULT_RESTING = 10;

@interface WorkoutViewController : UIViewController <AVAudioPlayerDelegate>{
    
    IBOutlet UILabel *workTitle;
    IBOutlet UILabel *countDownLabel;
    IBOutlet UILabel *setLabel;
    IBOutlet UIImageView *animationImageView;
    
    // indicator images -- need to find a better way...
    IBOutlet UIImageView *indicator1;
    IBOutlet UIImageView *indicator2;
    IBOutlet UIImageView *indicator3;
    IBOutlet UIImageView *indicator4;
    IBOutlet UIImageView *indicator5;
    IBOutlet UIImageView *indicator6;
    IBOutlet UIImageView *indicator7;
    IBOutlet UIImageView *indicator8;
    IBOutlet UIImageView *indicator9;
    IBOutlet UIImageView *indicator10;
    //--------------------------------------------------
    IBOutlet UIButton* pause;
    
    //
    AVAudioPlayer* beepSound;
    
    BOOL resting;
    BOOL pauseWork;

    NSTimer* timer;
    
    int count;
    int indicatorCount;
    int workoutNum;
    int setNum;
    double numOfWorkoutSeconds;
    int dynamicWorkCount;
    int selectedRestCount;
    
    NSArray* incomingWorkoutList;
    NSMutableArray* workoutImages;
    
    WorkoutFeed* workoutFeed;
    
    settings* settingObject;
    SettingsViewController* settingsVC;

}
@property (nonatomic, assign) NSArray* targetedArrayWorkout;


- (IBAction)onClick:(UIButton*)sender;


@end
