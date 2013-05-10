//
//  MUS147Sequence.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/7/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Sequence.h"

@implementation MUS147Sequence

@synthesize numEvents;

-(id)init
{
    self = [super init];
    
    events[0] = [[MUS147Event alloc] init];
    events[0].startTime = 0.0;
    events[0].duration = 1.00;
    events[0].noteNumber = 60.;
    
    events[1] = [[MUS147Event alloc] init];
    events[1].startTime = 2.0;
    events[1].duration = 0.25;
    events[1].noteNumber = 62.;

    events[2] = [[MUS147Event alloc] init];
    events[2].startTime = 2.5;
    events[2].duration = 1.00;
    events[2].noteNumber = 67.;

    events[3] = [[MUS147Event alloc] init];
    events[3].startTime = 4.0;
    events[3].duration = 1.00;
    events[3].noteNumber = 65.;
    
    numEvents = 4;

    return self;
}

-(MUS147Event*)getEvent:(UInt32)pos
{
    return events[pos];
}

@end
