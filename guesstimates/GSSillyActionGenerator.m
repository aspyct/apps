//
//  GSSillyActionGenerator.m
//  guesstimates
//
//  Created by Antoine d'Otreppe on 26/04/14.
//  Copyright (c) 2014 Antoine d'Otreppe. All rights reserved.
//

#import "GSSillyActionGenerator.h"

@interface GSSillyActionGenerator ()

@property (strong, nonatomic) NSArray *verbs;
@property (strong, nonatomic) NSArray *nouns;

@end

@implementation GSSillyActionGenerator

- (id)initWithSentences:(NSArray *)sentences
{
    self = [super init];
    
    if (self) {
        [self splitSentences:sentences];
    }
    
    return self;
}

- (NSString *)actSilly
{
    NSUInteger randomVerb;
    NSUInteger randomNoun;
    NSString *verb;
    NSString *noun;
    
    randomVerb = arc4random_uniform(self.verbs.count);
    randomNoun = arc4random_uniform(self.nouns.count);
    
    verb = [self.verbs objectAtIndex:randomVerb];
    noun = [self.nouns objectAtIndex:randomNoun];
    
    return [NSString stringWithFormat:@"%@%@", verb, noun, nil];
}

- (void)splitSentences:(NSArray *)sentences
{
    NSRange range;
    NSMutableArray *verbs = [NSMutableArray arrayWithCapacity:sentences.count];
    NSMutableArray *nouns = [NSMutableArray arrayWithCapacity:sentences.count];
    
    for (NSString *sentence in sentences) {
        range = [sentence rangeOfString:@" the "];
        if (range.location != NSNotFound) {
            NSString *verb;
            NSString *noun;
            
            verb = [sentence substringToIndex:range.location];
            noun = [sentence substringFromIndex:range.location];
            
            [verbs addObject:verb];
            [nouns addObject:noun];
        } else {
            [NSException raise:@"Not a correct sentence"
                        format:@"Could not find 'the' in %@", sentence, nil];
        }
    }
    
    self.verbs = verbs;
    self.nouns = nouns;
}

@end
