//
//  MUS147Sequencer.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/7/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Sequencer.h"

#import "MUS147Event.h"

@implementation MUS147Sequencer

@synthesize seq;
@synthesize scoreTime;
@synthesize bpm;

-(id)init
{
    self = [super init];
    
    seq = [[MUS147Sequence alloc] init];
    scoreTime = 0.;
    bpm = 60.;
    playing = NO;
    
    return self;
}

-(void)advanceScoreTime:(Float64)elapsed_seconds
{
    if (!playing) return;
    
    Float64 elapsed_beats = bpm / 60. * elapsed_seconds;

    scoreTime += elapsed_beats;

    NSLog(@"%lf",scoreTime);

    for (UInt32 i = 0; i < seq.numEvents; i++)
    {
        MUS147Event* event = [seq getEvent:i];
        if (scoreTime < event.startTime)
        {
            // WAITING
            if (event.on)
                [event doOff];
        }
        else if (event.startTime <= scoreTime || scoreTime < (event.startTime + event.duration))
        {
            // PLAYING
            if (!event.on)
                [event doOn];
        }
        else
        {
            // DONE
            if (event.on)
                [event doOff];
        }
    }
}

-(void)play
{
    playing = YES;
}

-(void)stop
{
    playing = NO;
    
    for (UInt32 i = 0; i < seq.numEvents; i++)
        [[seq getEvent:i] doOff];
}

-(void)rewind
{
    scoreTime = 0.;
}

@end
