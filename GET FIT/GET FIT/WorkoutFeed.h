//
//  WorkoutFeed.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WorkoutInfo.h"

@interface WorkoutFeed : NSObject{
    
    WorkoutInfo* workoutInfo;
    
    NSMutableArray* workoutArray;
    NSMutableArray* randomWorkoutArray;
    
    NSMutableArray* chosen_numbers;
    
}

- (NSMutableArray*) workoutArray: (BOOL) isTargeted;

@end
