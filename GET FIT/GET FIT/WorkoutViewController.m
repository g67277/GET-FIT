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
    //record num of workout minutes
    numOfWorkoutSeconds = 0;
    // set number
    setNum = 1;
    
    pause.layer.cornerRadius = pause.frame.size.width / 2;
    pause.clipsToBounds = YES;
    
    [super viewDidLoad];
    
    workoutFeed = [[WorkoutFeed alloc] init];
    allWorkouts = [workoutFeed workoutArray];
    workoutImages = [[NSMutableArray alloc]init];
    for (int i = 0; i < [allWorkouts count]; i++) {
        [workoutImages addObject:[allWorkouts[i] valueForKey:@"imageArray"]];
    }
    [self setTimer];
    
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
        //[images addObject:[UIImage imageNamed:[[self arraySelector] objectAtIndex:i]]];
        [images addObject:[UIImage imageNamed:[workoutImages[setNum -1] objectAtIndex:i]]];
    }
    workTitle.text = [allWorkouts[setNum -1] valueForKey:@"title"];

    // Normal Animation
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 1;
    
    [self.view addSubview:animationImageView];
}


// Set time here
- (void) setTimer{
    // count is time counter is starting +1
    count = DEFAULT_WORKOUT_TIME;
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
    
    if (setNum > 10) {
        [timer invalidate];
        [animationImageView stopAnimating];
    }else{
        // subtracting 1 from count to countdown
        count = count - 1;
        // updating label text
        countDownLabel.text = [NSString stringWithFormat:@"%d", count];
        // if count reaches 1 reset and change the resting boolean
        if (count == 1 && resting == false) {
            count = DEFAULT_RESTING;
            resting = true;
            setNum++;
        }else if(count == 1 && resting == true){
            count = DEFAULT_WORKOUT_TIME;
            resting = false;
        }else if(resting == true){
            // if in resting, stop animating
            [animationImageView stopAnimating];
            workTitle.text = @"Rest Time...";

        }else if(resting == false){
            numOfWorkoutSeconds++;
            [self imageAnimation];
            [animationImageView startAnimating];
        }
    }
}

// Play Pause function
- (IBAction)onClick:(UIButton*)sender{
    if (sender.tag == 0 && pauseWork == false) {
        // stop timer
        //changing the button image for play/pause
        [UIView animateWithDuration:.5 animations:^{
            pause.alpha = 1.0;
        }];
        [pause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];

        [timer invalidate];
        pauseWork = true;
        [animationImageView stopAnimating];
    }else if(sender.tag == 0 && pauseWork == true){
        // create a new nstimer to resume
        //changing the button image for play/pause
        [UIView animateWithDuration:0.5 animations:^{
            pause.alpha = 0.1;
            [pause setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        }];
        [self setTimer];
        pauseWork = false;
        // do not animate if still in resting session
        if (resting == false) {
            [animationImageView startAnimating];
        }
    }
    
    //Back/Skip controls-----------------------------------------
    if (sender.tag == 1) {
        if (setNum == 1) {
            // error message, can't move back
        }else{
            setNum--;
            workTitle.text = [allWorkouts[setNum -1] valueForKey:@"title"];
            count = DEFAULT_WORKOUT_TIME;
            [timer invalidate];
            pauseWork = true;
            if (pauseWork == true) {
                [animationImageView stopAnimating];
                pause.alpha = 1.0;
                [pause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];

            }
        }
    }else if (sender.tag == 2){
        if (setNum == 10) {
            // error message, can't move forward
        }else{
            setNum++;
            workTitle.text = [allWorkouts[setNum -1] valueForKey:@"title"];
            count = DEFAULT_WORKOUT_TIME;
            [timer invalidate];
            pauseWork = true;
            if (pauseWork == true) {
                [animationImageView stopAnimating];
                pause.alpha = 1.0;
                [pause setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
            }
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
