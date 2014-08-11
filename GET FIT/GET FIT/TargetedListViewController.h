//
//  TargetedListViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorkoutInfo.h"
#import "WorkoutFeed.h"
#import "TargetedCell.h"

@interface TargetedListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    IBOutlet UITableView* targetedTableView;
    
    // where the data is stored
    WorkoutFeed* workoutFeed;
    // custom object
    WorkoutInfo* currentCell;
    
}
// Targeted Array;
@property (nonatomic, assign) NSArray* targetedArray;

@end
