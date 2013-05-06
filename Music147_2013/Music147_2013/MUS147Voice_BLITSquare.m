//
//  MUS147Voice_BLITSquare.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/5/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147Voice_BLITSquare.h"

#import "MUS147AQPlayer.h"

@implementation MUS147Voice_BLITSquare

-(id)init
{
    self = [super init];
    
    [self setFreq:220.];
    lastBlitOutput_ = 0.;
    dcbState_ = 0.;
    
    return self;
}

-(void)setFreq:(Float64)_freq
{
    freq = _freq;
    p_ = 0.5 * kSR / freq;
    rate_ = M_PI / p_;
    UInt32 maxHarmonics = (UInt32) floor( 0.5 * p_ );
    m_ = 2 * (maxHarmonics + 1);
    
    a_ = m_ / p_;
}

-(void)addToAudioBuffer:(Float64*)buffer:(UInt32)num_samples
{
    // https://ccrma.stanford.edu/software/stk/classstk_1_1BlitSquare.html
    // http://www.music.mcgill.ca/~gary/courses/2013/307/week5/bandlimited.html#SECTION00027000000000000000

    for (UInt32 i = 0; i < num_samples; i++)
    {
        Float64 s = 0.;
        Float64 temp = lastBlitOutput_;

        Float64 denominator = sin( phase_ );
        if ( fabs(denominator) <= 1e-12 ) {
            if ( phase_ < 0.1 || phase_ > ((2 * M_PI) - 0.1) )
                lastBlitOutput_ = a_;
            else
                lastBlitOutput_ = -a_;
        } else {
            lastBlitOutput_ =  sin( m_ * phase_ );
            lastBlitOutput_ /= p_ * denominator;
        }
        
        lastBlitOutput_ += temp;
        
        s = lastBlitOutput_ - dcbState_ + 0.999 * buffer[i];
        dcbState_ = lastBlitOutput_;

        buffer[i] += amp * s;
        
        phase_ += rate_;
        if ( phase_ >= (2 * M_PI) ) phase_ -= (2 * M_PI);
    }
}

@end
