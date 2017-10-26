//
//  AppDelegate.h
//  QQ
//
//  Created by JACK-GU on 2017/10/26.
//  Copyright © 2017年 JACK-GU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

