//
//  HYMeiWeiQiQiOrderListStatusCell.m
//  Teshehui
//
//  Created by HYZB on 15/12/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMeiWeiQiQiOrderListStatusCell.h"

@implementation HYMeiWeiQiQiOrderListStatusCell

+ (HYMeiWeiQiQiOrderListStatusCell *)setCellWithTableView:(UITableView *)tableView
{
    static NSString *orderStatusCellId = @"orderStatusCellId";
    HYMeiWeiQiQiOrderListStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:orderStatusCellId];
    if (!cell)
    {
        cell = [[HYMeiWeiQiQiOrderListStatusCell alloc]initWithStyle:UITableViewCellStyleValue1
                                               reuseIdentifier:orderStatusCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.iconView.image = [UIImage imageNamed:@"icon_order2"];
    }
    return cell;
}

@end
