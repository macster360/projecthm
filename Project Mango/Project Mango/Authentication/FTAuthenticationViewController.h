//
//  FTAuthenticationViewController.h
//  Project Mango
//
//  Created by Jeff Barg on 7/24/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FTAuthenticationViewController : UIViewController <ZBarReaderViewDelegate>

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) ZBarReaderView *readerView;

@end
