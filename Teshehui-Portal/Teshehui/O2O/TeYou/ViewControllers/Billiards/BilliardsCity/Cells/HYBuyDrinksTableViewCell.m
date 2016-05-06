//
//  HYBuyDrinksTableViewCell.m
//  Teshehui
//
//  Created by macmini7 on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//  购买酒水cell

#import "HYBuyDrinksTableViewCell.h"
#import "Masonry.h"

@implementation HYBuyDrinksTableViewCell

- (void)awakeFromNib {
    
//    WS(weakSelf)
//    [_left mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(weakSelf.mas_left).offset(10);
//        make.centerY.mas_equalTo(weakSelf.mas_centerY);
//    }];
//    
//    [_right mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.mas_equalTo(weakSelf.mas_right).offset(-10);
//        make.centerY.mas_equalTo(weakSelf.mas_centerY);
//    }];
}

+(instancetype)initBuyDrinksTableView:(UITableView *)tableView
{
    static NSString *buyDrinksID = @"BuyDrinksID";
    HYBuyDrinksTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:buyDrinksID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYBuyDrinksTableViewCell" owner:self options:nil] lastObject];
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
        _left.text = _billCity.orderNumLabel;
        _right.text = _billCity.orderNum;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
