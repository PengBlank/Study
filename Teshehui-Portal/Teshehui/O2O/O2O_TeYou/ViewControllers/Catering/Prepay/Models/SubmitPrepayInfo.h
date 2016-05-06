//
//  SubmitPrepayInfo.h
//  Teshehui
//
//  Created by macmini5 on 16/3/3.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SubmitPrepayInfo : NSObject

@property (nonatomic, strong) NSString *o2o_trade_no;   // o2o订单号
@property (nonatomic, strong) NSString *c2b_trade_no;   // c2b订单号
@property (nonatomic, strong) NSString *c2b_order_id;   // c2b订单id

@end
