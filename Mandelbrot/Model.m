//
//  Model.m
//  Mandelbrot
//
//  Created by Abhijit Joshi on 5/28/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "Model.h"

@implementation Model
@synthesize xmin, xmax, ymin, ymax;
@synthesize nx, ny;
@synthesize MAX_ITER;
@synthesize iters;

// override superclass implementation of init
-(id) init
{
    self = [super init];
    if (self) {
        nx = 400;
        ny = 400;
        xmin = -2.0;
        xmax = 1.0;
        ymin = -1.5;
        ymax = 1.5;
        MAX_ITER = 200;
        
        // allocate 2D array
        iters = [[NSMutableArray alloc] initWithCapacity:nx*ny];
        
        // initialize the 2D "iters" array, which
        // represents the number of iterations it takes for the
        // point to escape from the set
        
        for(int i = 0; i < nx; i++) {
            for(int j = 0; j < ny; j++) {
                [iters addObject:@(0)];
            }
        }
    }
    
    return self;
}

// this function checks if a point (x,y) is a member of the Mandelbrot set
// it returns the number of iterations it takes for this point to escape from the set
// if (x,y) is inside the set, it will not escape even after the maximum number of iterations
// and this function will take a long time to compute this and return the maximum iterations

- (int) Mandelbrot_Member_x:(double) x and_y: (double) y
{
    double cx = x, cy = y;
    double zx = 0.0, zy = 0.0;
    
    int iter = 0;
    
    while(iter < MAX_ITER)
    {
        iter++;
        double real = zx*zx - zy*zy + cx;
        double imag = 2.0*zx*zy + cy;
        double mag = sqrt(real*real + imag*imag);
        if (mag > 2.0) break;   // (x,y) is outside the set, quick exit from this loop
        zx = real;
        zy = imag;
    }
    return iter;
}

// update the 2D array which stores "iterations to escape" based on the
// current window
- (void) updateMandelbrotData
{
    double dx = (xmax - xmin)/nx; // grid spacing along X
    double dy = (ymax - ymin)/ny; // grid spacing along Y
    
    // update the 2D "iters" array, which
    // represents the number of iterations it takes for the
    // point to escape from the set
    
    for(int i = 0; i < nx; i++) {
        for(int j = 0; j < ny; j++) {
            
            double x = xmin + dx/2 + i*dx;   // actual x coordinate
            double y = ymin + dy/2 + j*dy;   // actual y coordinate
            
            // calculate iterations to escape
            int iterationsToEscape = [self Mandelbrot_Member_x: x and_y: y];
            
            // natural index
            int N = i + nx*j;
            
            // add this entry to the 2D "iters" array
            [iters removeObjectAtIndex:N];
            [iters insertObject:@(iterationsToEscape) atIndex:N];
        }
    }
}

@end