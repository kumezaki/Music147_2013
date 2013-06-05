//
//  MUS147AQPlayer.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 4/4/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MUS147AQPlayer.h"

#import "MUS147Effect_BiQuad.h"
#import "MUS147Effect_Delay.h"
#import "MUS147Effect_Limiter.h"
#import "MUS147Voice_Sample_SF.h"
#import "MUS147Voice_Sample_Mem.h"
#import "MUS147Voice_Synth.h"
#import "MUS147Voice_BLIT.h"
#import "MUS147Voice_BLITSaw.h"

MUS147AQPlayer *aqp = nil;

void MUS147AQBufferCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inAQBuffer);

void MUS147AQBufferCallback(void *inUserData, AudioQueueRef inAQ, AudioQueueBufferRef inAQBuffer)
{
    // compute the requested number of sample frames of audio
	const SInt32 numFrames = (inAQBuffer->mAudioDataBytesCapacity) / sizeof(SInt16);
    
    // create a temporary buffer of Float64 type samples
	Float64 buffer[numFrames];
    
    // set all sample values in buffer to zero (no sound)
    memset(buffer,0,sizeof(Float64)*numFrames);
	
    // call AQPlayer fillAudioBuffer method to get a new block of samples
	[aqp doAudioBuffer:buffer:numFrames];
	
    // fill the outgoing buffer as SInt16 type samples
	for (SInt32 i = 0; i < numFrames; i++)
		((SInt16 *)inAQBuffer->mAudioData)[i] = buffer[i] * (SInt16)INT16_MAX;
	
    // set the mAudioDataByteSize and mPacketDescriptionCount AudioQueueBuffer fields (for some reason)
	inAQBuffer->mAudioDataByteSize = 512;
	inAQBuffer->mPacketDescriptionCount = 0;
    
	// queue the updated AudioQueueBuffer
	AudioQueueEnqueueBuffer(inAQ, inAQBuffer, 0, nil);
    
    @autoreleasepool {
        [aqp reportElapsedFrames:numFrames];
    }
}

@implementation MUS147AQPlayer

@synthesize sequencer;
@synthesize synthVoiceType;

-(void)dealloc
{
	[self stop];
}

-(id)init
{
    self = [super init];
    
	aqp = self;
    
//    voice_samp_mem = [[NSMutableArray alloc] init];
//    voice_samp_sf = [[NSMutableArray alloc] init];
//    voice_synth_blit = [[NSMutableArray alloc] init];
//    voice_synth_blitsaw = [[NSMutableArray alloc] init];
//    voice = [[NSMutableArray alloc] init];
//    effect = [[NSMutableArray alloc] init];

    // first allocate pools of voices ...
    voice_samp_mem[0] = [[MUS147Voice_Sample_Mem alloc] init];
//    [voice_samp_mem insertObject:[[MUS147Voice_Sample_Mem alloc] init] atIndex:0];
    voice_samp_sf[0] = [[MUS147Voice_Sample_SF alloc] init];
//    [voice_samp_sf insertObject:[[MUS147Voice_Sample_SF alloc] init] atIndex:0];

    for (UInt8 i = 0; i < kNumVoices_Synth; i++)
    {
        voice_synth_blit[i] = [[MUS147Voice_BLIT alloc] init];
//        [voice_synth_blit insertObject:[[MUS147Voice_BLIT alloc] init] atIndex:i];
        voice_synth_blitsaw[i] = [[MUS147Voice_BLITSaw alloc] init];
//        [voice_synth_blitsaw insertObject:[[MUS147Voice_BLITSaw alloc] init] atIndex:i];
    }

    // ... then assign them to array of active voices
    for (UInt8 i = 0; i < kNumVoices; i++)
    {
        switch (i)
        {
            case 0:
                voice[i] = voice_samp_mem[0];
//                [voice insertObject:[voice_samp_mem objectAtIndex:0] atIndex:i];
                break;
            case 1:
                voice[i] = voice_samp_sf[0];
//                [voice insertObject:[voice_samp_sf objectAtIndex:0] atIndex:i];
                break;
            case 2:
            case 3:
            case 4:
            case 5:
                voice[i] = voice_synth_blit[i-2];
//                [voice insertObject:[voice_synth_blit objectAtIndex:i-2] atIndex:i];
                break;
            default:
                break;
        }
    }
    
    for (UInt8 i = 0; i < kNumEffects; i++)
    {
        switch (i)
        {
            case 0:
            {
                MUS147Effect_BiQuad* bq = [[MUS147Effect_BiQuad alloc] init];
                [bq biQuad_set:LPF:0.:5000.:kSR:1.0];
                effect[i] = bq;
//                [effect insertObject:bq atIndex:i];
                break;
            }
            case 1:
                effect[i] = [[MUS147Effect_Delay alloc] init];
//                [effect insertObject:[[MUS147Effect_Delay alloc] init] atIndex:i];
                break;
            case 2:
                effect[i] = [[MUS147Effect_Limiter alloc] init];
//                [effect insertObject:[[MUS147Effect_Limiter alloc] init] atIndex:i];
                break;
            default:
                break;
        }
    }
    
    sequencer = [[MUS147Sequencer alloc] init];
    
	[self start];
    
	return self;
}

