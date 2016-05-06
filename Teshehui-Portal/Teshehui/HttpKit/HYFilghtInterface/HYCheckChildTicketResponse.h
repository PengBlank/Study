//
//  HYCheckChildTiketResponse.h
//  Teshehui
//
//  Created by 回亿资本 on 14-3-8.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"

@interface HYCheckChildTicketResponse : CQBaseResponse

@property (nonatomic, assign, readonly) BOOL hasChildrenTicket;
@property (nonatomic, assign) CGFloat single_price;  //搜索航班日期(时间戳)
@property (nonatomic, assign) CGFloat airport_tax;  //出发城市三字码
@property (nonatomic, assign) CGFloat fuel_tax;  //到达城市三字码
@property (nonatomic, assign) CGFloat cPoint;  //儿童票赠送现金券

@property (nonatomic, assign) CGFloat bbPrice;  //婴儿的票价
@property (nonatomic, assign) CGFloat bbFee;  //婴儿票手续费
@property (nonatomic, assign) CGFloat bbPoint;  //婴儿票赠送现金券

@end
