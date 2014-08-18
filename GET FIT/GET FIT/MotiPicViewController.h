//
//  MotiPicViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface MotiPicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    IBOutlet UITableView* motiTable;
    IBOutlet UIButton* camButton;
    UIImagePickerController *picker;
    NSMutableArray* camPicArray;
    
}

- (IBAction)onClick:(id)sender;

@end