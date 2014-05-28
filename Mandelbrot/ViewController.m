//
//  ViewController.m
//  Mandelbrot
//
//  Created by Abhijit Joshi on 5/27/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "ViewController.h"
#import "CrossHair.h"
#import "Model.h"
#import "DrawMandelbrot.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *blackBox;
@property (strong, nonatomic) CrossHair* cross;
@property (strong, nonatomic) Model* model;
@property (strong, nonatomic) DrawMandelbrot* drawSet;
- (IBAction)backToSquareOne:(id)sender;
@end

@implementation ViewController
@synthesize blackBox;
@synthesize cross;
@synthesize model;
@synthesize drawSet;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // initialize the model
    model = [[Model alloc] init];
    
    [self drawMandelbrotSet];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// touch events determine where we need to zoom in
//   +------+------+
//   |      |      |
//   |  1   |   2  |
//   |      |      |
//   +------+------+
//   |      |      |
//   |  3   |   4  |
//   |      |      |
//   +------+------+

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* t in touches) {
        CGPoint touchLocation;
        touchLocation = [t locationInView:blackBox];
        float x = touchLocation.x;
        float y = touchLocation.y;
        
        float width = blackBox.frame.size.width;
        float height = blackBox.frame.size.height;
        
        float dx = width / 2;
        float dy = height / 2;
        
        // find out array location where finger touches the screen
        int xIndex = x/dx;
        int yIndex = y/dy;
        int N = (xIndex + 2*yIndex) + 1;
        
        NSLog(@"Zooming in to region %d", N);
        
        switch (N) {
            case 1:
                model.xmax = model.xmin + (model.xmax - model.xmin)/2;
                model.ymin = model.ymin + (model.ymax - model.ymin)/2;
                break;
                
            case 2:
                model.xmin = model.xmin + (model.xmax - model.xmin)/2;
                model.ymin = model.ymin + (model.ymax - model.ymin)/2;
            
            case 3:
                model.xmax = model.xmin + (model.xmax - model.xmin)/2;
                model.ymax = model.ymin + (model.ymax - model.ymin)/2;
                
            case 4:
                model.xmin = model.xmin + (model.xmax - model.xmin)/2;
                model.ymax = model.ymin + (model.ymax - model.ymin)/2;
                
            default:
                break;
        }
    }
    
    [self drawMandelbrotSet];
}

- (void) drawMandelbrotSet
{
    [model updateMandelbrotData];
    
    // black box view dimensions
    float width = blackBox.frame.size.width;
    float height = blackBox.frame.size.height;
    
    // draw the view
    CGRect viewRect = CGRectMake(0, 0, width , height);
    drawSet = [[DrawMandelbrot alloc] initWithFrame:viewRect];
    drawSet.nx = model.nx;
    drawSet.ny = model.ny;
    drawSet.MAX_ITER = model.MAX_ITER;
    drawSet.data = model.iters;
    [blackBox addSubview:drawSet];
    
    // draw the cross hairs
    CGRect myRect = CGRectMake(0, 0, width, height);
    cross = [[CrossHair alloc] initWithFrame:myRect];
    [cross setBackgroundColor:[UIColor clearColor]];
    [blackBox addSubview:cross];
}

- (IBAction)backToSquareOne:(id)sender {
    model.xmin = -2.0;
    model.xmax = 1.0;
    model.ymin = -1.5;
    model.ymax = 1.5;

    [self drawMandelbrotSet];
}

@end
