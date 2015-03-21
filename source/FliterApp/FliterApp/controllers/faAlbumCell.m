//
//  faAlbumCell.m
//  FliterApp
//
//  Created by Presley on 21/03/15.
//  Copyright (c) 2015 SlaaySourceCoders. All rights reserved.
//

#import "faAlbumCell.h"

@implementation faAlbumCell

@synthesize lblalumbName = _nameLabel;
@synthesize lblalbumID = _prepTimeLabel;
@synthesize thumbnailImageView = _thumbnailImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
