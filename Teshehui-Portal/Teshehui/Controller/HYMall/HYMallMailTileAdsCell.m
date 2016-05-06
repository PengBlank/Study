//
//  HYMallMailTileAdsCell.m
//  Teshehui
//
//  Created by HYZB on 14-9-10.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallMailTileAdsCell.h"

@implementation HYMallMailTileAdsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:16];
        self.detailTextLabel.textColor = [UIColor colorWithWhite:0.2 alpha:1.0];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
