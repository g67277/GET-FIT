//
//  TrackingViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "AppDelegate.h"
#import "TrackingViewController.h"
#import "TrackingInputViewController.h"
#import "M13ContextMenu.h"
#import "M13ContextMenuItemIOS7.h"


@interface TrackingViewController () <M13ContextMenuDelegate>

@end

@implementation TrackingViewController{
    
    M13ContextMenu *menu;
    UILongPressGestureRecognizer *longPress;
}

- (void) viewDidLayoutSubviews{
    
    CGRect frame= monthFormat.frame;
    [monthFormat setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 60)];
    CGRect frame2= chartType.frame;
    [chartType setFrame:CGRectMake(frame2.origin.x, frame2.origin.y, frame2.size.width, 60)];
    
}


- (void) viewWillAppear:(BOOL)animated{
    [self retriveCoreData];
    // THis is to change the chart input

    if (isData) {
        chartType.enabled = YES;
        if (chartTypeSelected == 0) {
            [self _setupWeightGraph];
        }else{
            [self _setupWeistSizeGraph];
        }
    }else{
        chartType.enabled = NO;
    }
    

}

- (void)viewDidLoad {

    [super viewDidLoad];
    //[self retriveCoreData];
    
    headerBackground.backgroundColor = [UIColor colorWithRed:73/255.0f
                                                       green:139/255.0f
                                                        blue:234/255.0f
                                                       alpha:1.0f];
    headerLabel.text = @"Tracking";
    headerLabel.font = [UIFont fontWithName:@"GoodTimesRg-Regular" size:25];
    [[UISegmentedControl appearance] setTintColor:[UIColor colorWithRed:73/255.0f
                                                                  green:139/255.0f
                                                                   blue:234/255.0f
                                                                  alpha:1.0f]];
    

    UIFont *font = [UIFont fontWithName:@"GoodTimesRg-Regular" size:20];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    [monthFormat setTitleTextAttributes:attributes
                               forState:UIControlStateNormal];
    [chartType setTitleTextAttributes:attributes
                             forState:UIControlStateNormal];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:73/255.0f green:139/255.0f blue:234/255.0f alpha:1]];
    [self.navigationController setNavigationBarHidden:YES];

    self.view.backgroundColor = [UIColor whiteColor];
    
    //------------------------------------------------------------------
    
    
    // for sharing------------------------------------------------------------------
    //Create the items
    M13ContextMenuItemIOS7 *facebook = [[M13ContextMenuItemIOS7 alloc] initWithUnselectedIcon:[UIImage imageNamed:@"facebookselected"] selectedIcon:[UIImage imageNamed:@"facebook"]];
    M13ContextMenuItemIOS7 *twitter = [[M13ContextMenuItemIOS7 alloc] initWithUnselectedIcon:[UIImage imageNamed:@"UploadIcon"] selectedIcon:[UIImage imageNamed:@"UploadIconSelected"]];
	//Create the menu
    menu = [[M13ContextMenu alloc] initWithMenuItems:@[facebook, twitter]];
    menu.delegate = self;
    
    //Create the gesture recognizer
    longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:menu action:@selector(showMenuUponActivationOfGetsure:)];
    [_longPressView setUserInteractionEnabled:YES];
    [_longPressView addGestureRecognizer:longPress];
    //------------------------------------------------------------------

    

    self.labels = @[@"1-5", @"6-9", @"10-14", @"15-18", @"19-23", @"24-27", @"28-31"];
    chartFormat = 0;
    chartTypeSelected = 0;

}

- (void) retriveCoreData{
    
    // Core data items -------------------------------------------------
    weightArray = [[NSMutableArray alloc] initWithObjects:@0, @0, @0, @0, @0, @0, @0, nil];
    sizeArray = [[NSMutableArray alloc] initWithObjects:@0, @0, @0, @0, @0, @0, @0, nil];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    // We want the contact entity, (this is where you can select the entity if there are more than one)
    NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"WeightNWeistSize" inManagedObjectContext:context];
    // initialzing a fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // passing in the entity
    [request setEntity:entityDesc];
    [request setPropertiesToFetch:@[@"weight"]];
    matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    [self filterData:objects];

    
}

