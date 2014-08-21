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
    
    [self.view addSubview:calendar];
    
    [self.view bringSubviewToFront:panelButton];
    
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
    // We want the contact entity, (this is where you can select the entity if there are more than one)
    NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"WorkoutMinutes" inManagedObjectContext:context];
    // initialzing a fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // passing in the entity
    [request setEntity:entityDesc];
    NSString* toBeSearched = [NSString stringWithFormat:@"%ld, %ld, %ld", (long)day, (long)month, (long)year];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"(workoutDate = %@)", toBeSearched];
    [request setPredicate:pred];
    NSManagedObject* matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    NSNumber* incomingMinutes = [[NSNumber alloc] init];
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

    
    NSLog(@"%f", compinedMinutesForDate);
    
    NSString* minOfWorkout = [NSString stringWithFormat:@"%f", compinedMinutesForDate];
    // this works for displaying data
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Workout Mintues" message:minOfWorkout delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
    [alert show];

    NSLog(@"Date Selected : %02i/%02i/%04i",day,month,year);
}

/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    //NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
}

@end
