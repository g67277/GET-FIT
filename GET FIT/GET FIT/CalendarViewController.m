//
//  CalendarViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/9/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "CalendarViewController.h"
#import "SACalendar.h"
#import "DateUtil.h"
#import "AppDelegate.h"

@interface CalendarViewController ()<SACalendarDelegate>

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    headerBackground.backgroundColor = [UIColor colorWithRed:73/255.0f green:139/255.0f blue:234/255.0f alpha:1.0f];
    self.view.backgroundColor = [UIColor whiteColor];
	
    /*
     * Smooth scrolling in vertical direction
     * - to change to horizontal, change the scrollDirection to ScrollDirectionHorizontal
     * - to use paging scrolling, change pagingEnabled to YES
     * - to change the looks, please see documentation on Github
     * - the calendar works with any size
     */
    SACalendar *calendar = [[SACalendar alloc]initWithFrame:CGRectMake(0, 20, 320, 500)
                                            scrollDirection:ScrollDirectionVertical
                                              pagingEnabled:NO];
    
    
    
    calendar.delegate = self;
    headerLabel.text = @"Calendar";
    headerLabel.font = [UIFont fontWithName:@"GoodTimesRg-Regular" size:25];
    
    [self.view addSubview:calendar];
    
    [self.view bringSubviewToFront:headerBackground];
    
    [self.navigationController setNavigationBarHidden:YES];
}

/**
 *  Delegate method : get called when a date is selected
 */
-(void) SACalendar:(SACalendar*)calendar didSelectDate:(int)day month:(int)month year:(int)year
{
    //NSMutableArray* toHoldMinutesForDay = [[NSMutableArray alloc] init];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObjectContext *measurementContext = [appDelegate managedObjectContext];
    // We want the contact entity, (this is where you can select the entity if there are more than one)
    NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"WorkoutMinutes" inManagedObjectContext:context];
    NSEntityDescription* entityDescMeasure = [NSEntityDescription entityForName:@"WeightNWeistSize" inManagedObjectContext:measurementContext];
    // initialzing a fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSFetchRequest *measureRequest = [[NSFetchRequest alloc] init];
    // passing in the entity
    [request setEntity:entityDesc];
    [measureRequest setEntity:entityDescMeasure];
    NSString* toBeSearched = [NSString stringWithFormat:@"%ld, %ld, %ld", (long)day, (long)month, (long)year];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(workoutDate = %@)", toBeSearched];
    NSPredicate *measurePred = [NSPredicate predicateWithFormat:@"(entryDate = %@)", toBeSearched];
    [request setPredicate:pred];
    [measureRequest setPredicate:measurePred];
    NSManagedObject* matches = nil;
    NSManagedObject* measureMatches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    NSArray *measureObjects = [measurementContext executeFetchRequest:measureRequest error:&error];
    NSNumber* incomingMinutes = [[NSNumber alloc] init];
    NSString* measurements;
    NSString* weightString;
    NSString* sizeString;
    double compinedMinutesForDate = 0;
    
    if ([objects count] == 0) {
        NSLog(@"No matches");
    }else{
        for (int i = 0; i < [objects count]; i++) {
            matches = objects[i];
            //[toHoldMinutesForDay addObject:[matches valueForKey:@"minutes"]];
            incomingMinutes = [matches valueForKey:@"minutes"];
            compinedMinutesForDate += [incomingMinutes doubleValue];
        }
    }
    if ([measureObjects count] == 0) {
        NSLog(@"No matches");
    }else{
        measureMatches = [measureObjects lastObject];
        weightString = [measureMatches valueForKey:@"weight"];
        sizeString = [measureMatches valueForKey:@"weistSize"];
        
        
        
        if ([weightString length] == 0) {
            measurements = [NSString stringWithFormat:@"Your waist size was: %@",[measureMatches valueForKey:@"weistSize"]];
        }else if ([sizeString length] == 0){
            measurements = [NSString stringWithFormat:@"Your weight was: %@", [measureMatches valueForKey:@"weight"]];
        }else{
            measurements = [NSString stringWithFormat:@"Your weight was: %@\nYour waist size was: %@", [measureMatches valueForKey:@"weight"], [measureMatches valueForKey:@"weistSize"]];
        }
    

    }

    
    NSString* minOfWorkout = [NSString stringWithFormat:@"%.2f Mins", compinedMinutesForDate];
    
    if (compinedMinutesForDate > 0) {
        if (!alert || !alert.isDisplayed) {
            // Custom colored alert of type AlertInfo, custom colors can be applied to any alert type
            alert = [[AMSmoothAlertView alloc]initDropAlertWithTitle:minOfWorkout andText:measurements andCancelButton:NO forAlertType:AlertInfo andColor:[UIColor colorWithRed:250/255.0f green:186/255.0f blue:45/255.0f alpha:1.0f]];
            [alert setTitleFont:[UIFont fontWithName:@"Verdana" size:25.0f]];
            
            alert.cornerRadius = 3.0f;
            [alert show];
        }else{
            [alert dismissAlertView];
        }
        
        [alert show];
    }
    

}

#pragma mark - Delegates
- (void)alertView:(AMSmoothAlertView *)alertView didDismissWithButton:(UIButton *)button {
	if (alertView == alert) {
		if (button == alert.defaultButton) {
			NSLog(@"Default button touched!");
		}
		if (button == alert.cancelButton) {
			NSLog(@"Cancel button touched!");
		}
	}
}

- (void)alertViewWillShow:(AMSmoothAlertView *)alertView {
    if (alertView.tag == 0)
        NSLog(@"AlertView Will Show: '%@'", alertView.titleLabel.text);
}

- (void)alertViewDidShow:(AMSmoothAlertView *)alertView {
	NSLog(@"AlertView Did Show: '%@'", alertView.titleLabel.text);
}

- (void)alertViewWillDismiss:(AMSmoothAlertView *)alertView {
	NSLog(@"AlertView Will Dismiss: '%@'", alertView.titleLabel.text);
}

- (void)alertViewDidDismiss:(AMSmoothAlertView *)alertView {
	NSLog(@"AlertView Did Dismiss: '%@'", alertView.titleLabel.text);
}


/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    //NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
}

@end
