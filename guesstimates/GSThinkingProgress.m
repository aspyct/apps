//
//  GSThinkingProgress.m
//  guesstimates
//
//  Created by Antoine d'Otreppe on 26/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GSThinkingProgress.h"

@implementation GSThinkingProgress

@synthesize progress=_progress;

- (void)think
{
    float maxProgress;
    float minProgress;
    float progressRange;
    float randomProgress;
    
    maxProgress = self.progress + 25;
    minProgress = MAX(self.progress - 5, 5);
    
    progressRange = maxProgress - minProgress;
    randomProgress = arc4random_uniform(progressRange);
    
    _progress = minProgress + randomProgress;
}

- (BOOL)finished
{
    return _progress >= 100;
}

@end
