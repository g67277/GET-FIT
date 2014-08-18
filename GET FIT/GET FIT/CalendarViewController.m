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
    NSLog(@"Date Selected : %02i/%02i/%04i",day,month,year);
}

/**
 *  Delegate method : get called user has scroll to a new month
 */
-(void) SACalendar:(SACalendar *)calendar didDisplayCalendarForMonth:(int)month year:(int)year{
    //NSLog(@"Displaying : %@ %04i",[DateUtil getMonthString:month],year);
}

@end
