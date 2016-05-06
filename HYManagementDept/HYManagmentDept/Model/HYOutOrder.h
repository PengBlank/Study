//
//  HYOutOrder.h
//  HYManagmentDept
//
//  Created by Ray on 14-12-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  待结算订单对象
 */
@interface HYOutOrder : NSObject

@property (nonatomic, assign) NSInteger order_source;   //类型，1机票。。。
@property (nonatomic, strong) NSString *order_no;   //订单号
@property (nonatomic, strong) NSString *created_time;   //下单时间
@property (nonatomic, strong) NSString *number; //会员卡号
@property (nonatomic, assign) float order_amount;    //订单金额
@property (nonatomic, strong) NSString *promoters_name;

@property (nonatomic, strong) NSString *order_status;

- (id)initWithDataInfo:(NSDictionary *)data;

@end
