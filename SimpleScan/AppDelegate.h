//
//  AppDelegate.h
//  TextRecognitionDemo
//
//  Created by Admin on 13/06/17.
//  Copyright © 2017 tatattl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

