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

// override superclass implementation of init
-(id) init
{
    self = [super init];
    if (self) {
        nx = 100;
        ny = 100;
        xmin = -2.0;
        xmax = 1.0;
        ymin = -1.5;
        ymax = 1.5;
    }
    
    return self;
}

@end