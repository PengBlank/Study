//
//  HYMallHomeBrandAdsCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeBrandAdsCell.h"
#import "UIButton+WebCache.h"
#import "HYMallHomeItem.h"

@interface HYMallHomeBrandAdsCell ()

@end


@implementation HYMallHomeBrandAdsCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _headerView = [[HYMallHomeHeaderView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_headerView];
        
        UIImageView *lineView3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, .5)];
        lineView3.image = [[UIImage imageNamed:@"line_cell_top"] stretchableImageWithLeftCapWidth:0
                                                                                     topCapHeight:2];
        [self.contentView addSubview:lineView3];
    }
    return self;
}
@end
