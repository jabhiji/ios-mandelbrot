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
@property (weak, nonatomic) IBOutlet DrawMandelbrot *blackBox;
@property float width, height;
@property (strong, nonatomic) CrossHair* cross;
@property (strong, nonatomic) Model* model;
@property (strong, nonatomic) DrawMandelbrot* drawSet;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property NSMutableArray* x_min;
@property NSMutableArray* x_max;
@property NSMutableArray* y_min;
@property NSMutableArray* y_max;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *button100;
@property (weak, nonatomic) IBOutlet UIButton *button200;
@property (weak, nonatomic) IBOutlet UIButton *button400;
@property (weak, nonatomic) IBOutlet UIButton *button800;

- (IBAction)backToSquareOne:(id)sender;
@end

@implementation ViewController
@synthesize blackBox;
@synthesize width, height;
@synthesize cross;
@synthesize model;
@synthesize drawSet;
@synthesize x_min, x_max, y_min, y_max;
@synthesize backButton;

- (void)viewDidAppear:(BOOL)animated
{
    [_activityIndicator setHidesWhenStopped:YES];

    // black box view dimensions
    width = blackBox.frame.size.width;
    height = blackBox.frame.size.height;

    // initialize the model
    model = [[Model alloc] init];

    // get window size
    CGRect viewRect = CGRectMake(0, 0, width , height);

    // initialize the Mandelbrot view
    drawSet = [[DrawMandelbrot alloc] initWithFrame:viewRect];
    drawSet.nx = model.nx;
    drawSet.ny = model.ny;
    drawSet.MAX_ITER = model.MAX_ITER;
    [drawSet initData];

    // initialize cross view
    cross = [[CrossHair alloc] initWithFrame:viewRect];
    [cross setBackgroundColor:[UIColor clearColor]];

    // add subviews
    [blackBox addSubview:drawSet];
    [blackBox addSubview:cross];

    // draw the Mandelbrot set
    [self drawMandelbrotSet];

    x_min = [[NSMutableArray alloc] init];
    x_max = [[NSMutableArray alloc] init];
    y_min = [[NSMutableArray alloc] init];
    y_max = [[NSMutableArray alloc] init];
    [self storeCorners];
    [backButton setHidden:YES];
}

-(void)storeCorners
{
    [x_min addObject:[NSNumber numberWithDouble:model.xmin]];
    [x_max addObject:[NSNumber numberWithDouble:model.xmax]];
    [y_min addObject:[NSNumber numberWithDouble:model.ymin]];
    [y_max addObject:[NSNumber numberWithDouble:model.ymax]];
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
        
        float dx = width / 2;
        float dy = height / 2;
        
        // find out array location where finger touches the screen
        int xIndex = x/dx;
        int yIndex = y/dy;
        int N = (xIndex + 2*yIndex) + 1;
        
        NSLog(@"You selected block %d", N);
        
        switch (N) {
            case 1:
                model.xmax = model.xmin + (model.xmax - model.xmin)/2;
                model.ymin = model.ymin + (model.ymax - model.ymin)/2;
                break;
            case 2:
                model.xmin = model.xmin + (model.xmax - model.xmin)/2;
                model.ymin = model.ymin + (model.ymax - model.ymin)/2;
                break;
            case 3:
                model.xmax = model.xmin + (model.xmax - model.xmin)/2;
                model.ymax = model.ymin + (model.ymax - model.ymin)/2;
                break;
            case 4:
                model.xmin = model.xmin + (model.xmax - model.xmin)/2;
                model.ymax = model.ymin + (model.ymax - model.ymin)/2;
                break;
            default:
                break;
        }
        [self storeCorners];
        [self drawMandelbrotSet];
    }
}

- (void) drawMandelbrotSet
{
    [self navigationButtonStatus];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [_activityIndicator startAnimating];
    dispatch_queue_t queue = dispatch_queue_create("com.mishasoftwaresolutions.mandelbrot", NULL);
    dispatch_async(queue, ^{
        [model updateMandelbrotData];
        drawSet.data = model.iters;
        dispatch_async(dispatch_get_main_queue(),^{
            [_activityIndicator stopAnimating];
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            [drawSet setNeedsDisplay];
        });
    });
}

