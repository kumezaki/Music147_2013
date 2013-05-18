//
//  MUS147Event_Touch.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/17/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Event_Touch.h"

#import "MUS147AQPlayer.h"
extern MUS147AQPlayer* aqp;

@implementation MUS147Event_Touch

@synthesize x;
@synthesize y;
@synthesize type;

-(void)doOn
{
//    NSLog(@"%f %f %f %s %f touch %s",startTime,x,y,"doOn",duration,type?"on":"off");

    if (voice == nil)
        voice = [aqp getSynthVoice];
    
    if (type == kMUS147Event_Touch_OFF)
    {
        voice.amp = 0.0;
    }
    else
    {
        voice.amp = 1. - y;
        voice.freq = x * 2000.;
    }

    on = YES;
}

-(void)doOff
{
//    NSLog(@"%f %f %f %s %f touch %s",startTime,x,y,"doOff",duration,type?"on":"off");

    voice = nil;

    on = NO;
}

@end
