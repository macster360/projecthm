//
//  JBScanNewIDCardViewController.h
//  Project Mango
//
//  Created by Jeffrey Barg on 8/10/12.
//  Copyright (c) 2012 Horace Mann School iOS Development Club. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBScanNewIDCardViewController : UIViewController<ZBarReaderViewDelegate>

@property (nonatomic, retain) ZBarReaderView *readerView;

@end
