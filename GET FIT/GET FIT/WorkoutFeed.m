//
//  WorkoutFeed.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "WorkoutFeed.h"
#import "WorkoutInfo.h"

@implementation WorkoutFeed

- (NSMutableArray*) workoutArray{
    
    WorkoutInfo *workout1 = [[WorkoutInfo alloc]init];
    workout1.title = @"Bodyweight Arm and Leg Left";
    workout1.imageArray = @[@"armAndLegLift1.png", @"armAndLegLift2.png"];
    workout1.workoutTag = @"mid";
    
    WorkoutInfo *workout2 = [[WorkoutInfo alloc]init];
    workout2.title = @"Bodyweight Crunch";
    workout2.imageArray = @[@"crunch1.png", @"crunch2.png"];
    workout2.workoutTag = @"mid";
    
    WorkoutInfo *workout3 = [[WorkoutInfo alloc]init];
    workout3.title = @"Bicycle";
    workout3.imageArray = @[@"bicycle1.png", @"bicycle2.png"];
    workout3.workoutTag = @"sides";
    
    WorkoutInfo *workout4 = [[WorkoutInfo alloc]init];
    workout4.title = @"Heel Touch";
    workout4.imageArray = @[@"heelTouch1.png", @"heelTouch2.png"];
    workout4.workoutTag = @"sides";
    
    WorkoutInfo *workout5 = [[WorkoutInfo alloc]init];
    workout5.title = @"Ab V-Ups";
    workout5.imageArray = @[@"abVup1.png", @"abVup2.png"];
    workout5.workoutTag = @"upper";
    
    WorkoutInfo *workout6 = [[WorkoutInfo alloc]init];
    workout6.title = @"Hop";
    workout6.imageArray = @[@"hop1.png", @"hop2.png"];
    workout6.workoutTag = @"upper";
    
    WorkoutInfo *workout7 = [[WorkoutInfo alloc]init];
    workout7.title = @"Scissor Kick";
    workout7.imageArray = @[@"scissor1.png", @"scissor2.png"];
    workout7.workoutTag = @"lower";
    
    WorkoutInfo *workout8 = [[WorkoutInfo alloc]init];
    workout8.title = @"Pull in";
    workout8.imageArray = @[@"pullIn1.png", @"pullIn2.png"];
    workout8.workoutTag = @"lower";
    
    WorkoutInfo *workout9 = [[WorkoutInfo alloc]init];
    workout9.title = @"Trunk Rotation";
    workout9.imageArray = @[@"trunk1.png", @"trunk2.png"];
    workout9.workoutTag = @"sides";
    
    WorkoutInfo *workout10 = [[WorkoutInfo alloc]init];
    workout10.title = @"Leg Raise";
    workout10.imageArray = @[@"legRaise1.png", @"legRaise2.png"];
    workout10.workoutTag = @"mid";
    
    workoutArray = [[NSMutableArray alloc] initWithObjects:workout1, workout2, workout3, workout4, workout5, workout6, workout7, workout8, workout9, workout10, nil];
    
    return workoutArray;
}

@end
