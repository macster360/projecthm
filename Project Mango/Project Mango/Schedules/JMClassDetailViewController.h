//
//  JMClassDetailViewController.h
//  Project Mango
//
//  Created by Jay Moon on 8/10/12.
//  Copyright (c) 2012 Horace Mann School iOS Development Club. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface JMClassDetailViewController : UITableViewController

@property (nonatomic, strong) Course *course;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end
