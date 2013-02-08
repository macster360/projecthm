//
//  Course.h
//  Project Mango
//
//  Created by Jeff Barg on 7/24/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Student, Teacher;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSNumber * courseNumber;
@property (nonatomic, retain) NSString * days;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * period;
@property (nonatomic, retain) NSString * room;
@property (nonatomic, retain) NSNumber * size;
@property (nonatomic, retain) NSString * terms;
@property (nonatomic, retain) NSNumber * sectionXNumber;
@property (nonatomic, retain) NSSet *students;
@property (nonatomic, retain) Teacher *teacher;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addStudentsObject:(Student *)value;
- (void)removeStudentsObject:(Student *)value;
- (void)addStudents:(NSSet *)values;
- (void)removeStudents:(NSSet *)values;

@end