-(void)setup
{
	dataFormat.mFormatID = kAudioFormatLinearPCM;
	dataFormat.mFormatFlags = kAudioFormatFlagIsSignedInteger;
	dataFormat.mChannelsPerFrame = 1;
	dataFormat.mSampleRate = kSR;
	dataFormat.mBitsPerChannel = 16;
	dataFormat.mFramesPerPacket = 1;
	dataFormat.mBytesPerPacket = sizeof(SInt16);
	dataFormat.mBytesPerFrame = sizeof(SInt16);

    OSStatus result = AudioQueueNewOutput(&dataFormat, MUS147AQBufferCallback, nil, nil, nil, 0, &queue);
	
	if (result != noErr)
		NSLog(@"AudioQueueNewOutput %ld\n",result);
	
    for (SInt32 i = 0; i < kNumBuffers_Playback; i++)
	{
		result = AudioQueueAllocateBuffer(queue, 512, &buffers[i]);
		if (result != noErr)
			NSLog(@"AudioQueueAllocateBuffer %ld\n",result);
	}
}

-(OSStatus)start
{
	OSStatus result = noErr;

    // if we have no queue, create one now
    if (queue == nil)
        [self setup];
    
    // prime the queue with some data before starting
    for (SInt32 i = 0; i < kNumBuffers_Playback; ++i)
        MUS147AQBufferCallback(nil, queue, buffers[i]);
	
    result = AudioQueueStart(queue, nil);
		
	return result;
}

-(OSStatus)stop
{
	OSStatus result = noErr;

    result = AudioQueueStop(queue, true);
	
	return result;
}

-(void)setSynthVoiceType:(UInt8)type
{
    synthVoiceType = type;
    
    switch (synthVoiceType)
    {
        case 0:
            for (UInt8 i = 0; i < kNumVoices_Synth; i++)
                voice[i+2] = voice_synth_blit[i];
//                [voice replaceObjectAtIndex:i+2 withObject:[voice_synth_blit objectAtIndex:i]];
            break;
        case 1:
            for (UInt8 i = 0; i < kNumVoices_Synth; i++)
                voice[i+2] = voice_synth_blitsaw[i];
//                [voice replaceObjectAtIndex:i+2 withObject:[voice_synth_blitsaw objectAtIndex:i]];
            break;
    }
}

-(MUS147Voice*)getVoice:(UInt8)pos
{
//    return [voice objectAtIndex:pos];
    return voice[pos];
}

-(MUS147Voice*)getSynthVoice
{
    MUS147Voice* v = nil;
    
    switch (synthVoiceType)
    {
        case 0:
            for (UInt8 i = 0; i < kNumVoices_Synth; i++)
                if (![voice_synth_blit[i] isOn])
                    v = voice_synth_blit[i];
//                if (![[voice_synth_blit objectAtIndex:i] isOn])
//                    v = [voice_synth_blit objectAtIndex:i];
            break;
        case 1:
            for (UInt8 i = 0; i < kNumVoices_Synth; i++)
                if (![voice_synth_blitsaw[i] isOn])
                    v = voice_synth_blitsaw[i];
//                if (![[voice_synth_blitsaw objectAtIndex:i] isOn])
//                    v = [voice_synth_blitsaw objectAtIndex:i];
            break;
        default:
            break;
    }

    return v;
}

-(MUS147Voice*)getRecordVoice
{
//    return [voice objectAtIndex:0];
    return voice[0];
}

-(MUS147Effect_BiQuad*)getBiQuad
{
//    return (MUS147Effect_BiQuad*)[effect objectAtIndex:0];
    return (MUS147Effect_BiQuad*)effect[0];
}

-(void)reportElapsedFrames:(UInt32)num_frames
{
    [sequencer advanceScoreTime:num_frames/kSR];

//    NSLog(@"%f",num_frames/kSR);
}

-(void)doAudioBuffer:(Float64*)buffer :(UInt32)num_samples
{
    for (UInt8 i = 0; i < kNumVoices; i++)
    {
//        [[voice objectAtIndex:i] addToAudioBuffer:buffer:num_samples];
        [voice[i] addToAudioBuffer:buffer:num_samples];
    }
    
    for (UInt8 i = 0; i < kNumEffects; i++)
    {
//        [[effect objectAtIndex:i] processAudioBuffer:buffer:num_samples];
        [effect[i] processAudioBuffer:buffer:num_samples];
    }
}

@end
