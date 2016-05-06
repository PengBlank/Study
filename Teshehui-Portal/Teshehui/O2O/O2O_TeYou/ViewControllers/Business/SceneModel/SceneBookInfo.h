//
//  SceneBookInfo.h
//  Teshehui
//
//  Created by LiuLeiMacmini on 16/4/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneBookInfo : NSObject
@property (nonatomic,strong) NSString   *validCode; //": "800000",     验证码
@property (nonatomic,strong) NSString   *o2o_trade_no; //":"",           O2O的订单流水号
@property (nonatomic,strong) NSString   *c2b_trade_no; //":"",           C2B的订单流水号
@property (nonatomic,strong) NSString   *c2b_order_id; //":""             O2O订单id
@end
