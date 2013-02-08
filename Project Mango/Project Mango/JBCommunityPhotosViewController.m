//
//  JBCommunityPhotosViewController.m
//  Project Mango
//
//  Created by Jeffrey Barg on 8/23/12.
//  Copyright (c) 2012 Horace Mann School iOS Development Club. All rights reserved.
//

#import "JBCommunityPhotosViewController.h"

@interface JBCommunityPhotosViewController ()

@end

@implementation JBCommunityPhotosViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
