//
//  ViewController.m
//  Mandelbrot
//
//  Created by Abhijit Joshi on 5/27/14.
//  Copyright (c) 2014 Misha software solutions. All rights reserved.
//

#import "ViewController.h"
#import "CrossHair.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UIView *blackBox;
@property (strong, nonatomic) CrossHair* cross;
@end

@implementation ViewController
@synthesize blackBox;
@synthesize cross;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // draw the cross hairs
    float width = blackBox.frame.size.width;
    float height = blackBox.frame.size.height;
    CGRect myRect = CGRectMake(0, 0, width, height);
    cross = [[CrossHair alloc] initWithFrame:myRect];
    [blackBox addSubview:cross];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
