//
//  faFbPhotos.m
//  FliterApp
//
//  Created by Presley on 13/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//

#import "faFbPhotos.h"
#import "SWRevealViewController.h"
#import "faAppDelegate.h"

@interface faFbPhotos ()

@end

@implementation faFbPhotos

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
    // Do any additional setup after loading the view.
    
    
    
    self.title = @"FB Photos";
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnGetAlbumList:(id)sender {
    
    FBRequest *request = [FBRequest requestForGraphPath:@"me/albums"];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary <FBGraphUser> *my, NSError *error) {
        if ([my[@"data"]count]) {
            for (FBGraphObject *obj in my[@"data"]) {
                FBRequest *r = [FBRequest requestForGraphPath:[NSString stringWithFormat:@"/%@/photos", obj[@"id"]]];
                [r startWithCompletionHandler:^(FBRequestConnection *c, NSDictionary <FBGraphUser> *m, NSError *err) {
                    //here you will get pictures for each album
                    
                    NSLog(@"%@", m);
                    
                    
                    
                }];
            }
        }
        
    }];
    
}
@end
