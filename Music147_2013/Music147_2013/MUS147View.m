//
//  MUS147View.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/3/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import "MUS147View.h"

#import "MUS147AQPlayer.h"
extern MUS147AQPlayer* aqp;

@implementation MUS147View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)doTouches:(NSSet*)touches:(UIEvent*)event
{
    for (UITouch* t in touches)
    {
        CGPoint pt = [t locationInView:self];
        Float64 x = pt.x/self.bounds.size.width;
        Float64 y = pt.y/self.bounds.size.height;
        
        [aqp getVoice:2].freq = x * 2000.;
        [aqp getVoice:2].amp = (1. - y);
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouches:touches:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouches:touches:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouches:touches:event];
    [aqp getVoice:2].amp = 0.;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouches:touches:event];
    [aqp getVoice:2].amp = 0.;
}

@end
