//
//  ViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/9/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "WorkoutFeed.h"


@interface ViewController : UIViewController{
    
    //Abs Diagram Buttons___________________________
    IBOutlet UIButton *upperBtn;
    IBOutlet UIButton *lowerBtn;
    IBOutlet UIButton *midBtn;
    IBOutletCollection(UIButton) NSArray *sidesBtn;
    //______________________________________________
    
    //Arrays to hold all workouts and filter by tag_
    NSArray* allWorkouts;
    NSMutableArray* targetedWorkoutArray;
    //______________________________________________
    
    WorkoutFeed* workoutFeed;
}



@end
