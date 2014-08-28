//
//  TargetedDetailsViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "TargetedDetailsViewController.h"

@interface TargetedDetailsViewController ()

@end

@implementation TargetedDetailsViewController

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
    
    [self imageAnimation];
}

- (void) imageAnimation{
    // Load images
    
    NSArray* test = self.currentCell.imageArray;
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        [images addObject:[UIImage imageNamed:[test objectAtIndex:i]]];
    }
    
    // Normal Animation
    dImages.animationImages = images;
    dImages.animationDuration = 1;
    
    [self.view addSubview:dImages];
    [dImages startAnimating];
}

- (void) viewWillAppear:(BOOL)animated{
    
    dTitle.text = self.currentCell.title;
    dTitle.font = [UIFont fontWithName:@"GoodTimesRg-Regular" size:20];
    
    self.navigationItem.title = self.currentCell.title;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont fontWithName:@"GoodTimesRg-Regular" size:25]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
