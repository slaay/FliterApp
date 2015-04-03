//
//  faAboutTeamSlaay.h
//  FliterApp
//
//  Created by Presley on 03/04/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface faAboutTeamSlaay : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imgPresley;
@property (strong, nonatomic) IBOutlet UIImageView *imgVidel;
@property (strong, nonatomic) IBOutlet UIImageView *imgSanket;
@property (strong, nonatomic) IBOutlet UIImageView *imgCashburn;
@property (strong, nonatomic) IBOutlet UIImageView *imgAlison;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


- (IBAction)btnSocialShare:(id)sender;

@end
