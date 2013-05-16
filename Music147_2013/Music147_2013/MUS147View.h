//
//  MUS147View.h
//  Music147_2013
//
//  Created by Kojiro Umezaki on 5/3/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUS147View : UIView <UIAccelerometerDelegate> {
    UITouch* touch;
}

-(void)doTouchesOn:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)doTouchesOff:(NSSet *)touches withEvent:(UIEvent *)event;

@end
