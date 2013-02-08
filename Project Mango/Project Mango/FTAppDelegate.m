//
//  FTAppDelegate.m
//  Project Mango
//
//  Created by Jeffrey Barg on 7/23/12.
//  Copyright (c) 2012 Fructose Tech, LLC. All rights reserved.
//

#import "FTAppDelegate.h"
#import "FTScheduleViewController.h"
#import "FTAuthenticationViewController.h"
#import "JBIDCardViewController.h"
#import "JBDirectoryViewController.h"

#import "Course.h"
#import "Teacher.h"
#import "Student.h"

#import "SBJson.h"
#import <Parse/Parse.h>

@implementation FTAppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize user;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setupAppearances];
    [self initializeData];
    [self setupUUID];
        
    [Parse setApplicationId:@"K8JTOK5DVHK7l2rOM1AGyRczdVtkgqkLtNT5SMqD"
                  clientKey:@"ZXHpAFQv36eIk0LW9rhEE04XrslL4YHIfPPXkjRT"];

        
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];

    PFFile *imgFile = [PFFile fileWithData:[NSData dataWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"done" withExtension:@"png"]]];
    [imgFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *err) {
        PFObject *obj = [PFObject objectWithClassName:@"ImageObj"];
        [obj setObject:imgFile forKey:@"ImageFile"];
        [obj saveInBackground];
    }];
    
//    PFUser *user = [PFUser user];
//    user.username = @"Jeff Barg";
//    user.password = @"hello";
//    user.email = @"jeffrey_barg@horacemann.org";
//        
//    // other fields can be set just like with PFObject
//    [user setObject:@"415-392-0202" forKey:@"phone"];
//
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {
//                // Hooray! Let them use the app now.
//            [PFPush subscribeToChannelInBackground:[user username]];
//
//        } else {
//            NSString *errorString = [[error userInfo] objectForKey:@"error"];
//            NSLog(@"%@", errorString);
//            // Show the errorString somewhere and let the user try again.
//        }
//    }];

    
    //Authenticate
    
    FTAuthenticationViewController *authViewController = [[FTAuthenticationViewController alloc] init];
    [authViewController setManagedObjectContext:self.managedObjectContext];
    
    //Setup initial Screen
    
    FTScheduleViewController *scheduleViewController = [[FTScheduleViewController alloc] initWithStyle:UITableViewStylePlain];
    [scheduleViewController setManagedObjectContext:self.managedObjectContext];
    
    UINavigationController *scheduleNavController = [[UINavigationController alloc] initWithRootViewController:scheduleViewController];
    
    
    JBIDCardViewController *idViewController = [[JBIDCardViewController alloc] init];
    UINavigationController *idNavController = [[UINavigationController alloc] initWithRootViewController:idViewController];
    
    JBDirectoryViewController *directoryViewController = [[JBDirectoryViewController alloc] initWithStyle:UITableViewStylePlain];
    [directoryViewController setManagedObjectContext:self.managedObjectContext];
    UINavigationController *directoryNavController = [[UINavigationController alloc] initWithRootViewController:directoryViewController];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    [tabBarController setViewControllers:[NSArray arrayWithObjects:scheduleNavController, idNavController, directoryNavController, nil]];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.rootViewController = tabBarController;
     
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    UINavigationController *authNavController = [[UINavigationController alloc] initWithRootViewController:authViewController];
        
    //[tabBarController presentViewController:authNavController animated:NO completion:^{}];
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Student"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"unitID == %i", 12040]];
    NSArray * ls = [self.managedObjectContext executeFetchRequest:request error:nil];
    self.user = ((Student *) [ls lastObject]);
    return YES;
}

#pragma mark - Push Notifications

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    // Tell Parse about the device token.
    [PFPush storeDeviceToken:newDeviceToken];
    // Subscribe to the global broadcast channel.
    [PFPush subscribeToChannelInBackground:@""];
}

- (void)application:(UIApplication *)application 
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (void) setupAppearances {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"rednavbar.png"] forBarMetrics:UIBarMetricsDefault];
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"activetab.png"]];
    
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"notesdone.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage imageNamed:@"notesdoneactive.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
}

