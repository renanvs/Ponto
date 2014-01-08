//
//  AppDelegate.m
//  Ponto
//
//  Created by renan veloso silva on 20/12/13.
//  Copyright (c) 2013 renan veloso silva. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "PontoManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [PontoManager sharedinstance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    MainViewController *mvc = [[MainViewController alloc] init];
    self.window.rootViewController = mvc;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
