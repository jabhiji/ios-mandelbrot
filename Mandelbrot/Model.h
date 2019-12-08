//
//  Model.h
//  Mandelbrot
//
//  Created by Abhijit Joshi on 5/28/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject
@property double xmin, xmax, ymin, ymax;
@property int nx, ny;
@property int MAX_ITER;
@property NSMutableArray* iters;
- (void) initializeItersArraySizeUsing_nx: (int) nx and_ny: (int) ny;
- (void) updateMandelbrotData;
@end
