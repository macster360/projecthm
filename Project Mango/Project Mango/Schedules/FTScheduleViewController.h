//
//  FTScheduleViewController.h
//  Project Mango
//
//  Created by Jeffrey Barg on 7/24/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Student;

@interface FTScheduleViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) Student *student;

@end
