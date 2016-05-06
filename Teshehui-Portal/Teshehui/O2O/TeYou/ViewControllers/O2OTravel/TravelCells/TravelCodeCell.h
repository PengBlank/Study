//
//  TravelCodeCell.h
//  Teshehui
//
//  Created by macmini5 on 15/11/18.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//
/**
 旅游订单二维码cell
 **/
#import <UIKit/UIKit.h>

@interface TravelCodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ticketName;   // 票名
@property (weak, nonatomic) IBOutlet UILabel *tickets;      // 票数量
@property (weak, nonatomic) IBOutlet UILabel *useDate;      // 使用天数
@property (weak, nonatomic) IBOutlet UIView  *bgView;

@end