- (void) facebookRefresh{
    
    SLComposeViewController* slComposeViewController;
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        slComposeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [slComposeViewController addImage:capturedScreen];
        [self presentViewController:slComposeViewController animated:NO completion:NULL];
    }else{
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"No Facebook Account" message:@"There are no Facebook accounts on this device.  Please add an account in settings and try again." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    
}


- (void) twitterRefresh{
    
    ACAccountStore *accountStore = [[ACAccountStore alloc]init];
    if (accountStore != nil) {
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter ];
        if (accountType != nil) {
            [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
                if (granted) {
                    
                }else{
                    
                }
            }];
        }
    }
    
}

- (IBAction)onClick:(UIButton*)sender{
    if (sender.tag == 0) {
        if (chartType.selectedSegmentIndex == 0) {
            [self.graph reset];
            [self _setupWeightGraph];
            chartTypeSelected = 0;
            [self viewDidLayoutSubviews];

        }else {
            [self.graph reset];
            [self _setupWeistSizeGraph];
            chartTypeSelected = 1;
            [self viewDidLayoutSubviews];

        }

    }
    if (sender.tag == 1){
        
        if (monthFormat.selectedSegmentIndex == 0) {
            [self chartMonthFormat:0];
        }else if (monthFormat.selectedSegmentIndex == 1){
            [self chartMonthFormat:1];
        }else if (monthFormat.selectedSegmentIndex == 2){
            [self chartMonthFormat:2];
        }
    }
    
}

- (void) chartMonthFormat:(int) num{
    
    switch (num) {
        
        case 0:
            self.labels = @[@"1-5", @"6-9", @"10-14", @"15-18", @"19-23", @"24-27", @"28-31"];
            chartFormat = 0;
            [self viewWillDisappear:NO];
            [self viewWillAppear:NO];
            [self viewDidLayoutSubviews];
            break;
        case 1:
            self.labels = @[@"1-8", @"9-16", @"17-24", @"25-31", @"32-42", @"43-51", @"52-60"];
            chartFormat = 1;
            [self viewWillDisappear:NO];
            [self viewWillAppear:NO];
            [self viewDidLayoutSubviews];
            break;
        case 2:
            self.labels = @[@"1-10", @"11-20", @"21-31", @"32-46", @"47-60", @"61-75", @"76-90"];
            chartFormat = 2;
            [self viewWillDisappear:NO];
            [self viewWillAppear:NO];
            [self viewDidLayoutSubviews];
            break;
        default:
            break;
    }
    
}

- (void)contextMenu:(M13ContextMenu *)contextMenu atPoint:(CGPoint)point didSelectItemAtIndex:(NSInteger)index
{
    if (index == 0) {
        [self captureScreen];
        [self facebookRefresh];
        
    } else if (index == 1) {
        
        [self twitterRefresh];
        [self captureScreen];
        [self showTweetSheet];
        
    }

}

- (void) captureScreen{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (void)showTweetSheet
{
    //  Create an instance of the Tweet Sheet
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any required UI
    // updates occur on the main queue
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                break;
        }
    };
    
    //  Adds an image to the Tweet.  For demo purposes, assume we have an
    //  image named 'larry.png' that we wish to attach
    if (![tweetSheet addImage:capturedScreen]) {
        NSLog(@"Unable to add the image!");
    }

    //  Presents the Tweet Sheet to the user
    [self presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}

- (IBAction) done:(UIStoryboardSegue*)segue{

}

- (void)_setupWeightGraph {
    
    
    self.data = @[
                  @[weightArray[0], weightArray[1], weightArray[2], weightArray[3], weightArray[4], weightArray[5], weightArray[6]],
                  //@[@40, @20, @60, @100, @60, @20, @60],
                  //@[@80, @60, @40, @160, @100, @40, @110],
                  //@[@120, @150, @80, @120, @140, @100, @0],
                  //                  @[@620, @650, @580, @620, @540, @400, @0]
                  ];

    

    
    //self.labels = @[@"", @"1-5", @"6-10", @"11-15", @"16-20", @"21-25", @"25-31"];
    
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    
    self.graph.valueLabelCount = 6;
    
    [self.graph draw];
    [self.graph reset];
    [self.graph draw];

}

