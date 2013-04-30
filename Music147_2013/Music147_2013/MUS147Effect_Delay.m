//
//  MUS147Effect_Delay.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 4/29/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Effect_Delay.h"

@implementation MUS147Effect_Delay

@synthesize delayAmp;
@synthesize delayTime;

-(id)init
{
	delayAmp = 0.5;
	delayTime = kMaxDelayTime * 0.1;
	
	readPos = kMaxDelaySamples - (kMaxDelaySamples * delayTime / kMaxDelayTime);
	writePos = 0;
	
	return self;
}

-(void)processAudioBuffer:(Float64*)buffer:(UInt32)num_samples
{
	/* read from delay buffer */
	for (UInt32 i = 0; i < num_samples; i++)
		buffer[i] += buffer[i] + delayAmp * delayBuffer[(i+readPos)%kMaxDelaySamples];
	
	readPos += num_samples;
	readPos %= kMaxDelaySamples;
    
	/* write into delay buffer */
	for (UInt32 i = 0; i < num_samples; i++)
		delayBuffer[(i+writePos)%kMaxDelaySamples] = buffer[i];
	
	writePos += num_samples;
	writePos %= kMaxDelaySamples;
}

@end
