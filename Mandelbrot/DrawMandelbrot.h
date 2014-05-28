//
//  DrawMandelbrot.h
//  Mandelbrot
//
//  Created by Abhijit Joshi on 5/28/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawMandelbrot : UIView
@property int nx, ny;
@property int MAX_ITER;
@property NSMutableArray* data;
- (void) initData;
@end