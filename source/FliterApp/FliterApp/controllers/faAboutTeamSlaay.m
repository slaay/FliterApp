//
//  faAboutTeamSlaay.m
//  FliterApp
//
//  Created by Presley on 03/04/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//

#import "faAboutTeamSlaay.h"
#import "SWRevealViewController.h"
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import "faSharedGlobals.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface faAboutTeamSlaay ()

@end

@implementation faAboutTeamSlaay


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
    
    self.title = @"Team Slaay";
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self setUpTeamMembers];
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

-(UIColor*)getUIColorFromRBG{
    
    UIColor *colorFromRBG;
    colorFromRBG = UIColorFromRGB(0x5BCAFF);
    return colorFromRBG;
}



-(void)setUpTeamMembers{

   
    // Load image
   
    self.imgSanket.layer.cornerRadius = self.imgSanket.frame.size.width / 2;
    self.imgSanket.clipsToBounds = YES;
    self.imgSanket.layer.borderWidth = 2.0f;
    self.imgSanket.layer.borderColor = [self getUIColorFromRBG].CGColor;
    
    
    self.imgCashburn.layer.cornerRadius = self.imgCashburn.frame.size.width / 2;
    self.imgCashburn.clipsToBounds = YES;
    self.imgCashburn.layer.borderWidth = 2.0f;
    self.imgCashburn.layer.borderColor = [self getUIColorFromRBG].CGColor;
    
    self.imgAlison.layer.cornerRadius = self.imgAlison.frame.size.width / 2;
    self.imgAlison.clipsToBounds = YES;
    self.imgAlison.layer.borderWidth = 2.0f;
    self.imgAlison.layer.borderColor = [self getUIColorFromRBG].CGColor;
    
    
    self.imgPresley.layer.cornerRadius = self.imgPresley.frame.size.width / 2;
    self.imgPresley.clipsToBounds = YES;
    self.imgPresley.layer.borderWidth = 2.0f;
    self.imgPresley.layer.borderColor = [self getUIColorFromRBG].CGColor;
    
    
    self.imgVidel.layer.cornerRadius = self.imgVidel.frame.size.width / 2;
    self.imgVidel.clipsToBounds = YES;
    self.imgVidel.layer.borderWidth = 2.0f;
    self.imgVidel.layer.borderColor = [self getUIColorFromRBG].CGColor;
}



- (IBAction)btnSocialShare:(id)sender {
    
    if ([sender tag] == 1){
        NSURL *facebookURL = [NSURL URLWithString:LINK_SlaayFB_Profile];
        if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
            [[UIApplication sharedApplication] openURL:facebookURL];
        } else {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LINK_Faceboook]];
        }
    } //Facebook share
    else if ([sender tag] == 2) {
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
        {
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:SLServiceTypeTwitter];
            if (tweetSheet){
                [tweetSheet addImage:[UIImage imageNamed:@"KeepThinkLogo.png"]];
                [tweetSheet addURL:[NSURL URLWithString:LINK_SLaaySourcecoders]];
                [tweetSheet setInitialText:SHARE_text];
                
                [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
                    if (result == SLComposeViewControllerResultDone) {
                        NSLog(@"Posted");
                    } else if (result == SLComposeViewControllerResultCancelled) {
                        NSLog(@"Post Cancelled");
                    } else {
                        NSLog(@"Post Failed");
                    }
                }];
                
                [self presentViewController:tweetSheet animated:YES completion:nil];
                
            }
            
            
        } else {
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
            { SLComposeViewController *tweetSheet = [SLComposeViewController
                                                     composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:SHARE_text];
                
                [self presentViewController:tweetSheet animated:YES completion:nil];
                
                
                //inform the user that no account is configured with alarm view.
            }
            
        }
        
    } //Twitter share
    else if ([sender tag] == 3) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LINK_Github_Profile]];
        
    } //Github

}
@end
