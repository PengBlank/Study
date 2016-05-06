//
//  HYMineInfoWalletCell.m
//  Teshehui
//
//  Created by 成才 向 on 15/8/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMineInfoWalletCell.h"
#import "HYImageButton.h"

@interface HYMineInfoWalletCell ()
{
    HYImageButton *_balanceBtn;
    HYImageButton *_pointBtn;
    
    /// 现金券、余额、红包
    UILabel *_ticket;
    UILabel *_money;
    UILabel *_packet;
    UILabel *_o2o;
}
@end

@implementation HYMineInfoWalletCell

- (void)awakeFromNib
{
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        CGFloat width = [[UIScreen mainScreen] bounds].size.width;
        self.frame = CGRectMake(0, 0, width, 55);
        self.separatorLeftInset = 0;
        
        /// 默认cell高度50, 均等分25
        CGFloat itemWidth = width / 4;
        CGFloat labelHeight = 25;
        
        
        /// 现金券
        UILabel *ticket = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, itemWidth, labelHeight)];
        [self configureLabel:ticket];
        [self.contentView addSubview:ticket];
        _ticket = ticket;
        
        /// 现金券标题
        UILabel *ticketLab = [[UILabel alloc] initWithFrame:CGRectMake(0, labelHeight, itemWidth, labelHeight)];
        [self configureLabel:ticketLab];
        ticketLab.text = @"现金券";
        [self.contentView addSubview:ticketLab];
        
        /// 余额
        UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth, 5, itemWidth, labelHeight)];
        [self configureLabel:money];
        [self.contentView addSubview:money];
        _money = money;
        
        /// 余额标题
        UILabel *moneyLab = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth, labelHeight, itemWidth, labelHeight)];
        [self configureLabel:moneyLab];
        moneyLab.text = @"账户余额";
        [self.contentView addSubview:moneyLab];
        
        /// 红包数
        UILabel *packet = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth*3, 5, itemWidth, labelHeight)];
        [self configureLabel:packet];
        [self.contentView addSubview:packet];
        _packet = packet;
        
        /// 红包
        UILabel *packetLab = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth*3, labelHeight, itemWidth, labelHeight)];
        [self configureLabel:packetLab];
        packetLab.text = @"红包";
        [self.contentView addSubview:packetLab];
        
        /// 实体店
        UILabel *o2o = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth*2, 5, itemWidth, labelHeight)];
        [self configureLabel:o2o];
        [self.contentView addSubview:o2o];
        _o2o = o2o;
        
        UILabel *o2otitle = [[UILabel alloc] initWithFrame:CGRectMake(itemWidth*2, labelHeight, itemWidth, labelHeight)];
        [self configureLabel:o2otitle];
        o2otitle.text = @"实体店余额";
        [self.contentView addSubview:o2otitle];
        
        /// 默认值
        _ticket.text = @"0";
        _money.text = @"0.00";
        _packet.text = @"0/0";
        _o2o.text = @"0.00";
        
        /// 点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self.contentView addGestureRecognizer:tap];
    }
    return self;
}

- (void)configureLabel:(UILabel *)label
{
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor colorWithWhite:.5 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
}

- (void)setSendPackets:(NSInteger)send recv:(NSInteger)recv
{
    if (_packetsSend != send || _packetsRecv != recv)
    {
        _packetsSend = send;
        _packetsRecv = recv;
        _packet.text = [NSString stringWithFormat: @"%ld/%ld", _packetsRecv, _packetsSend];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.contentView];
    NSInteger itemWidth = self.frame.size.width / 4;
    if (self.didCheckSubType) {
        self.didCheckSubType(location.x / itemWidth);
    }
}

- (void)setPoints:(NSInteger)points
{
    if (_points != points)
    {
        _points = points;
        _ticket.text = [NSString stringWithFormat:@"%ld", points];
    }
}

- (void)setBalance:(double)balance
{
    if (_balance != balance)
    {
        _balance = balance;
        _money.text = [NSString stringWithFormat:@"%.2f", balance];
    }
}

- (void)setO2obalance:(double)o2obalance
{
    if (_o2obalance != o2obalance) {
        _o2obalance = o2obalance;
        _o2o.text = [NSString stringWithFormat:@"%.2f", o2obalance];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
