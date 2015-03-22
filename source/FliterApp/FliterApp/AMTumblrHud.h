//
// Created by Mustafin Askar on 22/05/2014.
// Copyright (c) 2014 Asich. All rights reserved.
//

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net


#import <Foundation/Foundation.h>


@interface AMTumblrHud : UIView

@property (nonatomic, strong) UIColor *hudColor;

-(void)showAnimated:(BOOL)animated;
-(void)hide;

@end