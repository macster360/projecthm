//
//  FTAuthenticationViewController.m
//  Project Mango
//
//  Created by Jeff Barg on 7/24/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTAuthenticationViewController.h"
#import "ELTextFieldTableViewCell.h"

#import "FTAppDelegate.h"

#import "Student.h"

@interface FTAuthenticationViewController () {
}

@end

@implementation FTAuthenticationViewController

@synthesize managedObjectContext;
@synthesize readerView;


- (void)viewDidLoad
{
    [super viewDidLoad];    
    
    ZBarImageScanner *scanner = [[ZBarImageScanner alloc] init];
    readerView = [[ZBarReaderView alloc] initWithImageScanner:scanner];
    
    readerView.readerDelegate = self;
    
    [self.view addSubview:readerView];
    self.title = @"Scan Your Horace Mann ID";
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [readerView start];
}
- (void) viewWillDisappear:(BOOL)animated {
    
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
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"idCardNumber == %@", [eancode substringFromIndex:6]]];

        NSArray * objs = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
        if (objs != nil && [objs count] != 0) {
            Student *stu = [objs lastObject];
            APPLICATION_DELEGATE.user = stu;

            [self dismissViewControllerAnimated:YES completion:^{}];

        }
        
        break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
   

@end
