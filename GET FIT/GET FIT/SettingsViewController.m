//
//  SettingsViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "SettingsViewController.h"
#import "NZAlertView.h"


@interface SettingsViewController ()
@property (strong, nonatomic) OCBorghettiView *accordion;
@property (nonatomic) NZAlertStyle alertStyle;

@end

@implementation SettingsViewController
@synthesize reminderRecurrnce;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:73/255.0f
                                                green:139/255.0f
                                                 blue:234/255.0f
                                                alpha:1.0f];
    alert = [[NZAlertView alloc] init];
    
    reminderOptions = @[@"0", @"1", @"2", @"3"];
    restOptions = @[@"5s", @"10s", @"15s", @"20s", @"30s"];
    unitOptions = @[@"Imperial", @"Metric"];
    
    
    [self.navigationController setNavigationBarHidden:YES];
    [self.view bringSubviewToFront:menuButton];
    
    // Reminders---------------
    self.eventStore = [[EKEventStore alloc] init];
    self.eventStoreAccessGranted = NO;
    //-------------------------
    
    [self setupAccordion];
    
}

- (void)setupAccordion
{
    self.accordion = [[OCBorghettiView alloc] initWithFrame:CGRectMake(0, 70, self.view.frame.size.width, self.view.frame.size.height - 70)];
    UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(90, 25, 170, 40)];
    title.text = @"Settings";
    title.font = [UIFont fontWithName:@"GoodTimesRg-Regular" size:25];
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];
    [self.view bringSubviewToFront:title];
    
    self.accordion.headerHeight = 60;
    
    self.accordion.headerFont = [UIFont fontWithName:@"GoodTimesRg-Regular" size:17];
    self.accordion.headerTitleColor = [UIColor whiteColor];
    
    self.accordion.headerBorderColor = [UIColor colorWithRed:250/255.0f
                                                       green:250/255.0f
                                                        blue:250/255.0f
                                                       alpha:1.0f];
    self.accordion.headerColor = [UIColor colorWithRed:73/255.0f
                                                 green:139/255.0f
                                                  blue:234/255.0f
                                                 alpha:1.0f];
    [self.view addSubview:self.accordion];
    
    // Section One
    UITableView *sectionOne = [[UITableView alloc] init];
    [sectionOne setTag:1];
    [sectionOne setDelegate:self];
    [sectionOne setDataSource:self];
    [self.accordion addSectionWithTitle:@"Reminder Recurrence:"
                                andView:sectionOne];
    
    // Section Two
    UITableView *sectionTwo = [[UITableView alloc] init];
    [sectionTwo setTag:2];
    [sectionTwo setDelegate:self];
    [sectionTwo setDataSource:self];
    [self.accordion addSectionWithTitle:@"Rest Interval:"
                                andView:sectionTwo];
    
    // Section Three
    UITableView *sectionThree = [[UITableView alloc] init];
    [sectionThree setTag:3];
    [sectionThree setDelegate:self];
    [sectionThree setDataSource:self];
    [self.accordion addSectionWithTitle:@"Units:"
                                andView:sectionThree];
}


#pragma mark - <UITableViewDelegate, UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1) {
        return [reminderOptions count];
    }else if (tableView.tag == 2){
        return [restOptions count];
    }else{
        return [unitOptions count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"borghetti_cell"];
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"borghetti_cell"];
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir" size:18];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor colorWithRed:73/255.0f
                                               green:139/255.0f
                                                blue:234/255.0f
                                               alpha:1.0f];
    
    if (tableView.tag == 1) {
        cell.textLabel.text = [reminderOptions objectAtIndex:indexPath.row];
        
    }else if (tableView.tag == 2){
        cell.textLabel.text = [restOptions objectAtIndex:indexPath.row];
    }else{
        cell.textLabel.text = [unitOptions objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"%ld",(long)indexPath.row);
    NSLog(@"%ld",(long)tableView.tag);
    
    if (tableView.tag == 1) {
        [self createReminders:indexPath.row];
    }else if (tableView.tag == 2){
        [self restSelection:indexPath.row];
        
    }else if (tableView.tag == 3){
        [self unitSelection:indexPath.row];
    }
}

