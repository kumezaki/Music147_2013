//
//  MUS147View.h
//  Music147_2013
//
//  Created by Kojiro Umezaki on 4/29/13.
//  Copyright (c) 2013 Kojiro Umezaki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MUS147View : UIView

-(void)doTouchEvent:(NSSet *)touches withEvent:(UIEvent *)event;

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
