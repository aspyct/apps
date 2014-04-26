//
//  GSThinkingProgress.h
//  guesstimates
//
//  Created by Antoine d'Otreppe on 26/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GSThinkingProgress : NSObject

@property (readonly) float progress;
@property (readonly) BOOL finished;

- (void)think;

@end
