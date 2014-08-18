//
//  TrackingInputViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "TrackingInputViewController.h"

@interface TrackingInputViewController ()

@end

@implementation TrackingInputViewController
@synthesize eventField, eventString;

//--------------------- Sending info back to main page ------------------------

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    
    if ([identifier isEqualToString:@"toTracking"]) {
        eventString = eventField.text;
        
    }
    return YES;
    
}
//--------------------------

//---------- Hiding Keyboard when touching anything but the field----------------------

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [eventField resignFirstResponder];
}
//-------------------------------------------------------------------------------------

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
