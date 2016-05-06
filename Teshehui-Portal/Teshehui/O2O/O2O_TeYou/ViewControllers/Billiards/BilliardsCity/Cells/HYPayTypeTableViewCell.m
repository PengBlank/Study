//
//  HYPayTypeTableViewCell.m
//  Teshehui
//
//  Created by macmini7 on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//  订单结算类型cell

#import "HYPayTypeTableViewCell.h"
#import "Masonry.h"

@implementation HYPayTypeTableViewCell

- (void)awakeFromNib {
//    WS(weakSelf)
//    [_typeLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.mas_left).offset(10);
//        make.centerY.mas_equalTo(weakSelf.mas_centerY);
//    }];
//    
//    [_selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
//        make.centerY.mas_equalTo(weakSelf.mas_centerY);
//    }];
}

+ (instancetype)initPayTypeTableView:(UITableView *)tableView
{
    static NSString *payTypeID = @"PayTypeID";
    HYPayTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:payTypeID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYPayTypeTableViewCell" owner:self options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

-(void)setBillCity:(HYBilliardsCity *)billCity
{
    if (billCity == nil) {
        return;
    }
    
    if (!_billCity) {
        _billCity = billCity;
        _typeLable.text = _billCity.orderNum;
        
        _selectImg.image = [UIImage imageNamed:_billCity.tabNum];
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
