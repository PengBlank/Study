//
//  BusinessMainCell.m
//  Teshehui
//
//  Created by apple_administrator on 16/4/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "BusinessMainCell.h"
#import "UILabel+Common.h"
#import "UIButton+Common.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h"
#import "DefineConfig.h"
#import "UIView+Common.h"
#import "UIColor+expanded.h"
#import "TYAnalyticsManager.h"
@implementation BusinessMainCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _mainImageV = [[UIImageView alloc] init];
//        [_mainImageV setImage:[UIImage imageNamed:@"003.jpg"]];
        [self.contentView addSubview:_mainImageV];
        
        _backgroudView = [[UIView alloc] init];
        [_backgroudView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.1]];
        [self.contentView addSubview:_backgroudView];
        
        _titleLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:17] textColor:[UIColor whiteColor]];
//        [_titleLabel setText:@"诉说三五旧事 共度美好时光我有故事你有酒吗？我有故事你有酒吗？"];

        _desLabel   = [UILabel labelWithFont:[UIFont systemFontOfSize:15] textColor:[UIColor whiteColor]];
//        [_desLabel setText:@"我有故事你有酒吗？"];
        
        _lineView = [[UIView alloc] init];
        [_lineView setBackgroundColor:[UIColor colorWithHexString:@"0xffffff"]];
        
        
         _praiseLabel = [UILabel labelWithFont:[UIFont systemFontOfSize:13] textColor:[UIColor whiteColor]];

        
        [_backgroudView addSubview:_titleLabel];
        [_backgroudView addSubview:_desLabel];
        [_backgroudView addSubview:_lineView];
        [_backgroudView addSubview:_praiseLabel];
        
        
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
        [_shareBtn setBackgroundImage:[UIImage imageNamed:@"sharehl"] forState:UIControlStateHighlighted];
        [_shareBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        _shareBtn.contentMode = UIViewContentModeCenter;
        [_backgroudView addSubview:_shareBtn];
        
//        _praiseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_praiseBtn setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
//        [_praiseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [[_praiseBtn titleLabel] setFont:[UIFont systemFontOfSize:12]];
////        _praiseBtn.contentMode = UIViewContentModeCenter;
//        [_backgroudView addSubview:_praiseBtn];
        
        [self makeConstraints];
        
    }
    return self;
}

- (void)makeConstraints{
    
    WS(weakSelf);
    [_mainImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView);
    }];
    
    [_backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.mainImageV.mas_bottom);
        make.left.equalTo(weakSelf.contentView.mas_left);
        make.right.equalTo(weakSelf.contentView.mas_right);
        make.top.equalTo(weakSelf.mainImageV.mas_bottom).offset(-60);
    }];
    

    
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.backgroudView.mas_centerY);
        make.right.equalTo(weakSelf.backgroudView.mas_right).offset(-12.5);
        make.width.equalTo(@26);
//        make.left.equalTo(weakSelf.praiseBtn.mas_right).offset(8);

    }];
    
//    [_praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakSelf.backgroudView.mas_centerY);
//        make.right.equalTo(weakSelf.shareBtn.mas_left).offset(-8);
//        make.width.equalTo(@30);
//        
//    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.backgroudView.mas_top).offset(8);
        make.left.equalTo(weakSelf.contentView.mas_left).offset(12.5);
        make.right.equalTo(weakSelf.shareBtn.mas_left).offset(-5);
    }];
//
    [_desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.backgroudView.mas_bottom).offset(-8);
        make.left.equalTo(weakSelf.titleLabel.mas_left);
        make.right.lessThanOrEqualTo(weakSelf.contentView.mas_right).offset(-150);
        
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.desLabel.mas_right).offset(5);
//        make.centerY.equalTo(weakSelf.desLabel);
        make.top.equalTo(weakSelf.desLabel);
        make.bottom.equalTo(weakSelf.desLabel);
        make.width.equalTo(@1);
    }];
    
    [_praiseLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.lineView.mas_right).offset(5);
        make.centerY.equalTo(weakSelf.desLabel);
    }];

}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGFloat width = CGRectGetMinX(self.praiseBtn.frame)-10;
//    width -= CGRectGetMinX(self.titleLabel.frame);
//    self.titleLabel.preferredMaxLayoutWidth = width;
//}

- (void)bindData:(SceneListInfo *)sInfo{
    self.baseInfo = sInfo;
    if (sInfo == nil) {
        return;
    }
    WS(weakSelf);
    NSString *url = [NSString stringWithFormat:@"%@%@%.0fw_%.0fh_1l_2e",sInfo.url,@"@",kScreen_Width * 2,ScaleHEIGHT(250) * 2];
    DebugNSLog(@"场景列表：%@",url);
    [_mainImageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"ico_logo_bg"]
                          completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        weakSelf.baseInfo.tmpImage = image;
    }];
    [_titleLabel setText:sInfo.packageName];
    [_desLabel setText:sInfo.merchantName];
    [_praiseLabel setText:[NSString stringWithFormat:@"%@人已赞",sInfo.favorites ? : @"0"]];


}

- (void)buttonPressed:(UIButton *)btn{
 [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWithShareBlock object:self.baseInfo];
    //统计
 [[TYAnalyticsManager sharedManager] sendAnalyseForSceneBtnClick:MainListPageShareBtn];
 

}



@end
