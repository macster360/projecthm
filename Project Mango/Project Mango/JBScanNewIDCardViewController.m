//
//  JBScanNewIDCardViewController.m
//  Project Mango
//
//  Created by Jeffrey Barg on 8/10/12.
//  Copyright (c) 2012 Horace Mann School iOS Development Club. All rights reserved.
//

#import "JBScanNewIDCardViewController.h"

# import "ZBarSDK.h"

@interface JBScanNewIDCardViewController ()

@end

@implementation JBScanNewIDCardViewController

@synthesize readerView;

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
    self.view.backgroundColor = kViewBackgroundColor;
    
    ZBarImageScanner *scanner = [[ZBarImageScanner alloc] init];
    readerView = [[ZBarReaderView alloc] initWithImageScanner:scanner];
    
    readerView.readerDelegate = self;
    
    [readerView setFrame:self.view.bounds];//CGRectMake(0, 0, self.view.frame.size.width, 300)];
    
    [self.view addSubview:readerView];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    [self.navigationItem setLeftBarButtonItem:cancelItem];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [readerView start];
}
- (void) viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    
    [super viewWillDisappear:YES];
    [readerView stop]; 
}

- (void) readerView: (ZBarReaderView*) view
     didReadSymbols: (ZBarSymbolSet*) syms
          fromImage: (UIImage*) img
{
    // do something useful with results
    for(ZBarSymbol *sym in syms) {
        
        NSString * eancode = sym.data;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [defaults setValue:eancode forKey:kIDCardBarcodeDefault];
        [defaults synchronize];
    
        
        [self cancel];
        
        break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait) || INTERFACE_IS_PAD;
}

#pragma mark - Buttons 

- (void) cancel {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
