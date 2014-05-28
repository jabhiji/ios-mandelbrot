//
//  DrawMandelbrot.m
//  Mandelbrot
//
//  Created by Abhijit Joshi on 5/28/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "DrawMandelbrot.h"

@implementation DrawMandelbrot

@synthesize nx, ny;
@synthesize MAX_ITER;
@synthesize data;

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
    
    float dx = width/nx;
    float dy = height/ny;
    
    // assign color based on the number of iterations - Red Green Blue (RGB)`
    
    for(int i = 0; i < nx; i++) {
        for(int j = 0; j < ny; j++) {
            
            double x = i*dx;   // screen x coordinate
            double y = (ny-j-1)*dy;   // screen y coordinate
            
            int N = i + nx*j;
            int VAL = [[data objectAtIndex:N] intValue];
                        
            UIColor* fillColor;
            
            if(VAL==MAX_ITER)
            {
                fillColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];   // black
            }
            else
            {
                // ratio of iterations required to escape
                // the higher this value, the closer the point is to the set
                float frac = (float) VAL / MAX_ITER;
                
                if(frac <= 0.5)
                {
                    // yellow to blue transition
                    fillColor = [UIColor colorWithRed:2*frac green:2*frac blue:1.0 - 2*frac alpha:1.0];
                    //glColor3f(2*frac,2*frac,1-2*frac);
                }
                else
                {
                    // red to yellow transition
                    fillColor = [UIColor colorWithRed:1.0 green:2.0-2.0*frac blue:0.0 alpha:1.0];
                    //glColor3f(1,2-2*frac,0);
                }
            }

            // draw colored rectangle
            CGRect rect = CGRectMake(x, y, dx, dy);
            [fillColor setFill];
            CGContextFillRect(context, rect);
        }
    }
}

@end
