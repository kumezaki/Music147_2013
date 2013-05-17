//
//  MUS147Sequencer.m
//  Music147_2013
//
//  Created by Lab User on 5/8/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Sequencer.h"

#import "MUS147Event_Touch.h"

@implementation MUS147Sequencer

@synthesize scoreTime;
@synthesize bpm;
@synthesize playing;
@synthesize recording;

-(id)init
{
    self = [super init];
    
    seq = [[MUS147Sequence alloc] init];
    scoreTime = 0.;
    bpm = 60.;
    playing = NO;
    recording = NO;
    
    return self;
}

-(void)advanceScoreTime:(Float64)elapsed_seconds
{
    if (!playing && !recording) return;
    
    Float64 elapsed_beats = bpm / 60. * elapsed_seconds;
    scoreTime += elapsed_beats;
    
    for (UInt32 i = 0; i < seq.numEvents; i++)
    {
        MUS147Event* event = [seq getEvent:i];

        if (scoreTime < event.startTime)
        {
            // WAIT
            if (event.on)
                [event doOff];
        }
        else if (scoreTime >= event.startTime + event.duration)
        {
            // DONE
            if (event.on)
                [event doOff];
        }
        else
        {
            // PLAYING
            if (!event.on)
                [event doOn];
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
    recording = NO;

    for (UInt32 i = 0; i < seq.numEvents; i++)
    {
        MUS147Event* event = [seq getEvent:i];
        [event doOff];
    }
}

-(void)rewind
{
    scoreTime = 0.;
}

-(void)record
{
    recording = YES;
}

-(void)addTouchEvent:(Float64)x :(Float64)y :(BOOL)on
{
    if (!recording) return;
    
    MUS147Event_Touch* e = [[MUS147Event_Touch alloc] init];
    e.startTime = scoreTime;
    e.duration; // need to assign this
    e.x = x;
    e.y = y;
    e.on = on ? kMUS147Event_Touch_ON : kMUS147Event_Touch_OFF;
}

@end
