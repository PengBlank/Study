//
//  HYMeiWeiQiQiOrderListPriceCell.m
//  Teshehui
//
//  Created by HYZB on 15/12/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMeiWeiQiQiOrderListPriceCell.h"

@implementation HYMeiWeiQiQiOrderListPriceCell

+ (HYMeiWeiQiQiOrderListPriceCell *)setCellWithTableView:(UITableView *)tableView
{
    static NSString *amountCellId = @"amountCellId";
    HYMeiWeiQiQiOrderListPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:amountCellId];
    if (!cell)
    {
        cell = [[HYMeiWeiQiQiOrderListPriceCell alloc]initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:amountCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.indicator removeFromSuperview];
    }
    
    return cell;
}

@end
