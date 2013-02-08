//
//  Student.h
//  Project Mango
//
//  Created by Jeffrey Barg on 8/30/12.
//  Copyright (c) 2012 Horace Mann School iOS Development Club. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Student : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * unitID;
@property (nonatomic, retain) NSString * idCardNumber;
@property (nonatomic, retain) NSSet *courses;
@end

@interface Student (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
