//
//  MMPAppDelegate.m
//  MMProgress
//
//  Created by Alex Larson on 03/07/2016.
//  Copyright (c) 2016 Alex Larson. All rights reserved.
//

#import "MMPAppDelegate.h"
#import <MMProgress/MMProgress.h>
#import <MMProgress/MMProgressConfiguration.h>
#import <SpinKit/RTSpinKitView.h>

@implementation MMPAppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions
{
    // Override point for customization after application launch.

    [self setupKVNConfiguration];
    return YES;
}

- (void) setupKVNConfiguration
{
    MMProgressConfiguration *configuration = [[MMProgressConfiguration alloc] init];
    RTSpinKitView *spinner = [[RTSpinKitView alloc] initWithStyle:RTSpinKitViewStyleWave];

    spinner.color = [UIColor whiteColor];

    configuration.loadingIndicator = spinner;
    configuration.fullScreen = NO;
    configuration.backgroundType = MMProgressBackgroundTypeBlurred;
    configuration.backgroundColor = [UIColor colorWithRed:255.0 / 255.0 green:100.0 / 255.0 blue:20.0 / 255.0 alpha:0.5];
    configuration.statusColor = [UIColor whiteColor];
    configuration.presentAnimated = YES;

    [MMProgress setConfiguration:configuration];
}

- (void) applicationWillResignActive:(UIApplication *) application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) applicationDidEnterBackground:(UIApplication *) application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void) applicationWillEnterForeground:(UIApplication *) application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void) applicationDidBecomeActive:(UIApplication *) application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void) applicationWillTerminate:(UIApplication *) application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
