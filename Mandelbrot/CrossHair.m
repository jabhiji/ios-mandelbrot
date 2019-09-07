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
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;

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
    [[UIColor whiteColor] setStroke];
    CGContextDrawPath(context, kCGPathStroke);
}

@end
