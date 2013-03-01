//
//  ZBarViewController.m
//  Project Mango Gamma Release
//
//  Created by Sahil Gupta on 2/28/13.
//  Copyright (c) 2013 Sahil Gupta. All rights reserved.
//

#import "ZBarViewController.h"

@implementation ZBarViewController
@synthesize resultImage, resultText;

- (IBAction) scanButtonTapped
{
    NSLog(@"TBD: scan barcode here...");
}

- (void) dealloc
{
    self.resultImage = nil;
    self.resultText = nil;
    [super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return(YES);
}
@end
