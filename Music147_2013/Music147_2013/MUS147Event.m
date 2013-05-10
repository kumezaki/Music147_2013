//
//  MUS147Event.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/7/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Event.h"

#import "MUS147AQPlayer.h"
extern MUS147AQPlayer* aqp;

@implementation MUS147Event

@synthesize startTime;
@synthesize duration;
@synthesize noteNumber;
@synthesize on;
@synthesize voice;

-(void)doOn
{
    voice = [aqp getVoice:2];
    voice.freq = pow(2.,((Float64)noteNumber-69)/12.)*440.;
    on = YES;
    [voice doOn];
}

-(void)doOff
{
    [voice doOff];
    on = NO;
    voice = nil;
}

@end