- (void) initializeData {
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    
    NSError *err = nil;
    NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"studentschedules2012" ofType:@"json"] encoding:NSUTF8StringEncoding error:&err];
    if(err) {
        NSLog(@"%@", [err description]);
    }
    NSArray *objects = (NSArray *)[parser objectWithString:str];
    NSLog(@"%@", [objects objectAtIndex:0]);
    
    NSMutableDictionary *APIDToStudentDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *staffIDToTeachersDict = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *courseIDtoCourseDict = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *dict in objects) {
        
        Teacher *teacher = [staffIDToTeachersDict objectForKey:extractStringFromDict(@"Staff ID", dict)];
        if (teacher == nil) {
            teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.managedObjectContext];
            [teacher setName:convertFormalName(extractStringFromDict(@"Staff Name", dict))];
            [teacher setStaffID:extractStringFromDict(@"Staff ID", dict)];
            
            [staffIDToTeachersDict setObject:teacher forKey:extractStringFromDict(@"Staff ID", dict)];
        }
        
        Student *student = [APIDToStudentDict objectForKey:extractIntegerFromDict(@"APID", dict)];
        if (student == nil) {
            student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
            [student setName:convertFormalName(extractStringFromDict(@"Formal Name", dict))];
            [student setUnitID:extractIntegerFromDict(@"APID", dict)];
            [student setIdCardNumber:extractStringFromDict(@"Unique ID", dict)];
            
            [APIDToStudentDict setObject:student forKey:extractIntegerFromDict(@"APID", dict)];
        }
        
        Course *course = [courseIDtoCourseDict objectForKey:extractIntegerFromDict(@"SectionX Record Num", dict)];
        if (course == nil) {
            NSString *meetingTime = extractStringFromDict(@"Meeting Time", dict);
            NSString *decimals = @"1234567890";
            BOOL isLab = FALSE;
            
            NSString *coursePeriods = nil;
            for (int i = 0; i < [meetingTime length]; i ++) {
                NSString *cStr = [meetingTime substringWithRange:NSMakeRange(i, 1)];
                if ([decimals rangeOfString:cStr].location == NSNotFound) {
                    course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
                    coursePeriods = @"";
                    [course setDays:@"1234567890"];
                    [course setPeriod:cStr];
                    
                    if (!isLab) {
                        [course setName:extractStringFromDict(@"Course Name", dict)];
                        [courseIDtoCourseDict setObject:course forKey:extractIntegerFromDict(@"SectionX Record Num", dict)];
                        isLab = TRUE;
                    } else {
                        [course setName:[NSString stringWithFormat:@"%@%@",extractStringFromDict(@"Course Name", dict), @" Lab"]];
                    }
                    
                    [course setSize:extractIntegerFromDict(@"Current Size", dict)];
                    [course setRoom:extractStringFromDict(@"Room", dict)];
                    [course setCourseNumber:extractIntegerFromDict(@"Course Number", dict)];
                    [course setSectionXNumber:extractIntegerFromDict(@"SectionX Record Num", dict)];
                    
                    [teacher addCoursesObject:course];
                    [student addCoursesObject:course];
                } else {
                    coursePeriods = [NSString stringWithFormat:@"%@%@", coursePeriods, cStr];
                    [course setDays:coursePeriods];
                }
            }
            
        }
        

        
        
    }

//    for (NSDictionary *dict in objects) {
//        Course *course = [courseIDtoCourseDict objectForKey:extractIntegerFromDict(@"SectionX Record Num", dict)];
//        if ([extractStringFromDict(@"Meeting Time", dict) isEqualToString:@""]) continue;
//        
//        if (course == nil) {
//            course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:self.managedObjectContext];
//            
//            [course setName:extractStringFromDict(@"Course Name", dict)];
//            [course setSize:extractIntegerFromDict(@"Current Size", dict)];
//            [course setRoom:extractStringFromDict(@"Meeting Time", dict)];
//            [course setCourseNumber:extractIntegerFromDict(@"Course Number", dict)];
//            [course setPeriod:[extractStringFromDict(@"Meeting Time", dict) substringWithRange:NSMakeRange(0, 1)]];
//            
//            [courseIDtoCourseDict setObject:course forKey:extractIntegerFromDict(@"SectionX Record Num", dict)];
//        }
//        
//        Teacher *teacher = [staffIDToTeachersDict objectForKey:extractStringFromDict(@"Staff ID", dict)];
//        if (teacher == nil) {
//            teacher = [NSEntityDescription insertNewObjectForEntityForName:@"Teacher" inManagedObjectContext:self.managedObjectContext];
//            [teacher setName:convertFormalName(extractStringFromDict(@"Staff Name", dict))];
//            [teacher setStaffID:extractStringFromDict(@"Staff ID", dict)];
//            
//            [staffIDToTeachersDict setObject:teacher forKey:extractStringFromDict(@"Staff ID", dict)];
//        }
//        
//        [teacher addCoursesObject:course];
//        
//        Student *student = [APIDToStudentDict objectForKey:extractIntegerFromDict(@"APID", dict)];
//        if (student == nil) {
//            student = [NSEntityDescription insertNewObjectForEntityForName:@"Student" inManagedObjectContext:self.managedObjectContext];
//            [student setName:convertFormalName(extractStringFromDict(@"Formal Name", dict))];
//            [student setUnitID:extractIntegerFromDict(@"APID", dict)];
//            [student setIdCardNumber:extractStringFromDict(@"Unique ID", dict)];
//            
//            [APIDToStudentDict setObject:student forKey:extractIntegerFromDict(@"APID", dict)];
//        }
//        
//        [student addCoursesObject:course];
//        
//        
//    }

    
    
}

NSNumber * extractIntegerFromDict (NSString *key, NSDictionary * dict) {
    NSInteger val = [[dict valueForKey:key] integerValue];
    return [[NSNumber alloc] initWithInteger:val];
}

NSNumber * extractDoubleFromDict (NSString *key, NSDictionary * dict) {
    double val = [[dict valueForKey:key] doubleValue];
    return [[NSNumber alloc] initWithDouble:val];
}

NSNumber * extractBooleanFromDict (NSString *key, NSDictionary * dict) {
    BOOL val = [[dict valueForKey:key] boolValue];
    return [[NSNumber alloc] initWithBool:val];
}


NSString * extractStringFromDict(NSString *key, NSDictionary * dict) {
    NSObject *obj = (NSObject *)[dict objectForKey:key];
    
    if (obj == [NSNull null])
        return @"";
    
    return [((NSString *)obj) copy];
}

NSString *convertFormalName(NSString * formalName) {
//    NSInteger index = [formalName rangeOfString:@";"].location;
//    
//    NSString *lastName = [formalName substringToIndex:index];
//    NSString *firstName = [formalName substringFromIndex:index + 2];
//    
//    return [NSString stringWithFormat:@"%@ %@", firstName, lastName];
    
    return formalName;
}


- (void) setupUUID {
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:kUUIDKeyDefaults] == nil) {
        CFUUIDRef theUUID = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, theUUID);
        CFRelease(theUUID);
        NSString * newUUID =  (__bridge_transfer NSString *)string;
        
        [defaults setValue:newUUID forKey:kUUIDKeyDefaults];
        
        [defaults synchronize];
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Project_Mango" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Project_Mango.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
