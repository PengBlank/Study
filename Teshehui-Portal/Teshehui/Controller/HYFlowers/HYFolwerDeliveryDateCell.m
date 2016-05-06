//
//  HYFolwerDeliveryDateCell.m
//  Teshehui
//
//  Created by 回亿资本 on 14-4-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYFolwerDeliveryDateCell.h"

@implementation HYFolwerDeliveryDateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1.0];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(10, 11, 120, 20);
    self.detailTextLabel.frame = CGRectMake(CGRectGetWidth(self.frame)-120-35, 11, 120, 20);
}

@end
