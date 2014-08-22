//
//  TrackingViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "GraphKit.h"


@interface TrackingViewController : UIViewController<GKLineGraphDataSource>{
    IBOutlet UISegmentedControl* chartType;
    
    UIImage *capturedScreen;
    
    NSManagedObject* matches;
    NSMutableArray* weightArray;
    NSMutableArray* sizeArray;
    
    //TESTING*******************************
    
}

@property (nonatomic, weak) IBOutlet GKLineGraph *graph;

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSArray *labels;

//testing to be deleted------------
@property (nonatomic, strong) IBOutlet UITextView *mainEvents;
//----------------

@property (nonatomic, retain) IBOutlet UIView *longPressView;


- (IBAction)onClick:(UIButton*)sender;


@end
