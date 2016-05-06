//
//  ConsumeCell.m
//  Teshehui
//
//  Created by macmini5 on 16/3/2.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "ConsumeCell.h"
#import "Masonry.h"
#import "UIColor+expanded.h"

@interface ConsumeCell ()

@property (nonatomic, strong) UILabel *tradeNum;    // 流水号
@property (nonatomic, strong) UILabel *money;       // 费用
@property (nonatomic, strong) UILabel *time;        // 时间
@property (nonatomic, strong) UILabel *type;        // 类型
@property (nonatomic, strong) UIView *line;         // 线

@end

@implementation ConsumeCell

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self createUI];
        [self constraintUI];
    }
    return self;
}

- (void)createUI
{
    // 流水号
    self.tradeNum = [[UILabel alloc] init];
    [self.tradeNum setFont:[UIFont systemFontOfSize:15]];
    [self.tradeNum setTextColor:[UIColor colorWithHexString:@"333333"]];
    [self.contentView addSubview:self.tradeNum];
    self.tradeNum.text = @"账单好DBH123456";
    // 费用
    self.money = [[UILabel alloc] init];
    [self.money setFont:[UIFont systemFontOfSize:24]];
    [self.contentView addSubview:self.money];
    self.money.text = @"300";
    // 时间
    self.time = [[UILabel alloc] init];
    [self.time setFont:[UIFont systemFontOfSize:14]];
    [self.time setTextColor:[UIColor colorWithHexString:@"666666"]];
    [self.contentView addSubview:self.time];
    self.time.text = @"2016-08-18 12/30/56";
    // 类型
    self.type = [[UILabel alloc] init];
    [self.type setFont:[UIFont systemFontOfSize:14]];
    [self.type setTextColor:[UIColor colorWithHexString:@"666666"]];
    [self.contentView addSubview:self.type];
    self.type.text = @"微信充值";
    // 线
    self.line = [[UIView alloc] init];
    [self.line setBackgroundColor:[UIColor colorWithHexString:@"e8e8e8"]];
    [self.contentView addSubview:self.line];
}

- (void)constraintUI
{
    WS(weakSelf);
    // 流水号
    [self.tradeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(25);
        make.top.mas_equalTo(weakSelf.contentView.mas_top);//.with.offset(18);
        make.bottom.mas_equalTo(weakSelf.line.mas_top);
    }];
    // 费用
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.centerY.mas_equalTo(weakSelf.tradeNum.mas_centerY);
    }];
    // 线
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.contentView.mas_left).with.offset(15);
        make.top.mas_equalTo(weakSelf.contentView.mas_top).with.offset(49);
        make.right.mas_equalTo(weakSelf.contentView.mas_right);
        make.height.mas_equalTo(@1);
    }];
    // 时间
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.tradeNum.mas_left);
        make.top.mas_equalTo(weakSelf.line.mas_bottom);//.with.offset(14);
        make.bottom.mas_equalTo(weakSelf.contentView.mas_bottom);
    }];
    // 类型
    [self.type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.contentView.mas_right).with.offset(-20);
        make.centerY.mas_equalTo(weakSelf.time.mas_centerY);
    }];
    
}

- (void)refreshUIDataWithModel:(ConsumeInfo *)Info
{
    [self.tradeNum setText:Info.o2otradeNo];
    [self.time setText:Info.createdon];
    [self.type setText:Info.payWay];
    if ([Info.type integerValue] == 1)
    {// 1充值
        [self.money setText:[NSString stringWithFormat:@"+%@",Info.amount]];
        [self.money setTextColor:[UIColor colorWithHexString:@"00b99b"]];
    }else
    {// 2消费
        [self.money setText:[NSString stringWithFormat:@"-%@",Info.amount]];
        [self.money setTextColor:[UIColor colorWithHexString:@"e33e37"]];
    }
}





- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
