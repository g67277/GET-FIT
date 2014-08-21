//
//  TrackingViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <Accounts/Accounts.h>
#import <Social/Social.h>
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
@synthesize mainEvents;

- (void)viewDidLoad {

    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:73/255.0f green:139/255.0f blue:234/255.0f alpha:1]];
    self.view.backgroundColor = [UIColor gk_cloudsColor];
    
    // THis is to change the chart input
    [self _setupExampleGraph];

        //    [self _setupTestingGraphHigh];
    
    // for sharing
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
            [self _setupExampleGraph];
        }else {
            [self.graph reset];
            [self _setupTestingGraphLow];
        }

    }else if (sender.tag == 1){
        
        
    }else if (sender.tag == 2){
        

        
        //SLComposeViewController *slComposerViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        //[self presentViewController:slComposerViewController animated:true completion:nil];
        
        

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
    
    //  Set the initial body of the Tweet
    [tweetSheet setInitialText:@"just setting up my twttr"];
    
    //  Adds an image to the Tweet.  For demo purposes, assume we have an
    //  image named 'larry.png' that we wish to attach
    if (![tweetSheet addImage:capturedScreen]) {
        NSLog(@"Unable to add the image!");
    }
    
    /* Add an URL to the Tweet.  You can add multiple URLs.
    if (![tweetSheet addURL:[NSURL URLWithString:@"http://twitter.com/"]]){
        NSLog(@"Unable to add the URL!");
    }*/
    
    //  Presents the Tweet Sheet to the user
    [self presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

//TESTING *********************************************************


@end
