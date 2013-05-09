//
//  MUS147Sequencer.h
//  Music147_2013
//
//  Created by Lab User on 5/8/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MUS147Sequence.h"

@interface MUS147Sequencer : NSObject {
    MUS147Sequence* seq;
    Float64 scoreTime;
    Float64 bpm;
}

@property (readwrite) Float64 scoreTime;
@property (readwrite) Float64 bpm;

-(void)advanceScoreTime:(Float64)elapsed_seconds;

@end
