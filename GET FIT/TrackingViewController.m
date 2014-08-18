//
//  TrackingViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "TrackingViewController.h"
#import "TrackingInputViewController.h"


@interface TrackingViewController ()

@end

@implementation TrackingViewController
@synthesize mainEvents;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:73/255.0f green:139/255.0f blue:234/255.0f alpha:1]];
    self.view.backgroundColor = [UIColor gk_cloudsColor];
    
    NSLog(@"%d", chartType.tag);
    [self _setupExampleGraph];

        //    [self _setupTestingGraphHigh];
}

- (IBAction)onClick:(UIButton*)sender{
    if (chartType.selectedSegmentIndex == 0) {
        [self.graph reset];
        [self _setupExampleGraph];
    }else {
        [self.graph reset];
        [self _setupTestingGraphLow];
    }

}

- (IBAction) done:(UIStoryboardSegue*)segue{
    
    TrackingInputViewController *inputVC = segue.sourceViewController;
    
    
    NSString *currentEvent = [NSString stringWithFormat:@"%@\n", inputVC.eventString];
    NSString *allEvents = [mainEvents.text stringByAppendingString:currentEvent];
    NSLog(@"%@", allEvents);
    
    mainEvents.text = allEvents;
    
}

- (void)_setupExampleGraph {
    
    self.data = @[
                  @[@20, @40, @20, @60, @40, @140, @80],
                  //@[@40, @20, @60, @100, @60, @20, @60],
                  //@[@80, @60, @40, @160, @100, @40, @110],
                  //@[@120, @150, @80, @120, @140, @100, @0],
                  //                  @[@620, @650, @580, @620, @540, @400, @0]
                  ];
    
    self.labels = @[@"2001", @"2002", @"2003", @"2004", @"2005", @"2006", @"2007"];
    
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    
    self.graph.valueLabelCount = 6;
    
    [self.graph draw];
}

- (void)_setupTestingGraphLow {
    
    /*
     A custom max and min values can be achieved by adding
     values for another line and setting its color to clear.
     */
    
    self.data = @[
                  @[@10, @4, @8, @2, @9, @3, @6],
                  @[@1, @2, @3, @4, @5, @6, @10]
                  ];
    //    self.data = @[
    //                  @[@2, @2, @2, @2, @2, @2, @6],
    //                  @[@1, @1, @1, @1, @1, @1, @1]
    //                  ];
    
    self.labels = @[@"2001", @"2002", @"2003", @"2004", @"2005", @"2006", @"2007"];
    
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    
    //    self.graph.startFromZero = YES;
    self.graph.valueLabelCount = 10;
    
    [self.graph draw];
}

- (void)_setupTestingGraphHigh {
    
    self.data = @[
                  @[@1000, @2000, @3000, @4000, @5000, @6000, @10000]
                  ];
    
    self.labels = @[@"2001", @"2002", @"2003", @"2004", @"2005", @"2006", @"2007"];
    
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    
    //    self.graph.startFromZero = YES;
    self.graph.valueLabelCount = 10;
    
    [self.graph draw];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Event Handlers

- (IBAction)onButtonDraw:(id)sender {
    [self.graph reset];
    [self.graph draw];
}

- (IBAction)onButtonReset:(id)sender {
    [self.graph reset];
}


#pragma mark - GKLineGraphDataSource

- (NSInteger)numberOfLines {
    return [self.data count];
}

- (UIColor *)colorForLineAtIndex:(NSInteger)index {
    id colors = @[[UIColor gk_turquoiseColor],
                  [UIColor gk_peterRiverColor],
                  [UIColor gk_alizarinColor],
                  [UIColor gk_sunflowerColor]
                  ];
    return [colors objectAtIndex:index];
}

- (NSArray *)valuesForLineAtIndex:(NSInteger)index {
    return [self.data objectAtIndex:index];
}

- (CFTimeInterval)animationDurationForLineAtIndex:(NSInteger)index {
    return [[@[@3, @1.6, @2.2, @1.4] objectAtIndex:index] doubleValue];
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}


@end
