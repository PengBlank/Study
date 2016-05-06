//
//  PayResultOfSceneCtrl.h
//  Teshehui
//
//  Created by apple_administrator on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMallViewBaseController.h"

@interface PayResultOfSceneCtrl : HYMallViewBaseController


/**
 *  下面是需要在跳转前传递的参数
 *  （如果数据模型里面包含有下面所有的信息，也可以定义一个数据模型来进行传值。）
 */

@property (nonatomic,strong) NSString   *O2O_OrderNo; //创建订单返回的，用于api轮询支付状态
@property (nonatomic,strong) NSString   *orderId;     //用于跳转到订单详情


@property (nonatomic,strong) NSString   *storeName; //店名
@property (nonatomic,strong) NSString   *money; //支付金额
@property (nonatomic,strong) NSString   *coupon; //支付现金券
@property (nonatomic,strong) NSString   *packName;// 套餐名
@property (nonatomic,strong) NSString   *payCode;// 消费码

@property (nonatomic,assign) NSInteger   comeType;// 0 套餐详情页面   1 订单页面



//@property (nonatomic,strong) NSString   *merId;
//@property (nonatomic,strong) NSString   *orderId;
//@property (nonatomic,strong) NSString   *orderType;



@end
