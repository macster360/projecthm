//
//  JBIDCardDetailViewController.m
//  Project Mango
//
//  Created by Jeffrey Barg on 8/10/12.
//  Copyright (c) 2012 Horace Mann School iOS Development Club. All rights reserved.
//

#import "JBIDCardDetailViewController.h"

#import "NKDCode39Barcode.h"
#import "UIImage-NKDBarcode.h"

@interface JBIDCardDetailViewController ()

@property (nonatomic, strong) UIImageView *barcodeImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation JBIDCardDetailViewController

@synthesize barcodeData;
@synthesize barcodeImageView;
@synthesize nameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBackgroundColor;
    
	// Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"card.png"]];
    [imageView setFrame:self.view.bounds];
    [imageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:imageView];
    
    NKDCode39Barcode *barcode = [[NKDCode39Barcode alloc] initWithContent:self.barcodeData printsCaption:YES];
    
    UIImage *barcodeImage = [UIImage imageFromBarcode:barcode];

    NSLog(@"%f, %f", barcodeImage.size.width, barcodeImage.size.height);
    
    barcodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, barcodeImage.size.width, barcodeImage.size.height)];
    [barcodeImageView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin];
    [barcodeImageView setImage:barcodeImage];
    
    [self.view addSubview:barcodeImageView];
    
    
    UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 90.0, 35.0, 60.0, 30.0)];
    
    [doneButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin];
    
    [doneButton setBackgroundImage:[[UIImage imageNamed:@"done.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal];
    [doneButton setBackgroundImage:[[UIImage imageNamed:@"doneselect.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted];  
    [doneButton setTitleColor:[UIColor colorWithHue:1.000 saturation:0.090 brightness:0.698 alpha:1.000] forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [doneButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    
    [doneButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:doneButton];

    nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200.0, 60.0)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
    [nameLabel setTextAlignment:UITextAlignmentCenter];

    [nameLabel setText:@"Jeffrey Barg"];
    [self.view addSubview:nameLabel];
}


- (void) viewWillLayoutSubviews {
    [nameLabel setCenter:CGPointMake(240.0, 135.0)];
    [barcodeImageView setCenter:CGPointMake(240.0, 235.0)];    
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - Buttons 

- (void) cancel {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
