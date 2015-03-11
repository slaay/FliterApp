//
//  faAppDelegate.h
//  FliterApp
//
//  Created by Presley on 07/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@class HFViewController;

@interface faAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HFViewController *rootViewController;

@end
