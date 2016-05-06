//
//  HYAroundMallDetailCell.m
//  Teshehui
//
//  Created by RayXiang on 14-7-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYAroundMallDetailCell.h"
#import "HYQRCodeGetShopDetailResponse.h"
#import "HYQRCodeGetShopListResponse.h"

@implementation HYAroundMallDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        CGRect bounds = [UIScreen mainScreen].bounds;
        
        UIImageView *teshehui = [[UIImageView alloc]
                                 initWithImage:[UIImage imageNamed:@"aroundMall_placeholder"]];
        teshehui.frame = CGRectMake(0, 0, bounds.size.width, 150);
        [self.contentView addSubview:teshehui];
        
        self.titleLabel = [[UILabel alloc]
                           initWithFrame:CGRectMake(30, CGRectGetMaxY(teshehui.frame) + 5, CGRectGetWidth(self.frame)-40, 16)];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.text = @"商户详情";
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_titleLabel];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(17, CGRectGetMaxY(_titleLabel.frame)+10, CGRectGetWidth(ScreenRect)-2*17, 2)];
        sep.backgroundColor = [UIColor colorWithWhite:.93 alpha:1];
        [self.contentView addSubview:sep];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(27, CGRectGetMaxY(sep.frame)+11, CGRectGetWidth(self.frame)-54, 300-CGRectGetMaxY(sep.frame)-11)];
        self.detailLabel.font = [UIFont systemFontOfSize:13];
        self.detailLabel.textColor = [UIColor grayColor];
        self.detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.numberOfLines = 0;
        _detailLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:_detailLabel];
    }
    return self;
}

- (void)setWithShop:(HYQRCodeShop *)shopDetail
{
    if (shopDetail.merchant_description.length > 0)
    {
        NSString *t = shopDetail.merchant_description;
        CGSize size = [t sizeWithFont:_detailLabel.font constrainedToSize:CGSizeMake(_detailLabel.frame.size.width, 3000)];
        CGRect frame = _detailLabel.frame;
        frame.size.height = size.height;
        _detailLabel.frame = frame;
        _detailLabel.text = shopDetail.merchant_description;
        
        frame = self.frame;
        frame.size.height = CGRectGetMaxY(_detailLabel.frame) + 10;
        self.frame = frame;
    } else {
        _detailLabel.text = nil;
        self.frame = CGRectMake(0, 0, 320, CGRectGetMinY(_detailLabel.frame) + 100);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
