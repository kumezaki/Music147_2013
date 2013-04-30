//
//  MUS147Effect_Delay.h
//  Music147_2013
//
//  Created by Kojiro Umezaki on 4/29/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Effect.h"

#define kMaxDelayTime		5.0
#define kMaxDelaySamples	(UInt32)(kSR * kMaxDelayTime)

@interface MUS147Effect_Delay : MUS147Effect {

    Float64	delayBuffer[kMaxDelaySamples];
    UInt32	readPos;
    UInt32	writePos;
    
    Float64 delayAmp;
    Float64 delayTime;
}

@property (readwrite) Float64 delayAmp;
@property (readwrite) Float64 delayTime;

@end
