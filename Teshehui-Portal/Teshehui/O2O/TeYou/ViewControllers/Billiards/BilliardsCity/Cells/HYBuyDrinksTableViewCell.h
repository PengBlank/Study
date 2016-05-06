//
//  HYBuyDrinksTableViewCell.h
//  Teshehui
//
//  Created by macmini7 on 15/11/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//  购买酒水cell

#import <UIKit/UIKit.h>
#import "HYBilliardsCity.h"

@interface HYBuyDrinksTableViewCell : UITableViewCell

@property (nonatomic,strong) HYBilliardsCity *billCity;

@property (weak, nonatomic) IBOutlet UILabel *left;//左边Lable
@property (weak, nonatomic) IBOutlet UILabel *right;//右边Lable

//返回购买酒水tableView
+ (instancetype)initBuyDrinksTableView:(UITableView *)tableView;

@end
