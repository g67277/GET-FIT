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
    
    NSString* weightInput = weightField.text;
    NSString* sizeInput = sizeField.text;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"unitType"]) {
        
        if (weightField.text.length > 0) {
            weightInput = [NSString stringWithFormat:@"%@", [self convertToLbs:weightField.text]];
        }if (sizeField.text.length > 0) {
            sizeInput = [NSString stringWithFormat:@"%@", [self convertToInches:sizeField.text]];
        }
    }
    
    int weightCount = weightField.text.length;
    int sizeCount = sizeField.text.length;
    
    //NSUserDefaults* unitDefault = [NSUserDefaults standardUserDefaults];
    
    if (weightCount < 0 && sizeCount < 0) {
        
        // error nothing entered
        
    }else{
        if (weightCount > 0 && sizeCount > 0) {
            
            [newTrack setValue:weightInput forKey:@"weight"];
            [newTrack setValue:sizeInput forKey:@"weistSize"];
            [newTrack setValue:dateOfEntry forKey:@"entryDate"];
            NSLog(@"Both Saved: %@ || %@", weightInput, sizeInput);
        }else if (weightCount > 0){
            [newTrack setValue:weightInput forKey:@"weight"];
            [newTrack setValue:dateOfEntry forKey:@"entryDate"];
            NSLog(@"only weight Saved: %@", weightInput);
        }else if (sizeCount > 0){
            [newTrack setValue:sizeInput forKey:@"weistSize"];
            [newTrack setValue:dateOfEntry forKey:@"entryDate"];
            NSLog(@"only size Saved: %@", sizeInput);
        }
        
        NSError* error;
        [context save:&error];
        NSLog(@"Saved!");
    }
    
    
    
}

- (NSString*) convertToLbs:(NSString*) weight{
    
    int weightInInt = [weight intValue] * 2.2046 ;
    
    NSString* returnText = [NSString stringWithFormat:@"%d", weightInInt];
    
    return returnText;
}

- (NSString*) convertToInches:(NSString*) size{
    
    int sizeInInt = [size intValue] * 0.39370;
    
    NSString* returnText = [NSString stringWithFormat:@"%d", sizeInInt];
    
    return returnText;
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
