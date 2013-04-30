//
//  MUS147Voice.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 4/26/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Voice.h"

@implementation MUS147Voice

@synthesize freq;
@synthesize amp;
@synthesize speed;

-(id)init
{
    self = [super init];
    
	env = [[MUS147Envelope alloc] init];
	env.attack = 0.5;
	env.release = 0.5;
    
    return self;
}

-(void)addToAudioBuffer:(Float64*)buffer:(UInt32)num_samples
{
    // does nothing
}

-(BOOL)isOn
{
    return env.output > 0.;
}

-(void)on
{
    [env on];
}

-(void)off
{
    [env off];
}

@end
