//
//  AppDelegate.m
//  MSRocketGiftAnimation
//
//  Created by J on 2016/2/11.
//  Copyright © 2016年 J. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = ViewController.new;
    [self.window makeKeyAndVisible];
    return YES;
}
    
@end
