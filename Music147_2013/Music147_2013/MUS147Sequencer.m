//
//  MUS147Sequencer.m
//  Music147_2013
//
//  Created by Lab User on 5/8/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Sequencer.h"

@implementation MUS147Sequencer

@synthesize scoreTime;
@synthesize bpm;

-(id)init
{
    self = [super init];
    
    seq = [[MUS147Sequence alloc] init];
    scoreTime = 0.;
    bpm = 60.;
    
    return self;
}

-(void)advanceScoreTime:(Float64)elapsed_seconds
{
    Float64 elapsed_beats = bpm / 60. * elapsed_seconds;
    scoreTime += elapsed_beats;
    
    for (UInt32 i = 0; i < 2; i++)
    {
        MUS147Event* event = [seq getEvent:i];

        if (scoreTime < event.startTime)
        {
            // WAIT
        }
        else if (scoreTime >= event.startTime + event.duration)
        {
            // DONE
        }
        else
        {
            // PLAYING
        }
    }
         
}

-(void)play{
    
}

-(void)stop{
    
}

-(void)rewind{
    
}

@end
