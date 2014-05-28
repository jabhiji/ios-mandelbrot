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
@property (strong, nonatomic) CrossHair* cross;
@end

@implementation ViewController

@synthesize cross;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // initialize Ball object
    CGRect myRect = CGRectMake(0, 0, self.view.frame.size.width , self.view.frame.size.height);
    cross = [[CrossHair alloc] initWithFrame:myRect];
    [cross setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:cross];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
