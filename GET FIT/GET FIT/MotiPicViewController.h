//
//  MotiPicViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "AMSmoothAlertView.h"
#import "AMSmoothAlertConstants.h"

@interface MotiPicViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AMSmoothAlertViewDelegate>{
    
    IBOutlet UITableView* motiTable;
    IBOutlet UIButton* camButton;
    IBOutlet UILabel* headerTitle;
    
    IBOutlet UIView* mergEffectView;
    IBOutlet UIImageView* mergeAnimation;
    
    UIImagePickerController *imgPicker;
    NSMutableArray* camPicArray;
    NSMutableArray* camDateArray;
    
    
    NSManagedObject* matches;
    NSMutableArray* weightArray;
    NSMutableArray* sizeArray;
    NSMutableArray* detailsArray;
    
    NSString* incomingDate;
    
    AMSmoothAlertView * alert;
    bool isPopupShown;
    
    
}

@property (copy, nonatomic) NSArray* testPics;

- (IBAction)onClick:(UIButton *)sender;

@end
