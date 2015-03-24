//
//  faAlbumPhotoListViewController.h
//  FliterApp
//
//  Created by Presley on 23/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface faAlbumPhotoListViewController : UIViewController
@property (nonatomic, strong) UIImage *imgLargAlbumcover;
@property (strong, nonatomic) IBOutlet UIImageView *imgAlbumCover;
-(void)configureDetails:(UIImage *)paramImage :(NSString *)AlbumName;

@end
