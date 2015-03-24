//
//  faAlbumPhotoListViewController.m
//  FliterApp
//
//  Created by Presley on 23/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//

#import "faAlbumPhotoListViewController.h"

@interface faAlbumPhotoListViewController ()

@end

@implementation faAlbumPhotoListViewController

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
    self.imgAlbumCover.image = self.imgLargAlbumcover;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)configureDetails:(UIImage *)paramImage :(NSString *)AlbumName;
{
    self.imgLargAlbumcover = paramImage;
    NSLog(@"Name : %@", AlbumName);
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

@end
