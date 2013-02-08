//
//  JBIDCardViewController.m
//  Project Mango
//
//  Created by Jeffrey Barg on 7/26/12.
//  Copyright (c) 2012 Horace Mann School iOS Development Club. All rights reserved.
//

#import "JBIDCardViewController.h"
#import "JBIDCardDetailViewController.h"
#import "JBScanNewIDCardViewController.h"


@interface JBIDCardViewController ()

@end

@implementation JBIDCardViewController


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
    
    self.title = @"ID Card";
    
    UIButton * viewCardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2.0)];
    [viewCardButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
    
    
    [viewCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [viewCardButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [viewCardButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    
    [viewCardButton.titleLabel setFont:[UIFont boldSystemFontOfSize:22.0]];    
    [viewCardButton setTitleEdgeInsets:UIEdgeInsetsMake(100.0, 0.0, 0.0, 0.0)];
    
    [viewCardButton setImage:[UIImage imageNamed:@"use.png"] forState:UIControlStateNormal];
    [viewCardButton setImage:[UIImage imageNamed:@"useselect.png"] forState:UIControlStateHighlighted];
    
    [self.view addSubview:viewCardButton];
    [viewCardButton addTarget:self action:@selector(viewCard) forControlEvents:UIControlEventTouchUpInside];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIDCardBarcodeDefault] != nil) {
        
        UIButton * scanNewCardButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height/2.0, self.view.frame.size.width, self.view.frame.size.height/2.0)];
        [scanNewCardButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin];


        [scanNewCardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [scanNewCardButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scanNewCardButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];

        [scanNewCardButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
        [scanNewCardButton setTitleEdgeInsets:UIEdgeInsetsMake(100.0, 0.0, 0.0, 0.0)];
        
        [scanNewCardButton setImage:[UIImage imageNamed:@"scan.png"] forState:UIControlStateNormal];
        [scanNewCardButton setImage:[UIImage imageNamed:@"scanselect.png"] forState:UIControlStateHighlighted];
        
        [self.view addSubview:scanNewCardButton];
        [scanNewCardButton addTarget:self action:@selector(scanCard) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || INTERFACE_IS_PAD;
}

#pragma mark - Buttons

- (void) scanCard {
    JBScanNewIDCardViewController *scanViewController = [[JBScanNewIDCardViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:scanViewController];
    [self presentViewController:navController animated:YES completion:^{}];
}

- (void) viewCard {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kIDCardBarcodeDefault] == nil) { [self scanCard]; return; }
    
    JBIDCardDetailViewController *detailViewController = [[JBIDCardDetailViewController alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *barcodeData = [defaults stringForKey:kIDCardBarcodeDefault];
    [detailViewController setBarcodeData:barcodeData];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [self presentViewController:detailViewController animated:YES completion:^{}];
}

@end
