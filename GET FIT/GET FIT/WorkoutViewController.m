//
//  WorkoutViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "WorkoutViewController.h"

@interface WorkoutViewController ()

@end

@implementation WorkoutViewController

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
    
    [self setTimer];
    [super viewDidLoad];
    
    workoutFeed = [[WorkoutFeed alloc] init];
    allWorkouts = [workoutFeed workoutArray];
    
    //------------------------------------Pulling Date (for core data tracking)-----------------------------------
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSLog(@"%d, %d", hour, minute);
    //------------------------------------------------------------------------------------------------------------
}

- (void) imageAnimation{
    // Load images
    
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        [images addObject:[UIImage imageNamed:[[self arraySelector] objectAtIndex:i]]];
    }
    
    // Normal Animation
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 1;
    
    [self.view addSubview:animationImageView];
}

- (NSArray*) arraySelector{
    
    NSArray *workout2 = @[@"two 1.jpg", @"two 2.jpg"];
    NSArray *workout1 = @[@"bodyweight leg raise 1.jpg", @"bodyweight leg raise 2.jpg"];
    
    switch (setNum) {
        case 1:
            return workout1;
            break;
        case 2:
            return workout2;
            break;
            
        default:
            break;
    }
    
    return 0;
}

// Set time here
- (void) setTimer{
    //record num of workout minutes
    numOfWorkoutSeconds = 0;
    // set number
    setNum = 1;
    // count is time counter is starting +1
    count = 6;
    // resting boolean
    resting = false;
    // pause play boolean
    pauseWork = false;
    // Starting animating workout
    [self imageAnimation];
    [animationImageView startAnimating];
    //setting the workout to be animated
    //workoutNum = 1;
    
    // creat nstimer
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                           selector:@selector(updateTime)
                                           userInfo:nil
                                            repeats:YES];
    
}

// Minipulate time here
-(void) updateTime{
    
    // subtracting 1 from count to countdown
    count = count - 1;
    // updating label text
    countDownLabel.text = [NSString stringWithFormat:@"%d", count];
    
    // if count reaches 1 reset and change the resting boolean
    if (count == 1 && resting == false) {
        count = 4;
        resting = true;
        setNum++;
    }else if(count == 1 && resting == true){
        count = 6;
        resting = false;
    }else if(resting == true){
        // if in resting, stop animating
        [animationImageView stopAnimating];
    }else if(resting == false){
        numOfWorkoutSeconds++;
        NSLog(@"%d", numOfWorkoutSeconds);
        [self imageAnimation];
        [animationImageView startAnimating];
        
    }
    
}

// Play Pause function
- (IBAction)onClick:(UIButton*)sender{
    if (pauseWork == false) {
        // stop timer
        [timer invalidate];
        pauseWork = true;
        [animationImageView stopAnimating];
    }else{
        // create a new timer to resume
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self
                                               selector:@selector(updateTime)
                                               userInfo:nil
                                                repeats:YES];
        pauseWork = false;
        // do not animate if still in resting session
        if (resting == false) {
            [animationImageView startAnimating];
        }
    }
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [timer invalidate];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
