//
//  AppDelegate.m
//  BoxTest
//
//  Created by YJianMu on 2021/1/16.
//  Copyright © 2021 YJianMu. All rights reserved.
//

#import "AppDelegate.h"
#import <BoxTest-Swift.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //初始化BoxSDK,ClientId和clientSecret前往box官网注册应用
    //info.plist中的CFBundleURLSchemes boxsdk-clientId也要替换
    [[BoxTools sharedInstance] initBoxSDKWithClientId:@"svgdg6ekzvdhr2za0gqi9r78st54pkjh" clientSecret:@"KjjMQHPEvuqvCWEtFhrn5q9TE2WZXWUM"];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
