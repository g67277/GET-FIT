//
//  ViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/9/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "ViewController.h"
#import "WorkoutInfo.h"
#import "TargetedListViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    workoutFeed = [[WorkoutFeed alloc] init];
    allWorkouts = [workoutFeed workoutArray];
    targetedWorkoutArray = [[NSMutableArray alloc] init];
    
    
    // Setting page title and custimizing the look
    NSString* title = @"GET FIT";
    self.navigationItem.title = title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GoodTimesRg-Regular" size:35]}];    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:73/255.0f green:139/255.0f blue:234/255.0f alpha:1]];
    
}


//-----------------------------------Tag Filter Function--------------------------------
- (void) workoutFilter: (NSString*) tag{
    [targetedWorkoutArray removeAllObjects];
    for (int i = 0; i < [allWorkouts count]; i++) {
        NSString* incomingTag = [allWorkouts[i] valueForKey:@"workoutTag"];
        if (tag == incomingTag) {
            WorkoutInfo* workoutInfo = allWorkouts[i];
            [targetedWorkoutArray addObject:workoutInfo];
        }
    }
}
//--------------------------------------------------------------------------------------

#pragma Segue

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier  isEqual: @"toUpper"]) {
        [self workoutFilter:@"upper"];
        TargetedListViewController* listView = segue.destinationViewController;
        listView.targetedArray = targetedWorkoutArray;
    }else if ([segue.identifier isEqual: @"toMid"]){
        [self workoutFilter:@"mid"];
        TargetedListViewController* listView = segue.destinationViewController;
        listView.targetedArray = targetedWorkoutArray;
    }else if ([segue.identifier isEqual: @"toLower"]){
        [self workoutFilter:@"lower"];
        TargetedListViewController* listView = segue.destinationViewController;
        listView.targetedArray = targetedWorkoutArray;
    }else if ([segue.identifier isEqual: @"toSides"]){
        [self workoutFilter:@"sides"];
        TargetedListViewController* listView = segue.destinationViewController;
        listView.targetedArray = targetedWorkoutArray;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
