//
//  PBItemViewCell.m
//  Teshehui
//
//  Created by macmini5 on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "PBItemViewCell.h"
#import "DefineConfig.h"
#import "Masonry.h"
#import "UIColor+expanded.h"


@interface PBItemViewCell ()

@property (nonatomic, strong) UIImageView *bgImageView;     // 虚线背景框
@property (nonatomic, strong) UIImageView *colorImageView;  // 彩色背景
@property (nonatomic, strong) UIImageView *pickImageView;   // 选中的
@property (nonatomic, strong) UILabel *titleLabel;          // 充值标题
@property (nonatomic, strong) UILabel *subLable;            // 赠送标题
@property (nonatomic, strong) UILabel *deductLabel;         // 扣除提示语

@end

@implementation PBItemViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creteUI];
        [self constrainUI];
    }
    return self;
}

- (void)creteUI
{
    [self.contentView.layer setBorderColor:[UIColor colorWithHexString:@"e5e5e5"].CGColor];
    [self.contentView.layer setBorderWidth:1];
    self.contentView.backgroundColor = [UIColor whiteColor];
    //虚线框
    self.bgImageView = [[UIImageView alloc] init];
    [self.bgImageView setImage:nil];
//    [self.bgImageView setBackgroundColor:[UIColor blueColor]];
    [self.contentView addSubview:self.bgImageView];
    
    // 充值标题
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.text = @"充100元送";
    // 彩色背景
    self.colorImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.colorImageView];
    self.colorImageView.image = [UIImage imageNamed:@"coupons"];
    // 赠送标题
    self.subLable = [[UILabel alloc] init];
    [self.subLable setTextColor:[UIColor whiteColor]];
    [self.subLable setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:21]];
//    [self.subLable setFont:[UIFont systemFontOfSize:21]];
    [self.contentView addSubview:self.subLable];
    self.subLable.text = @"10元";
    // 扣除
    self.deductLabel = [[UILabel alloc] init];
    [self.deductLabel setTextColor:[UIColor whiteColor]];
    [self.deductLabel setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:self.deductLabel];
    self.deductLabel.text = @"抵扣10个现金券";
    // 选中图标
    self.pickImageView = [[UIImageView alloc] init];
    [self.pickImageView setImage:[UIImage imageNamed:@"red-Check-the"]];
    [self.contentView addSubview:self.pickImageView];
    [self.pickImageView setHidden:YES];
    
}

- (void)constrainUI
{
    WS(weakSelf);
    // 虚线背景
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(-1.5);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(-1);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(1.5);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(1);
    }];
    // 充值标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(g_fitFloat(@[@8,@16,@16])); //5:8 6:16 6p 16
        make.centerX.mas_equalTo(weakSelf.contentView.mas_centerX);
    }];
    // 色彩背景
    [self.colorImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(g_fitFloat(@[@15,@30,@30])); //5:15 6:30 6p:30
        make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).with.offset(9);
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(g_fitFloat(@[@-15,@-30,@-30]));//5:－15 6:－30 6p:－30
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom).with.offset(-10);
    }];
    // 赠送标题
    [self.subLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.colorImageView.mas_top);//.with.offset(2);
        make.bottom.mas_equalTo(weakSelf.colorImageView.mas_centerY);
        make.centerX.mas_equalTo(weakSelf.colorImageView.mas_centerX);
    }];
    // 扣除
    [self.deductLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.colorImageView.mas_centerY);//.with.offset(6);
        make.bottom.mas_equalTo(weakSelf.colorImageView.mas_bottom);
        make.centerX.mas_equalTo(weakSelf.colorImageView.mas_centerX);
    }];
    // 选中
    [self.pickImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakSelf.contentView.mas_top);
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.width.mas_equalTo(@27);
        make.height.mas_equalTo(@27);
    }];
}
// 刷新UI数据
- (void)refreshUIDataWithModel:(RechargePackagesInfo *)rpInfo Index:(NSInteger)index HavePoint:(BOOL)havePoint
{
    self.rpInfo = rpInfo;
    //彩色背景图
    NSArray *colorImageNames = @[@"coupons",@"yellow-coupons",@"red-coupons",@"green-coupons"];
    if (index > 3) {
        index = index%4;
    }
    UIImage *colorIamge = [UIImage imageNamed:colorImageNames[index]];
    [self.colorImageView setImage:colorIamge];
    if (havePoint)
    {// 现金券充足
        [self.bgImageView setImage:nil];
        [self.contentView.layer setBorderColor:[UIColor colorWithHexString:@"e5e5e5"].CGColor];
        [self.contentView.layer setBorderWidth:1];
    }else
    {// 现金券不足
        [self.bgImageView setImage:[UIImage imageNamed:@"dashed"]];
        [self.colorImageView setImage:[UIImage imageNamed:@"gray-coupons"]];
        [self.contentView.layer setBorderWidth:0];
    }
    
    // 充值标题
    [self.titleLabel setText:[NSString stringWithFormat:@"充值%@元送",rpInfo.amount]];
    // 赠送
    [self.subLable setText:[NSString stringWithFormat:@"%@元",rpInfo.givenAmount]];
    // 扣除
    [self.deductLabel setText:[NSString stringWithFormat:@"抵扣%@个现金券",rpInfo.givenAmount]];
    
}

- (void)pickTheCell:(BOOL)isPick HavePoint:(BOOL)havePoint
{
    if (isPick)
    {   // 选中出现边框和图标
        [self.contentView.layer setBorderColor:[UIColor colorWithHexString:@"ff3c50"].CGColor];
        [self.contentView.layer setBorderWidth:2];
        [self.pickImageView setHidden:NO];
    }else
    {   // 未选中
        [self.contentView.layer setBorderColor:[UIColor colorWithHexString:@"e5e5e5"].CGColor];
        CGFloat width = havePoint? 1:0;
        [self.contentView.layer setBorderWidth:width];
        [self.pickImageView setHidden:YES];
    }
}

@end
