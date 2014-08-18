//
//  WorkoutViewController.m
//  GET FIT
//
//  Created by Nazir Shuqair on 8/10/14.
//  Copyright (c) 2014 Me Time Studios. All rights reserved.
//

#import "WorkoutViewController.h"
#import "SettingsViewController.h"
#import "settings.h"


@interface WorkoutViewController ()

@end

@implementation WorkoutViewController
@synthesize targetedArrayWorkout;

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
    workoutFeed = [[WorkoutFeed alloc] init];
    
    workoutImages = [[NSMutableArray alloc]init];
    
    
    settingsVC = [[SettingsViewController alloc] init];
    settingObject = [[settings alloc] init];
    selectedRestCount = settingObject.restCount;
    NSLog(@"%d", settingObject.restCount);
    //resting count from settings
    if (selectedRestCount == 0) {
        selectedRestCount = 10;
    }
    
    if (targetedArrayWorkout == nil) {
        incomingWorkoutList = [workoutFeed workoutArray];
    }else if (incomingWorkoutList == nil){
        incomingWorkoutList = targetedArrayWorkout;
    }
    [self createImageArray:incomingWorkoutList];
    
    // set number
    setNum = 1;
    indicatorCount = 1;
    // count is time counter is starting +1
    count = DEFAULT_WORKOUT_TIME;
    
    // Sounds
    NSString* audioPath = [[NSBundle mainBundle] pathForResource:@"beep-24" ofType:@"mp3"];
    beepSound = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:audioPath] error:NULL];
    
    pause.layer.cornerRadius = pause.frame.size.width / 2;
    pause.clipsToBounds = YES;
    
    [self setTimer];
    
    //------------------------------------Pulling Date (for core data tracking)-----------------------------------
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:date];
    NSInteger hour = [components hour];
    NSInteger minute = [components minute];
    NSLog(@"%ld, %ld", (long)hour, (long)minute);
    //------------------------------------------------------------------------------------------------------------
}

- (void) createImageArray: (NSArray*) workout{
    for (int i = 0; i < [workout count]; i++) {
        [workoutImages addObject:[workout[i] valueForKey:@"imageArray"]];
    }
}

- (void) indicatorOnOff{
    NSArray* indicatorArray = @[indicator1, indicator2, indicator3, indicator4, indicator5, indicator6, indicator7, indicator8, indicator9, indicator10];
    
    for (int i = 0; i < [indicatorArray count]; i++) {
        if (indicatorCount < setNum) {
            int onOff = indicatorCount - 1;
            if (count < 4) {
                UIImageView* indImage = indicatorArray[onOff];
                indImage.image = [UIImage imageNamed:@"complete"];
            }
            
            indicatorCount++;
        }else if (indicatorCount > setNum){
            int onOff = indicatorCount - 2;
            UIImageView* indImage = indicatorArray[onOff];
            indImage.image = [UIImage imageNamed:@"notcomplete"];
            indicatorCount--;
        }
    }
    
}


- (void) imageAnimation{
    // Load images
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < 2; i++) {
        //[images addObject:[UIImage imageNamed:[[self arraySelector] objectAtIndex:i]]];
        [images addObject:[UIImage imageNamed:[workoutImages[setNum -1] objectAtIndex:i]]];
        animationImageView.image = [UIImage imageNamed:[workoutImages[setNum -1] objectAtIndex:i]];
    }
    
    // updating workout title based on the incoming array
        workTitle.text = [incomingWorkoutList[setNum -1] valueForKey:@"title"];
    //updating set label
    setLabel.text = [NSString stringWithFormat:@"SET: %d", setNum];

    // Normal Animation
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 1.25;
    [self.view addSubview:animationImageView];
}


// Set time here
- (void) setTimer{
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
    
    dynamicWorkCount = 10;
    if (targetedArrayWorkout != nil) {
        if ([targetedArrayWorkout count] < 10) {
            dynamicWorkCount = [targetedArrayWorkout count];
        }
    }
    
    
    if (setNum > dynamicWorkCount) {
        NSLog(@"%d", setNum);
        NSLog(@"%d", dynamicWorkCount);
        [timer invalidate];
        [animationImageView stopAnimating];
    }else{
        // subtracting 1 from count to countdown
        count = count - 1;
        // updating label text
        countDownLabel.text = [NSString stringWithFormat:@"%d", count + 1];
        
        //sound
        if (count < 3) {
            [beepSound play];
        }
        
        // if count reaches 1 reset and change the resting boolean
        if (count == 0 && resting == false) {
            count = selectedRestCount;
            NSLog(@"%d", selectedRestCount);
            // if in resting, stop animating
            [animationImageView stopAnimating];
            if (setNum != dynamicWorkCount) {
                animationImageView.image = [UIImage imageNamed: @"stopwatch.png"];
                workTitle.text = @"Rest Time...";
            }
            resting = true;
            setNum++;
            // indicator images function
            [self indicatorOnOff];
        }else if(count == 0 && resting == true){
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
        if (setNum <= 10) {
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
        
    }
    
    //Back/Skip controls-----------------------------------------
    if (sender.tag == 1) {
        if (setNum == 1) {
            // error message, can't move back
        }else{
            setNum--;
            // indicator images function
            [self indicatorOnOff];
            workTitle.text = [incomingWorkoutList[setNum -1] valueForKey:@"title"];
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
        NSLog(@"%d", dynamicWorkCount);
        if (setNum >= dynamicWorkCount) {
            // error message, can't move forward
        }else{
            setNum++;
            // indicator images function
            [self indicatorOnOff];
            workTitle.text = [incomingWorkoutList[setNum -1] valueForKey:@"title"];
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
