//
//  MotiPicViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "MotiPicViewController.h"
#import "AppDelegate.h"
#import "PicEntity.h"

@interface MotiPicViewController ()

@end

@implementation MotiPicViewController

- (void) viewWillAppear:(BOOL)animated{
    
    [camPicArray removeAllObjects];
    [self retriveCoreData];
    [motiTable reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //testPics = @[@"test1", @"two", @"three", @"four", @"five", @"six", @"seven", @"eight"];
    
    [self.view bringSubviewToFront:camButton];
    camPicArray = [[NSMutableArray alloc]init];
    camDateArray = [[NSMutableArray alloc] init];
    
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController setNavigationBarHidden:YES];

}

- (IBAction)onClick:(UIButton*)sender{

    if (sender.tag == 0) {
        picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }else if (sender.tag == 1){
        if (camPicArray.count < 5) {
            if (!alert || !alert.isDisplayed) {
                alert = [[AMSmoothAlertView alloc]initFadeAlertWithTitle:@"Sorry!" andText:@"This feature is only avialable after 5 pictures have been added" andCancelButton:NO forAlertType:AlertFailure];
                [alert.defaultButton setTitle:@"Ok" forState:UIControlStateNormal];
                
                [alert show];
            }else{
                [alert dismissAlertView];
            }
            
        }else{
            //start merge
            mergEffectView.hidden = false;
            camButton.hidden = true;
            //mergEffectView.alpha = .95;
            [self animateImages];
        }
        
    }else if (sender.tag == 2){
        // repeat
        [self animateImages]; // once finished, repeat again
    }else if (sender.tag == 3){
        //exit
        [mergeAnimation stopAnimating];
        mergEffectView.hidden = true;
        camButton.hidden = false;
    }
}

- (void)animateImages{
    static int count = 0;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [camPicArray count]; i++) {
        //[images addObject:[UIImage imageNamed:[[self arraySelector] objectAtIndex:i]]];
        UIImage* imageToAnimate = [camPicArray objectAtIndex:i];
        UIImage *editedToAnimate = [self imageWithImage:imageToAnimate scaledToSize:CGSizeMake(288, 414)];
        [images addObject:editedToAnimate];
        //mergeAnimation.image = editedToAnimate;
    }
    UIImage *image = [images objectAtIndex:(count % [images count])];
    
    [UIView transitionWithView:mergeAnimation
                      duration:.3f // animation duration
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        mergeAnimation.image = image; // change to other image
                    } completion:^(BOOL finished) {
                        if (count < [images count]) {
                            [self animateImages]; // once finished, repeat again
                            count++; // this is to keep the reference of which image should be loaded next
                        }else{
                            count = 0;
                        }
                    }];
}


- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    UIImage* original = info[UIImagePickerControllerOriginalImage];
    
    NSLog(@"%@", original);
    
    
    NSData *imgData   = UIImageJPEGRepresentation(original, 0.5);
	NSString *name    = [[NSUUID UUID] UUIDString];
	NSString *path	  = [NSString stringWithFormat:@"Documents/%@.jpg", name];
	NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:path];
	if ([imgData writeToFile:jpgPath atomically:YES]) {
        [self saveData:path];
	} else {
		[[[UIAlertView alloc] initWithTitle:@"Error"
									message:@"There was an error saving your photo. Try again."
								   delegate:nil
						  cancelButtonTitle:@"OK"
						  otherButtonTitles: nil] show];
    }
    
    [picker dismissViewControllerAnimated:true completion:nil];
    [motiTable reloadData];
    
}

- (void) retriveCoreData{
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    // We want the contact entity, (this is where you can select the entity if there are more than one)
    NSEntityDescription* entityDesc = [NSEntityDescription entityForName:@"PicEntity" inManagedObjectContext:context];
    // initialzing a fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    // passing in the entity
    [request setEntity:entityDesc];
    [request setPropertiesToFetch:@[@"image"]];
    matches = nil;
    
    NSError *error;
    NSArray *objects = [context executeFetchRequest:request
                                              error:&error];
    //NSMutableArray* testing2 = [[NSMutableArray alloc] init];
    
    if ([objects count] == 0) {
        NSLog(@"No matches");
        // put an alert here
    }else{
        for (int i = 0; i < [objects count]; i++) {
            matches = objects[i];
            //[testing2 addObject:matches];
            PicEntity* nameImg = matches;
            NSString* incomingImg = nameImg.image;
            NSString* incomingDate = nameImg.date;
            NSData *imgData = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:incomingImg]];
            UIImage* imgToAdd = [UIImage imageWithData:imgData];
            [camPicArray addObject:imgToAdd];
            [camDateArray addObject:incomingDate];
        }
    }
    
    
}

- (void) saveData: (NSString*)path{
    //------------------------------------Pulling Date (for core data tracking)-----------------------------------
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSLog(@"%ld, %ld, %ld", (long)day, (long)month, (long)year);
    NSString* dateOfPic = [NSString stringWithFormat:@"%ld, %ld, %ld", (long)day, (long)month, (long)year];
    //------------------------------------------------------------------------------------------------------------
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject* camPic = [NSEntityDescription insertNewObjectForEntityForName:@"PicEntity" inManagedObjectContext:context];
    
    [camPic setValue:path forKey:@"image"];
    [camPic setValue:dateOfPic forKeyPath:@"date"];
    
    NSError* error;
    [context save:&error];
    
}



- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    [picker.view setFrame:picker.view.superview.frame];
}

- (void) image: (UIImage*) image didFinishSavingWithError: (NSError*) error contextInfo: (void *) contextInfo{
    
    if (error == nil) {
        
    }
    
}


- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [camPicArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    cell.imageView.image = camPicArray[indexPath.row];
    //cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Testing\nTesting2\n%@", camDateArray[indexPath.row]];
    
    return cell;
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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
