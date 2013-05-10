//
//  MUS147Event.m
//  Music147_2013
//
//  Created by Lab User on 5/8/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Event.h"

#import "MUS147AQPlayer.h"
extern MUS147AQPlayer* aqp;

@implementation MUS147Event

@synthesize startTime;
@synthesize duration;
@synthesize noteNum;
@synthesize on;

-(void)doOn
{
    voice = [aqp getVoice:2];
    voice.freq = pow(2.,((Float64)noteNum-69)/12.)*440.;
    on = YES;
    voice.amp = 1.0;
}

-(void)doOff
{
    voice.amp = 0.0;
    on = NO;
    voice = nil;
}

@end
