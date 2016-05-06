//
//  HYMyInfoHeadPortraitCell.m
//  Teshehui
//
//  Created by Kris on 15/12/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMyInfoHeadPortraitCell.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface HYMyInfoHeadPortraitCell ()
{
    UIImageView *_portraitBtn;
}

@property (nonatomic, strong)HYUserInfo *userInfo;

@end

@implementation HYMyInfoHeadPortraitCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        __weak typeof(self) weakSelf = self;
        _portraitBtn = [UIImageView new];
        CGFloat size = 50;
        _portraitBtn.layer.cornerRadius = size/2;
        _portraitBtn.clipsToBounds = YES;
        [self.contentView addSubview:_portraitBtn];
        [_portraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-25);
            make.centerY.equalTo(weakSelf.contentView);
            make.size.mas_equalTo(CGSizeMake(size, size));
        }];
        [_portraitBtn setImage:[UIImage imageNamed:@"mine_default"]];
    }
    return self;
}

#pragma mark setter and getter
-(void)setUserInfo:(HYUserInfo *)userInfo
{
    _userInfo = userInfo;
    
    if (_userInfo.userLogo)
    {
        NSURL *URL = [NSURL URLWithString:_userInfo.userLogo.defaultURL];
        [_portraitBtn sd_setImageWithURL:URL placeholderImage:[UIImage imageNamed:@"mine_default"] options:SDWebImageRefreshCached];
    }
}

@end
