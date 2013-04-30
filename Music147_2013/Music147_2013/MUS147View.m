//
//  MUS147View.m
//  Music147_2013
//
//  Created by Kojiro Umezaki on 4/29/13.
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

-(void)doTouchEvent:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%d",touches.count);
    for (UITouch* t in touches)
    {
        CGPoint pt = [t locationInView:self];
        NSLog(@"%lf,%lf,%lf,%lf",pt.x,pt.y,self.bounds.size.width,self.bounds.size.height);
        Float64 relX =pt.x/self.bounds.size.width;
        Float64 relY =pt.y/self.bounds.size.height;
        [aqp getVoice:2].freq = relX * 2000.;
        [aqp getVoice:2].amp = (1.-relY);
    }
    NSLog(@"%lf",event.timestamp);
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[aqp getVoice:2] on];

    NSLog(@"touchesBegan");
    [self doTouchEvent:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesMoved");
    [self doTouchEvent:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
    [self doTouchEvent:touches withEvent:event];

    [[aqp getVoice:2] off];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesCancelled");
    [self doTouchEvent:touches withEvent:event];

    [[aqp getVoice:2] off];
}

@end
