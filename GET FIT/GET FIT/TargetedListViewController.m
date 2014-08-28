//
//  TargetedListViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "TargetedListViewController.h"
#import "WorkoutFeed.h"
#import "TargetedCell.h"
#import "TargetedDetailsViewController.h"
#import "WorkoutViewController.h"

@interface TargetedListViewController ()

@end

@implementation TargetedListViewController
@synthesize targetedArray;

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
    
    [self navColor];
    
    workoutFeed = [[WorkoutFeed alloc] init];
    currentCell = [[WorkoutInfo alloc] init];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    
    
    
}

- (void) navColor{
    NSString* colorTag = [targetedArray[0] valueForKey:@"workoutTag"];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GoodTimesRg-Regular" size:35]}];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];

    if ([colorTag isEqualToString:@"upper"]) {
        self.navigationItem.title = @"Upper";
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:49/255.0f
                                                                                 green:53/255.0f
                                                                                  blue:64/255.0f
                                                                                 alpha:1.0f]];
        
        
    }else if([colorTag isEqualToString:@"mid"]){
        self.navigationItem.title = @"Mid";
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:250/255.0f
                                                                                 green:186/255.0f
                                                                                  blue:45/255.0f
                                                                                 alpha:1.0f]];
    }else if([colorTag isEqualToString:@"lower"]){
        self.navigationItem.title = @"Lower";
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:233/255.0f
                                                                                 green:64/255.0f
                                                                                  blue:90/255.0f
                                                                                 alpha:1.0f]];
    }else if([colorTag isEqualToString:@"sides"]){
        self.navigationItem.title = @"Sides";
        [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:73/255.0f
                                                                                 green:139/255.0f
                                                                                  blue:234/255.0f
                                                                                 alpha:1.0f]];
    }
}

#pragma TableView Functions

/*- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 70;
}*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [targetedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TargetedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TargetCell"];
    currentCell = [targetedArray objectAtIndex:indexPath.row];
    [cell refreshCellWithInfo:currentCell.title];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Segue

//------------------------------------- Segue methode -------------------------------------------------------------

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.identifier  isEqual: @"toDetail"]) {
        TargetedDetailsViewController* detailView = segue.destinationViewController;
        if (detailView != nil) {
            UITableViewCell *cell = (UITableViewCell*)sender;
            NSIndexPath *indexPath = [targetedTableView indexPathForCell:cell];
            
            // get the string from the array based on the cell in the tabel view we clicked
            
            WorkoutInfo *selectedString = [targetedArray objectAtIndex:indexPath.row];
            
            detailView.currentCell = selectedString;
        }
    }else if ([segue.identifier  isEqual: @"toTargetedWork"]) {
        
        WorkoutViewController* workVC = segue.destinationViewController;
        workVC.targetedArrayWorkout = targetedArray;
    }


}
//-----------------------------------------------------------------------------------------------------------------


@end
