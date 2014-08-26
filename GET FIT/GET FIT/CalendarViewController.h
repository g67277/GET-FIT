//
//  CalendarViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/9/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "AMSmoothAlertView.h"
#import "AMSmoothAlertConstants.h"

@interface CalendarViewController : UIViewController<AMSmoothAlertViewDelegate>{
    
    IBOutlet UIButton* panelButton;
    AMSmoothAlertView * alert;
    bool isPopupShown;
    
}

@end
