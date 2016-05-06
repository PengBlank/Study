//
//  HYTaxiOrderListCell.m
//  Teshehui
//
//  Created by HYZB on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiOrderListCell.h"
#import "HYTaxiOrderListViewController.h"

@interface HYTaxiOrderListCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderStatus;


@end

@implementation HYTaxiOrderListCell

- (void)awakeFromNib {
    // Initialization code
    
    self.orderStatus.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 5, 70, 30);
    
    self.lineView.frame = CGRectMake(10, 110, [UIScreen mainScreen].bounds.size.width - 20, 1);
    
    [self.goToPayMoneyBtn addTarget:self action:@selector(gotoPay:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.goToPayMoneyBtn];
    
    self.taxiTypeLab.layer.borderColor = [UIColor grayColor].CGColor;
    self.taxiTypeLab.layer.borderWidth = 1;
    self.taxiTypeLab.layer.cornerRadius = 11;
    
    self.startAddressLab.frame = CGRectMake(35, 38, TFScalePoint(265), 30);
    self.endAddressLab.frame = CGRectMake(35, 73, TFScalePoint(265), 30);
    
}

- (UIButton *)goToPayMoneyBtn
{
    if (!_goToPayMoneyBtn) {
        _goToPayMoneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_goToPayMoneyBtn setTitle:@"去付款" forState:UIControlStateNormal];
        [_goToPayMoneyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _goToPayMoneyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _goToPayMoneyBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _goToPayMoneyBtn.layer.borderWidth = 1;
        _goToPayMoneyBtn.layer.cornerRadius = 6;
        _goToPayMoneyBtn.layer.borderColor = [UIColor redColor].CGColor;
        _goToPayMoneyBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 130, 70, 30);
    }
    return _goToPayMoneyBtn;
}

- (void)gotoPay:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(payTaxiMoneyWithBtn:)]) {
        [self.delegate payTaxiMoneyWithBtn:btn];
    }
}

- (void)setCellInfoWithModel:(HYTaxiOrder *)model
{
    [self setShowOrderStatusText:model.status];
    self.taxiTypeLab.text = model.ruleName;
    self.dateLab.text = model.createdTime;
    self.startAddressLab.text =  model.startAddressName;
    self.endAddressLab.text = model.endAddressName;
    self.taxiMoneyLab.text = [NSString stringWithFormat:@"￥%@", model.didiOrderTotalAmount];
}

// 设置显示订单状态的文字
- (void)setShowOrderStatusText:(NSInteger)status
{
    didiTaxiStatus didiStatus = status;
    if (didiStatus == didiTaxiStatusBegin) {
        self.orderStatusLab.text = @"进行中";
    } else if (didiStatus == didiTaxiStatusUnfinished) {
        self.orderStatusLab.text = @"未完成";
    } else if (didiStatus == didiTaxiStatusFinished) {
        self.orderStatusLab.text = @"已完成";
    } else if (didiStatus == didiTaxiStatusClosed) {
        self.orderStatusLab.text = @"已关闭";
    }
}

// 订单完成和关闭样式
- (void)setCellCompleteType
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.accessoryType = UITableViewCellAccessoryNone;
    [self setUserInteractionEnabled:NO];
    self.lineView.hidden = YES;
    self.goToPayMoneyBtn.hidden = YES;
    self.taxiMoneyTitleLab.hidden = NO;
    self.taxiMoneyLab.hidden = NO;
}

// 订单进行中和未完成样式
- (void)setCellOtherStatusTypeWithPartsIsHiden:(BOOL)isHiden
{
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    [self setUserInteractionEnabled:YES];
    self.lineView.hidden = isHiden;
    self.goToPayMoneyBtn.hidden = isHiden;
    self.taxiMoneyTitleLab.hidden = isHiden;
    self.taxiMoneyLab.hidden = isHiden;
}

@end
