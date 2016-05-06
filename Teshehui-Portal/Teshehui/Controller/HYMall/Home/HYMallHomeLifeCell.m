//
//  HYMallHomeLifeCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeLifeCell.h"
#import "UIImageView+WebCache.h"
#import "HYMallHomeItem.h"

@implementation HYMallHomeLifeCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *lineView4 = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-.5, frame.size.width, .5)];
//        lineView4.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
//                                                                                     topCapHeight:2];
        lineView4.backgroundColor = [UIColor colorWithWhite:.9 alpha:1];
        [self.contentView addSubview:lineView4];
    }
    return self;
}


- (void)setItem:(HYMallHomeItem *)item
{
    if (item != _item)
    {
        _item = item;
        
        for (UIView *sub in self.contentView.subviews)
        {
            [sub removeFromSuperview];
        }
        
        UIImageView *content = [[UIImageView alloc] initWithFrame:CGRectMake(0, 1, self.frame.size.width, self.frame.size.height-1)];
        content.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:content];
        if (item.pictureUrl.length > 0)
        {
            NSURL *url = [NSURL URLWithString:item.pictureUrl];
            [content sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"loading"]];
        }
    }
}

@end
