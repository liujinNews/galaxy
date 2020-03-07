//
//  AppDelegate.h
//  galaxy
//
//  Created by 赵碚 on 15/7/22.
//  Copyright (c) 2015年 赵碚. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : NSObject

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
+(AppDelegate *)appDelegate;
- (void)setupTabViewController;

-(void)pushView:(NSDictionary *)userInfo;
- (void)PushTo3d;

-(void)pushControllerByMess:(NSDictionary *)dict;
- (UINavigationController *)navigationViewController;
- (UIViewController *)topViewController;

-(void)registerInfo;

-(void)AppTokenInvalid;

@end



