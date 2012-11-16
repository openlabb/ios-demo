//
//  AppDelegate.h
//  MSQLiteDemo
//
//  Created by Wang Liang on 12-2-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class StudentListViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UINavigationController *navController;
    StudentListViewController *studentListViewController;
}

@property (strong, nonatomic) UIWindow *window;

@end
