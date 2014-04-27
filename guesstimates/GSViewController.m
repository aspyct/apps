//
//  GSViewController.m
//  guesstimates
//
//  Created by Antoine d'Otreppe on 26/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

@import AudioToolbox;
@import iAd;

#import "GSViewController.h"
#import "GSThinkingProgress.h"
#import "GSSillyActionGenerator.h"

@interface GSViewController ()

// Main views
@property (weak, nonatomic) IBOutlet UIView *shakeMeView;
@property (weak, nonatomic) IBOutlet UIView *thinkingView;
@property (weak, nonatomic) IBOutlet UIView *resultsView;

// Thinking view
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *thinkingProgress;
@property (weak, nonatomic) IBOutlet UILabel *percentageLabel;

// Results view
@property (weak, nonatomic) IBOutlet UILabel *estimateLabel;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;
@property (weak, nonatomic) IBOutlet UIButton *anotherEstimateButton;
@property (weak, nonatomic) IBOutlet UIButton *shareThisAppButton;
@property (weak, nonatomic) IBOutlet UILabel *needMoreTimeLabel;


// Internal state
@property (nonatomic) BOOL detectShake;
@property (readonly) GSSillyActionGenerator *actionGenerator;
@property (strong, nonatomic) NSTimer *actionTimer;
@property (nonatomic) NSUInteger guesstimatedDays;

@end

@implementation GSViewController

@synthesize actionGenerator = _actionGenerator;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view bringSubviewToFront:self.shakeMeView];
    self.detectShake = YES;
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (self.detectShake) {
        if (motion == UIEventSubtypeMotionShake) {
            [self startThinking];
        }
    }
}

- (void)startThinking
{
    self.detectShake = NO;
    self.adBanner.hidden = YES;
    [self.thinkingProgress setProgress:0 animated:NO];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.shakeMeView.backgroundColor = [UIColor blackColor];
        self.resultsView.backgroundColor = [UIColor blackColor];
        self.shareThisAppButton.alpha = 0;
        self.anotherEstimateButton.alpha = 0;
    } completion:^(BOOL finished) {
        GSThinkingProgress *progress = [[GSThinkingProgress alloc] init];
        
        self.actionTimer = [NSTimer scheduledTimerWithTimeInterval:3
                                                            target:self
                                                          selector:@selector(updateAction:)
                                                          userInfo:nil
                                                           repeats:YES];
        
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                          target:self
                                                        selector:@selector(doSillyProgress:)
                                                        userInfo:progress
                                                         repeats:YES];
        
        
        [self doSillyProgress:timer];
        [self updateAction:nil];
        
        [self.view bringSubviewToFront:self.thinkingView];
    }];
}

- (void)doSillyProgress:(NSTimer *)timer
{
    GSThinkingProgress *progress = timer.userInfo;
    
    [progress think];
    
    if (progress.finished) {
        [timer invalidate];
        [self.actionTimer invalidate];
        
        [self calculateAndShowGuesstimate];
    } else {
        [self updateThinkingView:progress];
    }
}

- (void)updateAction:(NSTimer *)timer
{
    self.actionLabel.text = [self.actionGenerator actSilly];
}

- (void)updateThinkingView:(GSThinkingProgress *)progress
{
    [self.thinkingProgress setProgress:progress.progress / 100 animated:YES];
    self.percentageLabel.text = [NSString stringWithFormat:@"%.0f%%", progress.progress];
}

- (void)calculateAndShowGuesstimate
{
    self.guesstimatedDays += arc4random_uniform(7) + 1;
    
    // always using "dayS"
    self.guesstimatedDays = MAX(self.guesstimatedDays, 2);
    
    self.estimateLabel.text = [NSString stringWithFormat:@"%d days", self.guesstimatedDays];
    
    self.shakeMeView.backgroundColor = [UIColor whiteColor];
    self.resultsView.backgroundColor = [UIColor blackColor];
    self.anotherEstimateButton.alpha = 0;
    self.shareThisAppButton.alpha = 0;
    self.adBanner.hidden = YES;
    
    [self.view bringSubviewToFront:self.resultsView];
    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    [UIView animateWithDuration:0.5 animations:^{
        self.resultsView.backgroundColor = [UIColor whiteColor];
    } completion:^(BOOL finished) {
        self.adBanner.hidden = NO;
    }];
    
    [UIView animateWithDuration:0.5 delay:1.5 options:0 animations:^{
        self.shareThisAppButton.alpha = 1;
    } completion:nil];
    
    [UIView animateWithDuration:0.5 delay:2 options:0 animations:^{
        self.anotherEstimateButton.alpha = 1;
    } completion:^(BOOL finished) {
        self.detectShake = YES;
    }];
}

- (GSSillyActionGenerator *)actionGenerator
{
    if (_actionGenerator == nil) {
        _actionGenerator = [[GSSillyActionGenerator alloc]
                            initWithSentences:@[@"Hoisting the colors",
                                                @"Petting the dog",
                                                @"Flattering the project manager",
                                                @"Mowing the lawn",
                                                @"Staring at the actress",
                                                @"Disturbing the postman",
                                                @"Duplicating the bug",
                                                @"Fixing the issues",
                                                @"Recording the kitten",
                                                @"Fishing the fish",
                                                @"Obliterating the letter",
                                                @"Calibrating the gun",
                                                @"Taking out the trash",
                                                @"Dispatching the order",
                                                @"Scratching the head",
                                                @"Washing the dishes",
                                                @"Watering the plant",
                                                @"Running away from the zombies",
                                                @"Painting the French girls",
                                                @"Healing the tank",
                                                @"Chasing the fly",
                                                @"Pinning the guitar",
                                                @"Decorating the piano",
                                                @"Making fun of the client",
                                                @"Cleaning the carpet",
                                                @"Releasing the sheep",
                                                @"Throwing the holy hand grenade",
                                                @"Trolling the squirrel",
                                                @"Ordering the pizza",
                                                @"rm -rf the mushroom",
                                                @"Creating the portal"]];
    }
    
    return _actionGenerator;
}

- (IBAction)doShare:(id)sender
{
    NSArray *items = @[[NSURL URLWithString:@"https://itunes.apple.com/us/app/guesstimates-+/id870007083?ls=1&mt=8"]];
    UIActivityViewController *activity = [[UIActivityViewController alloc]
                                          initWithActivityItems:items
                                          applicationActivities:nil];
    [self presentViewController:activity animated:YES completion:nil];
}

- (IBAction)doReset:(id)sender
{
    self.guesstimatedDays = 0;
    [self.view bringSubviewToFront:self.shakeMeView];
}

@end
