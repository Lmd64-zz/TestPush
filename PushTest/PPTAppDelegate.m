//
//  PPTAppDelegate.m
//  PushTest
//
//  Created by Liam Dunne on 22/10/2013.
//  Copyright (c) 2013 Liam Dunne. All rights reserved.
//

/*
 
 Parse PushTest App Keys
 
 Application ID	Qrncjg2674URO3swTdSjYgXAQwCDpxasU0WJcfLy
 Client Key		c8mcP5m0ZhF61A7FDF9eTxLS8xMZdcR6i93v0Bkb
 Javascript Key	yMtY1sj1FuklRIm8DhXOb6CTgVrQaN9LCNOBsOoa
 .NET Key		RMDSkWFqCtUD13dHCOfCsXrRmuQEEkj3595KXxYZ
 REST API Key	nGoNj8kk0s1sSXyqHoraYdlmeV7h6CKXG3wPiZZc
 Master Key		JQ57DCvvQuxZZoBo6ZWY8ZRmVK6veURI79Gnpi2z
 
 */

#import "PPTAppDelegate.h"
#import <Parse/Parse.h>

@implementation PPTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    // Override point for customization after application launch.
    
    [Parse setApplicationId:@"Qrncjg2674URO3swTdSjYgXAQwCDpxasU0WJcfLy" clientKey:@"c8mcP5m0ZhF61A7FDF9eTxLS8xMZdcR6i93v0Bkb"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    NSString *logString = LogString(@"");
    [self FLog:logString];
    
    if (!launchOptions) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    } else {
        NSDictionary *dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary) {
            NSString *logString = LogString(@"%@",dictionary);
            [self FLog:logString];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSString *logString = LogString(@"");
    [self FLog:logString];
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSString *logString = LogString(@"");
    [self FLog:logString];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    NSString *logString = LogString(@"");
    [self FLog:logString];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSString *logString = LogString(@"");
    [self FLog:logString];
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    NSString *logString = LogString(@"");
    [self FLog:logString];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    // Store the deviceToken in the current Installation and save it to Parse.
    NSString *logString = LogString(@"deviceToken:%@",deviceToken);
    [self FLog:logString];
    
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSString *logString = LogString(@"%@",error);
    [self FLog:logString];
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
//    NSString *logString = LogString(@"");
//    [self FLog:logString];
//}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSString *logString = LogString(@"");
    [self FLog:logString];
}

/*! This delegate method offers an opportunity for applications with the "remote-notification" background mode to fetch appropriate new data in response to an incoming remote notification. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
 
 This method will be invoked even if the application was launched or resumed because of the remote notification. The respective delegate methods will be invoked first. Note that this behavior is in contrast to application:didReceiveRemoteNotification:, which is not called in those cases, and which will not be invoked if this method is implemented. !*/
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    NSString *logString = LogString(@"userInfo: %@",userInfo);
    [self FLog:logString];
    if ([[userInfo valueForKeyPath:@"aps.content-available"] isEqual:@1] &&
        [userInfo valueForKeyPath:@"aps.badge"] &&
        [[[userInfo valueForKeyPath:@"aps"] allKeys] count]==2) {// display as local notification
        [self refreshData:nil];
    }
    completionHandler(UIBackgroundFetchResultNewData);
}

/// Applications with the "fetch" background mode may be given opportunities to fetch updated content in the background or when it is convenient for the system. This method will be called in these situations. You should call the fetchCompletionHandler as soon as you're finished performing that operation, so the system can accurately estimate its power and data cost.
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    NSString *logString = LogString(@"");
    [self FLog:logString];
    [self refreshData:nil];
    completionHandler(UIBackgroundFetchResultNewData);
}

// Applications using an NSURLSession with a background configuration may be launched or resumed in the background in order to handle the
// completion of tasks in that session, or to handle authentication. This method will be called with the identifier of the session needing
// attention. Once a session has been created from a configuration object with that identifier, the session's delegate will begin receiving
// callbacks. If such a session has already been created (if the app is being resumed, for instance), then the delegate will start receiving
// callbacks without any action by the application. You should call the completionHandler as soon as you're finished handling the callbacks.
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler{
    NSString *logString = LogString(@"identifier: %@",identifier);
    [self FLog:logString];
}

- (void)refreshData:(id)sender{
    NSString *logString = LogString(@"");
    [self FLog:logString];

//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    notification.alertBody =  @"data refreshed!";
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];

}

- (void)FLog:(NSString*)content{
    
    Log(@"%@",content);
    content = [content stringByAppendingString:@"\n"];
    
    //Get the file path
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [documentsDirectory stringByAppendingPathComponent:@"PushTest.log"];
    
    //create file if it doesn't exist
    if(![[NSFileManager defaultManager] fileExistsAtPath:fileName])
        [[NSFileManager defaultManager] createFileAtPath:fileName contents:nil attributes:nil];
    
    //append text to file (you'll probably want to add a newline every write)
    NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:fileName];
    [file seekToEndOfFile];
    [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    [file closeFile];
    
}


@end
