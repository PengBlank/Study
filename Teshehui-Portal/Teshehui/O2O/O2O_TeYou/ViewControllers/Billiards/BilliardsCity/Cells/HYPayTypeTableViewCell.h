//
//  HYPayTypeTableViewCell.h
//  Teshehui
//
//  Created by macmini7 on 15/11/4.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//  订单结算类型cell

#import <UIKit/UIKit.h>
#import "HYBilliardsCity.h"

@interface HYPayTypeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectImg;//选择状态

@property (weak, nonatomic) IBOutlet UILabel *typeLable;//会员价类型

@property (nonatomic,strong) HYBilliardsCity *billCity;// 模型

+ (instancetype)initPayTypeTableView:(UITableView *)tableView;

@end
