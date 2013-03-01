//
//  ZBarViewController.h
//  Project Mango Gamma Release
//
//  Created by Sahil Gupta on 2/28/13.
//  Copyright (c) 2013 Sahil Gupta. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBarViewController : NSObject

{
    UIImageView *resultImage;
    UITextView *resultText;
}
@property (nonatomic, retain) IBOutlet UIImageView *resultImage;
@property (nonatomic, retain) IBOutlet UITextView *resultText;
- (IBAction) scanButtonTapped;

@end