- (void)navigationButtonStatus
{
    if ([x_min count] > 1) {
        [backButton setHidden:NO];
    } else {
        [backButton setHidden:YES];
    }
}

- (IBAction)backToSquareOne:(id)sender {
    model.xmin = -2.0;
    model.xmax = 1.0;
    model.ymin = -1.5;
    model.ymax = 1.5;
    [x_min removeAllObjects];
    [x_max removeAllObjects];
    [y_min removeAllObjects];
    [y_max removeAllObjects];
    [self storeCorners];
    [self drawMandelbrotSet];
}

- (IBAction)resolution100:(id)sender {
    [_button100 setBackgroundImage:[UIImage imageNamed:@"Button100_ON"] forState: UIControlStateNormal];
    [_button200 setBackgroundImage:[UIImage imageNamed:@"Button200_OFF"] forState: UIControlStateNormal];
    [_button400 setBackgroundImage:[UIImage imageNamed:@"Button400_OFF"] forState: UIControlStateNormal];
    [_button800 setBackgroundImage:[UIImage imageNamed:@"Button800_OFF"] forState: UIControlStateNormal];
    model.nx = 100;
    model.ny = 100;
    [self redraw];
}

- (IBAction)resolution200:(id)sender {
    [_button100 setBackgroundImage:[UIImage imageNamed:@"Button100_OFF"] forState: UIControlStateNormal];
    [_button200 setBackgroundImage:[UIImage imageNamed:@"Button200_ON"] forState: UIControlStateNormal];
    [_button400 setBackgroundImage:[UIImage imageNamed:@"Button400_OFF"] forState: UIControlStateNormal];
    [_button800 setBackgroundImage:[UIImage imageNamed:@"Button800_OFF"] forState: UIControlStateNormal];
    model.nx = 200;
    model.ny = 200;
    [self redraw];
}

- (IBAction)resolution400:(id)sender {
    [_button100 setBackgroundImage:[UIImage imageNamed:@"Button100_OFF"] forState: UIControlStateNormal];
    [_button200 setBackgroundImage:[UIImage imageNamed:@"Button200_OFF"] forState: UIControlStateNormal];
    [_button400 setBackgroundImage:[UIImage imageNamed:@"Button400_ON"] forState: UIControlStateNormal];
    [_button800 setBackgroundImage:[UIImage imageNamed:@"Button800_OFF"] forState: UIControlStateNormal];
    model.nx = 400;
    model.ny = 400;
    [self redraw];
}

- (IBAction)resolution800:(id)sender {
    [_button100 setBackgroundImage:[UIImage imageNamed:@"Button100_OFF"] forState: UIControlStateNormal];
    [_button200 setBackgroundImage:[UIImage imageNamed:@"Button200_OFF"] forState: UIControlStateNormal];
    [_button400 setBackgroundImage:[UIImage imageNamed:@"Button400_OFF"] forState: UIControlStateNormal];
    [_button800 setBackgroundImage:[UIImage imageNamed:@"Button800_ON"] forState: UIControlStateNormal];
    model.nx = 800;
    model.ny = 800;
    [self redraw];
}

- (void) redraw {
    [model initializeItersArraySizeUsing_nx:model.nx and_ny:model.ny];
    drawSet.nx = model.nx;
    drawSet.ny = model.ny;
    [drawSet initData];
    [self drawMandelbrotSet];
}

- (IBAction)goBack:(id)sender {
    x_min.removeLastObject;
    x_max.removeLastObject;
    y_min.removeLastObject;
    y_max.removeLastObject;
    model.xmin = [x_min.lastObject doubleValue];
    model.xmax = [x_max.lastObject doubleValue];
    model.ymin = [y_min.lastObject doubleValue];
    model.ymax = [y_max.lastObject doubleValue];
    [self drawMandelbrotSet];
}

@end
