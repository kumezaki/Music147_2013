//
//  MUS147AQPlayer.h
//  Music147_2013
//
//  Created by Kojiro Umezaki on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <Foundation/Foundation.h>

#import "MUS147Sequencer.h"
#import "MUS147Voice.h"

@class MUS147Effect;

// number of buffers used by system
#define kNumBuffers     3

// number of possible voices
#define kNumVoices      4

// number of possible effects
#define kNumEffects      2

// sample rate
#define kSR				22050.

@interface MUS147AQPlayer : NSObject {

	AudioQueueRef				queue;
	AudioQueueBufferRef			buffers[kNumBuffers];
	AudioStreamBasicDescription	dataFormat;
    
    UInt8 synthVoice;
    
    MUS147Voice* voice[kNumVoices];
    
    MUS147Effect* effect[kNumEffects];
    
    MUS147Sequencer* sequencer;
}

@property (readonly) MUS147Sequencer* sequencer;

-(void)setup;

-(OSStatus)start;
-(OSStatus)stop;

-(MUS147Voice*)getVoice:(UInt8)pos;

-(MUS147Voice*)getSynthVoice;
-(void)setSynthVoice:(UInt8)pos;

-(void)reportElapsedFrames:(UInt32)num_frames;

-(void)fillAudioBuffer:(Float64*)buffer:(UInt32)num_samples;

@end
