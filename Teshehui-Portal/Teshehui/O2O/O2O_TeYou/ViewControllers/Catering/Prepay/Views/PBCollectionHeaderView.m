//
//  PBCollectionHeaderView.m
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PBCollectionHeaderView.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIImageView+WebCache.h" // 图片加载
#import "UIColor+expanded.h"

@interface PBCollectionHeaderView ()

@property (nonatomic, strong) UIView *bgView;               // 背景View
@property (nonatomic, strong) UIImageView *iconImageView;   // 图标View
@property (nonatomic, strong) UILabel *titleLabel;          // 店名Label
@property (nonatomic, strong) UILabel *moneyLabel;          // 钱Label
@property (nonatomic, strong) UILabel *sBLabel;             // 实体店余额文字
@property (nonatomic, strong) UIView *lineView;             // 线
@property (nonatomic, strong) UILabel *tsLabel;            // 充值套餐提示文字

@end

@implementation PBCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self constrainUI];
    }
    return self;
}

- (void)createUI
{
    self.backgroundColor = [UIColor colorWithHexString:@"f1f1f1"];
    
    // 背景
    self.bgView = [[UIView alloc] init];
    [self.bgView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview: self.bgView];
    // 图标
    self.iconImageView = [[UIImageView alloc] init];
    [self.iconImageView setClipsToBounds:YES];
    [self.iconImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.bgView addSubview:self.iconImageView];
    [self.iconImageView setImage:[UIImage imageNamed:@"loading"]];
//    self.iconImageView.backgroundColor = [UIColor grayColor];
    // 店名
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [self.bgView addSubview: self.titleLabel];
    self.titleLabel.text = @"喵味西餐啊";
    // 钱
    self.moneyLabel = [[UILabel alloc] init];
//    [self.moneyLabel setFont:[UIFont systemFontOfSize:16]];
    [self.moneyLabel setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:22]];
    [self.moneyLabel setTextColor:[UIColor colorWithHexString:@"00b99b"]];
    [self.bgView addSubview: self.moneyLabel];
    self.moneyLabel.text = @"¥120";
    // 实体店余额
    self.sBLabel = [[UILabel alloc] init];
    [self.sBLabel setFont:[UIFont systemFontOfSize:14]];
    [self.sBLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.bgView addSubview: self.sBLabel];
    self.sBLabel.text = @"实体店余额";
    // 线
    self.lineView = [[UIView alloc] init];
    [self.lineView setBackgroundColor:[UIColor colorWithHexString:@"d0d0d0"]];
    [self.bgView addSubview:self.lineView];
    // 提示
    self.tsLabel = [[UILabel alloc] init];
    [self.tsLabel setTextColor:[UIColor blackColor]];
    [self.tsLabel setBackgroundColor: self.backgroundColor];
    [self.tsLabel setFont:[UIFont systemFontOfSize:14]];
    [self.tsLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.tsLabel setText:@"  充值套餐  "];
    [self.bgView addSubview:self.tsLabel];
}
- (void)constrainUI
{
    WS(weakSelf);
    // 背景
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.mas_top).with.offset(10);
        make.left.mas_equalTo(weakSelf.mas_left).with.offset(10);
        make.right.mas_equalTo(weakSelf.mas_right).with.offset(-10);
        make.bottom.mas_equalTo(weakSelf.mas_bottom).with.offset(-53);
    }];
    // 图标
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bgView.mas_left).with.offset(8);
        make.top.mas_equalTo(weakSelf.bgView.mas_top).with.offset(8);
        make.width.mas_equalTo(90);
        make.height.mas_equalTo(90);
    }];
    // 店名
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.bgView.mas_top).with.offset(13);
        make.left.mas_equalTo(weakSelf.iconImageView.mas_right).with.offset(34);
        make.right.mas_equalTo(weakSelf.bgView.mas_right).with.offset(-8);
    }];
    // 钱
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).with.offset(13);
        make.left.mas_equalTo(weakSelf.titleLabel.mas_left);
    }];
    // 实体店余额文字
    [self.sBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.moneyLabel.mas_bottom).with.offset(5);
        make.left.mas_equalTo(weakSelf.moneyLabel.mas_left);
    }];
    // 线
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.bgView.mas_left);
        make.top.mas_equalTo(weakSelf.bgView.mas_bottom).with.offset(26);
        make.right.mas_equalTo(weakSelf.bgView.mas_right);
        make.height.mas_equalTo(@1);
    }];
    //
    [self.tsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(weakSelf.lineView.mas_centerX);
        make.centerY.mas_equalTo(weakSelf.lineView.mas_centerY);
    }];
}
// 刷新数据
- (void)refreshUIDataWithModel:(PrepayPBInfo *)Info
{
    // 图标
//    NSString *url = [NSString stringWithFormat:@"%@?imageView2/1/w/200/h/200",Info.merchantLogo];
    DebugNSLog(@"商家logoURL== %@",Info.merchantLogo);
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:Info.merchantLogo] placeholderImage:[UIImage imageNamed:@"loading"]];
    // 店名
    [self.titleLabel setText:Info.merchantName];
    // 余额
    [self.moneyLabel setText:[NSString stringWithFormat:@"¥%@",Info.balance]];
    
}

@end