// Creating reminder based on user selection
- (void) createReminders: (long) indexPath{
    //Need to create a successfull alert
    localNotification = [[UILocalNotification alloc] init];

        if (indexPath == 0) {
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleInfo
                                                              title:@"Reminder Saved!"
                                                            message:@"No Reminders"
                                                           delegate:self];
        }else if (indexPath == 1){
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [self setNotification:[self notificationDateFormatting:@"T22:00:00Z"]];
            localNotification.repeatInterval = NSDayCalendarUnit;
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Reminder Saved!"
                                               message:@"Will remind you at 6:00pm"
                                              delegate:self];
        }else if (indexPath == 2){
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [self setNotification:[self notificationDateFormatting:@"T11:00:00Z"]];
            [self setNotification:[self notificationDateFormatting:@"T22:00:00Z"]];
            localNotification.repeatInterval = NSDayCalendarUnit;
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Reminder Saved!"
                                               message:@"Will remind you at 7:00am and 6:00pm"
                                              delegate:self];
        }else if (indexPath == 3){
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [self setNotification:[self notificationDateFormatting:@"T11:00:00Z"]];
            [self setNotification:[self notificationDateFormatting:@"T17:00:00Z"]];
            [self setNotification:[self notificationDateFormatting:@"T22:00:00Z"]];
            localNotification.repeatInterval = NSDayCalendarUnit;
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Reminder Saved!"
                                               message:@"Will remind you at 7:00am, 1:00pm and 6:00pm"
                                              delegate:self];
        }
    
    [alert show];
}

// Sets the date format for the local notification--------------
- (NSDate*) notificationDateFormatting: (NSString*) time{
    NSMutableString* currentDateString = [NSMutableString stringWithFormat:@"%@", [NSDate date]];
    [currentDateString replaceCharactersInRange:NSMakeRange(10, 13) withString:time];
    NSString* editedDateString = [currentDateString substringToIndex:[currentDateString length] - 2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSDate *alarmDate = [dateFormatter dateFromString:editedDateString];
    
    return alarmDate;
}
//------------------------------------------------------------

// Creates Notification---------------------------------------
- (void)setNotification:(NSDate*) incomingDate {
    NSLog(@"alarm set with %@", incomingDate);
    localNotification.fireDate = incomingDate;
    localNotification.alertBody = @"Its that time again... Lets Workout!";
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}
//------------------------------------------------------------

// Sets the resting interval based on user selection
- (void) restSelection: (long) indexPath{
    
    NSUserDefaults* userDefaults = [[NSUserDefaults alloc] init];
    NSNumber* restingObject = [[NSNumber alloc ]init];
    
    switch (indexPath) {
        case 0:
            restingObject = [NSNumber numberWithInt:5];
            [userDefaults setObject:restingObject forKey:@"restingTime"];
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Resting Interval Saved!"
                                               message:@"Resting set to 5 seconds"
                                              delegate:self];
            break;
        case 1:
            restingObject = [NSNumber numberWithInt:10];
            [userDefaults setObject:restingObject forKey:@"restingTime"];
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Resting Interval Saved!"
                                               message:@"Resting set to 10 seconds"
                                              delegate:self];
            break;
        case 2:
            restingObject = [NSNumber numberWithInt:15];
            [userDefaults setObject:restingObject forKey:@"restingTime"];
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Resting Interval Saved!"
                                               message:@"Resting set to 15 seconds"
                                              delegate:self];
            break;
        case 3:
            restingObject = [NSNumber numberWithInt:20];
            [userDefaults setObject:restingObject forKey:@"restingTime"];
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Resting Interval Saved!"
                                               message:@"Resting set to 20 seconds"
                                              delegate:self];
            break;
        case 4:
            restingObject = [NSNumber numberWithInt:30];
            [userDefaults setObject:restingObject forKey:@"restingTime"];
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Resting Interval Saved!"
                                               message:@"Resting set to 30 seconds"
                                              delegate:self];
            break;
        default:
            break;
    }
    
    [userDefaults synchronize];
    [alert show];

}

// Changnes the units for tracking based on user selection
- (void) unitSelection: (long) indexPath{
    NSUserDefaults* unitDefault = [[NSUserDefaults alloc] init];
    
    switch (indexPath) {
        case 0:
            [unitDefault setBool:NO forKey:@"unitType"];
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Unit Change Saved!"
                                               message:@"Units changed to Imperial"
                                              delegate:self];
            break;
        case 1:
            [unitDefault setBool:YES forKey:@"unitType"];
            alert = [[NZAlertView alloc] initWithStyle:NZAlertStyleSuccess
                                                 title:@"Unit Change Saved!"
                                               message:@"Units changed to Metric"
                                              delegate:self];

            break;
        default:
            break;
    }
    
    [unitDefault synchronize];
    [alert show];


}

- (void) viewWillDisappear:(BOOL)animated{
    
    [self NZAlertViewDidDismiss:alert];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - NZAlertViewDelegate

- (void)willPresentNZAlertView:(NZAlertView *)alertView
{
    NSLog(@"%s\n\t alert will present", __PRETTY_FUNCTION__);
}

- (void)didPresentNZAlertView:(NZAlertView *)alertView
{
    NSLog(@"%s\n\t alert did present", __PRETTY_FUNCTION__);
}

- (void)NZAlertViewWillDismiss:(NZAlertView *)alertView
{
    NSLog(@"%s\n\t alert will dismiss", __PRETTY_FUNCTION__);
}

- (void)NZAlertViewDidDismiss:(NZAlertView *)alertView
{
    NSLog(@"%s\n\t alert did dismiss", __PRETTY_FUNCTION__);
}


@end
