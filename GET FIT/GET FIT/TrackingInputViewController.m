//
//  TrackingInputViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "TrackingInputViewController.h"
#import "AppDelegate.h"

@interface TrackingInputViewController ()

@end

@implementation TrackingInputViewController
@synthesize weightField, sizeField;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)onClick:(id)sender{
    
    //------------------------------------Pulling Date (for core data tracking)-----------------------------------
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSLog(@"%ld, %ld, %ld", (long)day, (long)month, (long)year);
    NSString* dateOfEntry = [NSString stringWithFormat:@"%ld, %ld, %ld", (long)day, (long)month, (long)year];
    //------------------------------------------------------------------------------------------------------------
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject* newTrack = [NSEntityDescription insertNewObjectForEntityForName:@"WeightNWeistSize" inManagedObjectContext:context];
    
    int weightCount = weightField.text.length;
    int sizeCount = sizeField.text.length;
    
    if (weightCount > 0 && sizeCount > 0) {
        
        [newTrack setValue:weightField.text forKey:@"weight"];
        [newTrack setValue:sizeField.text forKey:@"weistSize"];
        [newTrack setValue:dateOfEntry forKey:@"entryDate"];
        NSLog(@"Both Saved: %@ || %@", weightField.text, sizeField.text);
    }else if (weightCount > 0){
        [newTrack setValue:weightField.text forKey:@"weight"];
        [newTrack setValue:dateOfEntry forKey:@"entryDate"];
        NSLog(@"only weight Saved: %@", weightField.text);
    }else if (sizeCount > 0){
        [newTrack setValue:sizeField.text forKey:@"weistSize"];
        [newTrack setValue:dateOfEntry forKey:@"entryDate"];
        NSLog(@"only size Saved: %@", sizeField.text);
    }
    
    NSError* error;
    [context save:&error];
    NSLog(@"Saved!");
    
}

//---------- Hiding Keyboard when touching anything but the field----------------------

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [weightField resignFirstResponder];
    [sizeField resignFirstResponder];
    
}
//-------------------------------------------------------------------------------------



- (BOOL) returnKey:(UITextField*)textField{
    if (textField) {
        [textField resignFirstResponder];
    }
    return NO;
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
