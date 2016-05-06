//
//  TravelOrderCodeCell.h
//  Teshehui
//
//  Created by macmini5 on 15/12/17.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//
/*wfl
 旅游订单二维码cell
*/

#import <UIKit/UIKit.h>
#import "TravelTicketInfo.h"

@interface TravelOrderCodeCell : UITableViewCell

@property (nonatomic, strong) UILabel   *ticketName;        // 票名
@property (nonatomic, strong) UILabel   *humanCount;        // 人数量
@property (nonatomic, strong) UILabel   *remainDays;        // 剩余天数
@property (nonatomic, strong) UILabel   *touristTitleLabel; // 包含景点title
@property (nonatomic, strong) UILabel   *touristName;       // 景点名

@property (nonatomic, strong) UIView    *bgView;            // 背景View
@property (nonatomic, strong) UIView    *lineView;          // 线

@property (nonatomic, assign) BOOL      isHistory;          // 历史订单

@property (nonatomic, strong) TravelTicketInfo *ticketInfo;

// 初始化
-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
// UI数据赋值
-(void)bindData:(TravelTicketInfo *)ticketInfo;
// 计算cell的高度 把 包含景点 的景点名数组传进来 (是否是历史订单)
+(CGFloat)cellHeightWithTouristNameArr:(NSArray *)arr IsHistory:(BOOL)isHistory;


@end
