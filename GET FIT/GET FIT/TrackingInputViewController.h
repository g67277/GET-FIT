//
//  TrackingInputViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackingInputViewController : UIViewController
@property (nonatomic, strong) IBOutlet UITextField *eventField;
@property (nonatomic, strong) NSString *eventString;
@property (nonatomic) long count;

@end
