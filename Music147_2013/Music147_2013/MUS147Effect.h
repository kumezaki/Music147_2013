//
//  MUS147Effect.h
//  Music147_2013
//
//  Created by Kojiro Umezaki on 4/29/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MUS147AQPlayer.h"

@interface MUS147Effect : NSObject

-(void)processAudioBuffer:(Float64*)buffer:(UInt32)num_samples;

@end
