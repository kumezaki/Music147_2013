//
//  MUS147Sequence.h
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/7/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MUS147Event.h"

#define kMaxNumSeqEvents    100

@interface MUS147Sequence : NSObject {

    MUS147Event* events[kMaxNumSeqEvents];
    
    UInt32 numEvents;
}

@property (readwrite) UInt32 numEvents;

-(MUS147Event*)getEvent:(UInt32)pos;

@end
