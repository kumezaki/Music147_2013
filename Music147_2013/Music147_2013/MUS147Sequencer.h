//
//  MUS147Sequencer.h
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/7/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MUS147Sequence.h"

@interface MUS147Sequencer : NSObject {

    MUS147Sequence* seq;
    Float64 scoreTime;
    Float64 bpm;
    
    BOOL playing;
}

@property (readonly) MUS147Sequence* seq;
@property (readonly) Float64 scoreTime;
@property (readonly) Float64 bpm;

-(void)advanceScoreTime:(Float64)elapsed_seconds;

-(void)play;
-(void)stop;
-(void)rewind;

@end
