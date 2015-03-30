//
//  faAboutApp.m
//  FliterApp
//
//  Created by Presley on 30/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//

#import "faAboutApp.h"
#import "SWRevealViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface faAboutApp ()

@end

@implementation faAboutApp

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"About App";
    

    [self setSidebarMenu];
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];

    
self.viewParentView.backgroundColor = [UIColor colorWithRed:255/255.0 green:211/255.0 blue:224/255.0 alpha:1.0];
    
    self.childView.layer.cornerRadius = 5;
    self.childView.layer.masksToBounds = YES;
}

-(void)setSidebarMenu{
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


@end
