//
//  CrossHair.m
//  Mandelbrot
//
//  Created by Abhijit Joshi on 5/28/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "CrossHair.h"

@implementation CrossHair

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // get the current context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // context size in pixels
    size_t WIDTH = CGBitmapContextGetWidth(context);
    size_t HEIGHT = CGBitmapContextGetHeight(context);
    
    // for retina display, 1 point = 2 pixels
    // context size in screen points
    float width = WIDTH/2.0;
    float height = HEIGHT/2.0;
    
    // vertical centerline
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, width/2.0, 0.0);
    CGContextAddLineToPoint(context, width/2.0, height);
    [[UIColor yellowColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);

    // horizontal centerline
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0, height/2.0);
    CGContextAddLineToPoint(context, width, height/2.0);
    [[UIColor yellowColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}

@end
