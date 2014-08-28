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

- (NSMutableArray*) workoutArray: (BOOL) isTargeted{
    
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
    
    WorkoutInfo *workout11 = [[WorkoutInfo alloc]init];
    workout11.title = @"Crunch Cross Body";
    workout11.imageArray = @[@"crossBody1", @"crossBody2"];
    workout11.workoutTag = @"sides";
    
    WorkoutInfo *workout12 = [[WorkoutInfo alloc]init];
    workout12.title = @"Crunch Legs Bent in Air";
    workout12.imageArray = @[@"crunchLegBentInAir1", @"crunchLegBentInAir2"];
    workout12.workoutTag = @"lower";
    
    WorkoutInfo *workout13 = [[WorkoutInfo alloc]init];
    workout13.title = @"Crunch Legs Straight in Air";
    workout13.imageArray = @[@"cruchLegsStraightInAir1", @"cruchLegsStraightInAir2"];
    workout13.workoutTag = @"mid";
    
    WorkoutInfo *workout14 = [[WorkoutInfo alloc]init];
    workout14.title = @"Crunch Reverse";
    workout14.imageArray = @[@"crunchReverse1", @"crunchReverse2"];
    workout14.workoutTag = @"upper";
    
    WorkoutInfo *workout15 = [[WorkoutInfo alloc]init];
    workout15.title = @"Crunch Straight Hands";
    workout15.imageArray = @[@"crunchStraightHands1", @"crunchStraightHands2"];
    workout15.workoutTag = @"mid";
    
    WorkoutInfo *workout16 = [[WorkoutInfo alloc]init];
    workout16.title = @"Hip Extension";
    workout16.imageArray = @[@"hipExtension1", @"hipExtension2"];
    workout16.workoutTag = @"lower";
    
    WorkoutInfo *workout17 = [[WorkoutInfo alloc]init];
    workout17.title = @"Hip Raise";
    workout17.imageArray = @[@"hipRaise1", @"hipRaise2"];
    workout17.workoutTag = @"mid";
    
    WorkoutInfo *workout18 = [[WorkoutInfo alloc]init];
    workout18.title = @"Plank ";
    workout18.imageArray = @[@"plank.png", @"plank.png"];
    workout18.workoutTag = @"lower";
    
    WorkoutInfo *workout19 = [[WorkoutInfo alloc]init];
    workout19.title = @"Plank Jack";
    workout19.imageArray = @[@"plankJacks1.png", @"plankJacks2.png"];
    workout19.workoutTag = @"sides";
    
    WorkoutInfo *workout20 = [[WorkoutInfo alloc]init];
    workout20.title = @"Situp";
    workout20.imageArray = @[@"situp1.png", @"situp2.png"];
    workout20.workoutTag = @"mid";
    
    WorkoutInfo *workout21 = [[WorkoutInfo alloc]init];
    workout21.title = @"Twist";
    workout21.imageArray = @[@"twist1.png", @"twist2.png"];
    workout21.workoutTag = @"sides";
    
    WorkoutInfo *workout22 = [[WorkoutInfo alloc]init];
    workout22.title = @"Twist Russian";
    workout22.imageArray = @[@"twistRussion1.png", @"twistRussion2.png"];
    workout22.workoutTag = @"sides";
    
    WorkoutInfo *workout23 = [[WorkoutInfo alloc]init];
    workout23.title = @"Side Bridge";
    workout23.imageArray = @[@"sideBridge1.png", @"sideBridge2.png"];
    workout23.workoutTag = @"sides";
    
    WorkoutInfo *workout24 = [[WorkoutInfo alloc]init];
    workout24.title = @"Touch Left";
    workout24.imageArray = @[@"touchLeft1.png", @"touchLeft2.png"];
    workout24.workoutTag = @"sides";
    
    WorkoutInfo *workout25 = [[WorkoutInfo alloc]init];
    workout25.title = @"Wide Leg Cross Sit Ups";
    workout25.imageArray = @[@"wideLegCrossSitUps1.png", @"wideLegCrossSitUps2.png"];
    workout25.workoutTag = @"upper";
    
    WorkoutInfo *workout26 = [[WorkoutInfo alloc]init];
    workout26.title = @"Ball Pike";
    workout26.imageArray = @[@"ballPike1.png", @"ballPike2.png"];
    workout26.workoutTag = @"lower";
    
    WorkoutInfo *workout27 = [[WorkoutInfo alloc]init];
    workout27.title = @"Swiss Ball Jacknife";
    workout27.imageArray = @[@"ballJackknive1.png", @"ballJackknive2.png"];
    workout27.workoutTag = @"lower";
    
    workoutArray = [[NSMutableArray alloc] initWithObjects:workout1, workout2, workout3, workout4, workout5, workout6, workout7, workout8, workout9, workout10, workout11, workout12, workout13, workout14, workout15, workout16, workout17, workout18, workout19, workout20,workout21, workout22, workout23, workout24, workout25, workout26, workout27, nil];
    
    chosen_numbers = [[NSMutableArray alloc] init];
    
    randomWorkoutArray = [[NSMutableArray alloc] init];
    
    if (isTargeted) {
        for(int i = 0; i<10; i++) {
            int randomNum = [self generateRandomNumber];
            
            [randomWorkoutArray addObject:workoutArray[randomNum]];
        }
        return randomWorkoutArray;
    }else{
        return workoutArray;
    }
    
    return 0;
}

- (int) generateRandomNumber {
    int number = arc4random() % 27;
    
    if ([chosen_numbers indexOfObject:[NSNumber numberWithInt:number]]!=NSNotFound)
        number = [self generateRandomNumber];
    
    [chosen_numbers addObject:[NSNumber numberWithInt:number]];
    return number;
}

@end
