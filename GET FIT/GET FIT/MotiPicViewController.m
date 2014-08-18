//
//  MotiPicViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "MotiPicViewController.h"

@interface MotiPicViewController ()

@end

@implementation MotiPicViewController

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self.view bringSubviewToFront:camButton];
    camPicArray = [[NSMutableArray alloc]init];
    [self.navigationController setNavigationBarHidden:YES];

    
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)onClick:(id)sender{
    picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@", info);
    UIImage* original = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    NSLog(@"%@", original);
    
    [camPicArray addObject:original];
    [picker dismissViewControllerAnimated:true completion:nil];
    [motiTable reloadData];
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
    
    NSString* simpIdent = @"simpIdent";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:simpIdent];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpIdent];
    }

    
    cell.imageView.image = camPicArray[indexPath.row];
    
    return cell;
}


@end
