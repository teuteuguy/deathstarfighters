//
//  AppDelegate.m
//  deathstarfighers
//
//  Created by Timothee Cruse on 08/02/14.
//  Copyright (c) 2014 TC. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate



- (void)customizeAppearance
{
//    // Create resizable images
//    UIImage *gradientImage44 = [[UIImage imageNamed:@"surf_gradient_textured_44"]
//                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    UIImage *gradientImage32 = [[UIImage imageNamed:@"surf_gradient_textured_32"]
//                                resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    
//    // Set the background image for *all* UINavigationBars
//    [[UINavigationBar appearance] setBackgroundImage:gradientImage44
//                                       forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBackgroundImage:gradientImage32
//                                       forBarMetrics:UIBarMetricsLandscapePhone];
    
    UIColor * backgroundcolor = [UIColor colorWithRed:119/255.0 green:153/255.0 blue:203/255.0 alpha:1.0];
    [[UINavigationBar appearance] setBackgroundColor:backgroundcolor];
    //[[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //[[UINavigationBar appearance] setTintColor:backgroundcolor];
    //[[UINavigationBar appearance] setTranslucent:false];
    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:
            [NSDictionary dictionaryWithObjectsAndKeys:
             [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
             NSForegroundColorAttributeName,
             [UIFont fontWithName:@"TrebuchetMS" size:0.0],
             NSFontAttributeName,
             nil]];
//    [[UINavigationBar appearance] setTitleTextAttributes:
//     [NSDictionary dictionaryWithObjectsAndKeys:
//      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
//      UITextAttributeTextColor,
//      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
//      UITextAttributeTextShadowColor,
//      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
//      UITextAttributeTextShadowOffset,
//      [UIFont fontWithName:@"Arial-Bold" size:0.0],
//      UITextAttributeFont,
//      nil]];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self customizeAppearance];
    // Override point for customization after application launch.
    return YES;
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
