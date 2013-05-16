//
//  MUS147Sequence.m
//  Music147_2013
//
//  Created by Lab User on 5/8/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Sequence.h"

@implementation MUS147Sequence

@synthesize numEvents;

-(id)init
{
    self = [super init];
    
    events[0] = [[MUS147Event alloc] init];
    events[0].startTime = 0.;
    events[0].duration = 1.;
    events[0].noteNum = 60;
    
    events[1] = [[MUS147Event alloc] init];
    events[1].startTime = 1.5;
    events[1].duration = 0.5;
    events[1].noteNum = 65;
   
    events[2] = [[MUS147Event alloc] init];
    events[2].startTime = 2.25;
    events[2].duration = 0.25;
    events[2].noteNum = 67;
    
    events[3] = [[MUS147Event alloc] init];
    events[3].startTime = 3.75;
    events[3].duration = 0.75;
    events[3].noteNum = 62;
    
    numEvents = 4;
    
    return self;
}

-(MUS147Event*)getEvent:(UInt32)pos
{
    return events[pos];
}

@end