- (void)_setupWeistSizeGraph {

    /*
     A custom max and min values can be achieved by adding
     values for another line and setting its color to clear.
     */
    
    self.data = @[
                  @[sizeArray[0], sizeArray[1], sizeArray[2], sizeArray[3], sizeArray[4], sizeArray[5], sizeArray[6]],
                  //@[@40, @20, @60, @100, @60, @20, @60],
                  //@[@80, @60, @40, @160, @100, @40, @110],
                  //@[@120, @150, @80, @120, @140, @100, @0],
                  //                  @[@620, @650, @580, @620, @540, @400, @0]
                  ];
    
    
    
    
    //self.labels = @[@"", @"1-5", @"6-10", @"11-15", @"16-20", @"21-25", @"25-31"];
    
    self.graph.dataSource = self;
    self.graph.lineWidth = 3.0;
    
    //    self.graph.startFromZero = YES;
    self.graph.valueLabelCount = 6;
    
    [self.graph draw];
    [self.graph reset];
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
    id colors = @[[UIColor gk_alizarinColor],
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
    return [[@[@1.2, @1.6, @2.2, @1.4] objectAtIndex:index] doubleValue];
}

- (NSString *)titleForLineAtIndex:(NSInteger)index {
    return [self.labels objectAtIndex:index];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

// Data filter-----------------------------
- (void) filterData: (NSArray*) objects{
    
    // nsnumber formator
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber;
    //-----------------
    
    
    if ([objects count] == 0) {
        NSLog(@"No matches");
        isData = NO;
        // put an alert here
    }else{
        isData = YES;
        for (int i = 0; i < [objects count]; i++) {
            matches = objects[i];
            
            NSString *dateDayCompareString = [[matches valueForKey:@"entryDate"] substringToIndex:[[matches valueForKey:@"entryDate"] length]-9];
            NSString *monthNday = [[matches valueForKey:@"entryDate"] substringToIndex:[[matches valueForKey:@"entryDate"] length]-6];
            NSString *dateMonthCompareString = [monthNday substringFromIndex:4];
            
            int dateCompare = [dateDayCompareString intValue];
            int monthCompare = [dateMonthCompareString intValue];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:@"unitType"]){
                
                if (chartFormat == 0) {
                    if (dateCompare > 0 && dateCompare <= 5 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            myNumber = [self convertToKg:myNumber];
                            weightArray[0] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            myNumber = [self converToCm:myNumber];
                            sizeArray[0] = myNumber;
                        }
                        
                    }else if (dateCompare >= 6 && dateCompare <= 9 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            myNumber = [self convertToKg:myNumber];
                            weightArray[1] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            myNumber = [self converToCm:myNumber];
                            sizeArray[1] = myNumber;
                        }
                        
                    }else if (dateCompare >= 10 && dateCompare <= 14 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            myNumber = [self convertToKg:myNumber];
                            weightArray[2] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            myNumber = [self converToCm:myNumber];
                            sizeArray[2] = myNumber;
                        }
                        
                    }else if (dateCompare >= 15 && dateCompare <= 18 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            myNumber = [self convertToKg:myNumber];
                            weightArray[3] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            myNumber = [self converToCm:myNumber];
                            sizeArray[3] = myNumber;
                        }
                        
                    }else if (dateCompare >= 19 && dateCompare <= 23 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            myNumber = [self convertToKg:myNumber];
                            [weightArray replaceObjectAtIndex:4 withObject:myNumber];
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            myNumber = [self converToCm:myNumber];
                            [sizeArray replaceObjectAtIndex:4 withObject:myNumber];
                        }
                        
                    }else if (dateCompare >= 24 && dateCompare <= 27 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            myNumber = [self convertToKg:myNumber];
                            weightArray[5] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            myNumber = [self converToCm:myNumber];
                            sizeArray[5] = myNumber;
                        }
                        
                    }else if (dateCompare >= 28 && dateCompare <= 31 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            myNumber = [self convertToKg:myNumber];
                            weightArray[6] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            myNumber = [self converToCm:myNumber];
                            sizeArray[6] = myNumber;
                        }
                        
                    }

                }
                if (chartFormat == 1) {
                    
                    int initialMonth;
                    
                    if (i == 0) {
                        initialMonth = monthCompare;
                    }
                    
                    if (monthCompare == initialMonth) {
                        
                        if (dateCompare > 0 && dateCompare < 9 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[0] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[0] = myNumber;
                            }
                            
                        }else if (dateCompare > 8 && dateCompare < 17 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[1] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[1] = myNumber;
                            }
                            
                        }else if (dateCompare > 16 && dateCompare < 25 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[2] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[2] = myNumber;
                            }
                            
                        }else if (dateCompare > 24 && dateCompare < 32 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[3] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[3] = myNumber;
                            }
                            
                        }
                        
                        
                    }else if (monthCompare == initialMonth + 1){
                        
                        dateCompare = dateCompare + 30;

                        
                        if (dateCompare > 31 && dateCompare < 43 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                [weightArray replaceObjectAtIndex:4 withObject:myNumber];
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                [sizeArray replaceObjectAtIndex:4 withObject:myNumber];
                            }
                            
                        }else if (dateCompare >= 43 && dateCompare <= 51 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[5] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[5] = myNumber;
                            }
                            
                        }else if (dateCompare >= 52 && dateCompare <= 60 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[6] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[6] = myNumber;
                            }
                            
                        }
                        
                    }
                }
                
                if (chartFormat == 2) {
                    
                    int initialMonth;
                    
                    if (i == 0) {
                        initialMonth = monthCompare;
                    }
                    
                    if (monthCompare == initialMonth) {
                        
                        if (dateCompare > 0 && dateCompare <= 10 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[0] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[0] = myNumber;
                            }
                            
                        }else if (dateCompare >= 11 && dateCompare <= 20 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[1] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[1] = myNumber;
                            }
                            
                        }else if (dateCompare >= 21 && dateCompare <= 31 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[2] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[2] = myNumber;
                            }
                            
                        }
                        
                    }else if (monthCompare == initialMonth + 1){
                        
                        dateCompare = dateCompare + 30;

                        
                        if (dateCompare >= 32 && dateCompare <= 46 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[3] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[3] = myNumber;
                            }
                            
                        }else if (dateCompare >= 47 && dateCompare <= 60 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                [weightArray replaceObjectAtIndex:4 withObject:myNumber];
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                [sizeArray replaceObjectAtIndex:4 withObject:myNumber];
                            }
                            
                        }
                    }else if (monthCompare == initialMonth + 2){
                        
                        dateCompare = dateCompare + 60;
                        
                        if (dateCompare >= 61 && dateCompare <= 75 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[5] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[5] = myNumber;
                            }
                            
                        }else if (dateCompare >= 75 && dateCompare <= 90 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                myNumber = [self convertToKg:myNumber];
                                weightArray[6] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                myNumber = [self converToCm:myNumber];
                                sizeArray[6] = myNumber;
                            }
                        }
                    }
                }

            }else{
                if (chartFormat == 0) {
                    if (dateCompare > 0 && dateCompare <= 5 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            weightArray[0] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            sizeArray[0] = myNumber;
                        }
                        
                    }else if (dateCompare >= 6 && dateCompare <= 9 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            weightArray[1] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            sizeArray[1] = myNumber;
                        }
                        
                    }else if (dateCompare >= 10 && dateCompare <= 14 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            weightArray[2] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            sizeArray[2] = myNumber;
                        }
                        
                    }else if (dateCompare >= 15 && dateCompare <= 18 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            weightArray[3] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            sizeArray[3] = myNumber;
                        }
                        
                    }else if (dateCompare >= 19 && dateCompare <= 23 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            [weightArray replaceObjectAtIndex:4 withObject:myNumber];
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            [sizeArray replaceObjectAtIndex:4 withObject:myNumber];
                        }
                        
                    }else if (dateCompare >= 24 && dateCompare <= 27 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            weightArray[5] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            sizeArray[5] = myNumber;
                        }
                        
                    }else if (dateCompare >= 28 && dateCompare <= 31 ) {
                        if ([matches valueForKey:@"weight"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                            weightArray[6] = myNumber;
                        }
                        if ([matches valueForKey:@"weistSize"] == nil) {
                            NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                        }else{
                            myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                            sizeArray[6] = myNumber;
                        }
                        
                    }
                    
                }
                if (chartFormat == 1) {
                    
                    int initialMonth;
                    
                    if (i == 0) {
                        initialMonth = monthCompare;
                    }
                    
                    if (monthCompare == initialMonth) {
                        
                        if (dateCompare > 0 && dateCompare < 9 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[0] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[0] = myNumber;
                            }
                            
                        }else if (dateCompare > 8 && dateCompare < 17 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[1] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[1] = myNumber;
                            }
                            
                        }else if (dateCompare > 16 && dateCompare < 25 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[2] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[2] = myNumber;
                            }
                            
                        }else if (dateCompare > 24 && dateCompare < 32 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[3] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[3] = myNumber;
                            }
                            
                        }
                        
                        
                    }else if (monthCompare == initialMonth + 1){
                        
                        dateCompare = dateCompare + 30;
                        
                        
                        if (dateCompare > 31 && dateCompare < 43 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                [weightArray replaceObjectAtIndex:4 withObject:myNumber];
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                [sizeArray replaceObjectAtIndex:4 withObject:myNumber];
                            }
                            
                        }else if (dateCompare >= 43 && dateCompare <= 51 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[5] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[5] = myNumber;
                            }
                            
                        }else if (dateCompare >= 52 && dateCompare <= 60 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[6] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[6] = myNumber;
                            }
                            
                        }
                        
                    }
                }
                
                if (chartFormat == 2) {
                    
                    int initialMonth;
                    
                    if (i == 0) {
                        initialMonth = monthCompare;
                    }
                    
                    if (monthCompare == initialMonth) {
                        
                        if (dateCompare > 0 && dateCompare <= 10 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[0] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[0] = myNumber;
                            }
                            
                        }else if (dateCompare >= 11 && dateCompare <= 20 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[1] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[1] = myNumber;
                            }
                            
                        }else if (dateCompare >= 21 && dateCompare <= 31 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[2] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[2] = myNumber;
                            }
                            
                        }
                        
                    }else if (monthCompare == initialMonth + 1){
                        
                        dateCompare = dateCompare + 30;
                        
                        
                        if (dateCompare >= 32 && dateCompare <= 46 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[3] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[3] = myNumber;
                            }
                            
                        }else if (dateCompare >= 47 && dateCompare <= 60 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                [weightArray replaceObjectAtIndex:4 withObject:myNumber];
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                [sizeArray replaceObjectAtIndex:4 withObject:myNumber];
                            }
                            
                        }
                    }else if (monthCompare == initialMonth + 2){
                        
                        dateCompare = dateCompare + 60;
                        
                        if (dateCompare >= 61 && dateCompare <= 75 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[5] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[5] = myNumber;
                            }
                            
                        }else if (dateCompare >= 75 && dateCompare <= 90 ) {
                            if ([matches valueForKey:@"weight"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weight"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weight"]];
                                weightArray[6] = myNumber;
                            }
                            if ([matches valueForKey:@"weistSize"] == nil) {
                                NSLog(@"Failed because: %@", [matches valueForKey:@"weistSize"]);
                            }else{
                                myNumber = [f numberFromString:[matches valueForKey:@"weistSize"]];
                                sizeArray[6] = myNumber;
                            }
                        }
                    }
                }
            }
            
        }
    }

}

- (NSNumber*) convertToKg:(NSNumber*) weight{
    
    int weightInInt = [weight intValue] / 2.2046 ;
    
    NSNumber* returnWeight = [NSNumber numberWithInt:weightInInt];
    
    return returnWeight;
}

- (NSNumber*) converToCm:(NSNumber*) size{
    
    int sizeInInt = [size intValue] / 0.39370;
    
    NSNumber* returnWeight = [NSNumber numberWithInt:sizeInInt];
    
    return returnWeight;
}

//TESTING *********************************************************


@end
