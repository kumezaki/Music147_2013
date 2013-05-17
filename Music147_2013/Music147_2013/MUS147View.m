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

-(void)awakeFromNib
{
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (touch == nil) return; /* guard */
    
    // Drawing code
    UIColor *uciBlueColor = [UIColor colorWithRed:0./255. green:34./255. blue:68./255. alpha:1.];
    UIColor *uciGoldColor = [UIColor colorWithRed:255./255. green:222./255. blue:108./255. alpha:1.];

    CGPoint pt = [touch locationInView:self];

    Float64 w = 30.;
    Float64 h = w;

    [uciGoldColor set];
    UIRectFill(CGRectMake(pt.x-w/2, pt.y-h/2, w, h));

    [uciBlueColor set];
    UIRectFrame(CGRectMake(pt.x-w/2, pt.y-h/2, w, h));
}

-(void)doTouchesOn:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* t in touches)
    {
        CGPoint pt = [t locationInView:self];
        Float64 x = pt.x/self.bounds.size.width;
        Float64 y = pt.y/self.bounds.size.height;
        
        [aqp getSynthVoice].freq = x * 2000.;
        [aqp getSynthVoice].amp = 1. - y;
        
        if (aqp.sequencer.recording)
            [aqp.sequencer addTouchEvent:x :y :YES];

        touch = t;
    }
    [self setNeedsDisplay];
}

-(void)doTouchesOff:(NSSet *)touches withEvent:(UIEvent *)event
{
    [aqp getSynthVoice].amp = 0.;

    if (aqp.sequencer.recording)
        [aqp.sequencer addTouchEvent:x :y :NO];

    touch = nil;

    [self setNeedsDisplay];
}
    
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouchesOn:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouchesOn:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouchesOff:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self doTouchesOff:touches withEvent:event];
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    NSLog(@"%f %f %f",acceleration.x,acceleration.y,acceleration.z);
}

@end
