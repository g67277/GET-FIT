//
//  SettingsViewController.h
//  GET FIT
//
//  Created by Nazir Shuqair on 8/16/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "RESideMenu.h"
#import "OCBorghettiView.h"


@interface SettingsViewController : UIViewController<OCBorghettiViewDelegate, UITableViewDelegate, UITableViewDataSource>{
    
    NSArray* reminderOptions;
    NSArray* restOptions;
    NSArray* unitOptions;
        
    IBOutlet UIButton* menuButton;
    
    UILocalNotification *localNotification;
        
}

@property (strong, nonatomic) EKEventStore *eventStore;
@property (readonly, nonatomic) int reminderRecurrnce;
@property BOOL eventStoreAccessGranted;

@end
