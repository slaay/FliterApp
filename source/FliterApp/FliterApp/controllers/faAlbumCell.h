//
//  faAlbumCell.h
//  FliterApp
//
//  Created by Presley on 21/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//http://www.appcoda.com/customize-table-view-cells-for-uitableview/

#import <UIKit/UIKit.h>

@interface faAlbumCell : UITableViewCell
    @property (nonatomic, weak) IBOutlet UILabel *lblalumbName;
    @property (nonatomic, weak) IBOutlet UILabel *lblalbumID;
    @property (nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;
@end
