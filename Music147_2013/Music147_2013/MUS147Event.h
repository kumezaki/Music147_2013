//
//  MUS147Event.h
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/7/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MUS147Voice.h"

@interface MUS147Event : NSObject {
    Float64 startTime;
    Float64 duration;
    SInt16 noteNumber;
    BOOL on;
    MUS147Voice* voice;
}

@property (readwrite) Float64 startTime;
@property (readwrite) Float64 duration;
@property (readwrite) SInt16 noteNumber;
@property (readwrite) BOOL on;
@property (readwrite) MUS147Voice* voice;

-(void)doOn;
-(void)doOff;

@end
