//
//  faFbPhotos.h
//  FliterApp
//
//  Created by Presley on 13/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface faFbPhotos : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (strong, nonatomic) IBOutlet UITextView *memoAlbums;
@property (retain, nonatomic) NSMutableDictionary *albumDictionary;
@property (strong, nonatomic) NSMutableArray *albumArray;
@property (strong, nonatomic) NSMutableArray *albumCoverPhotoURL;
@property (strong, nonatomic) IBOutlet UITableView *albumTableView;
@property (strong, nonatomic) IBOutlet UIImageView *imgCellAlbum;
@property (nonatomic, strong) UIImage *imgLargAlbumcover;

- (IBAction)btnAlubm:(id)sender;


- (IBAction)btnReload:(id)sender;
- (IBAction)btnGetAlbumList:(id)sender;
@end
