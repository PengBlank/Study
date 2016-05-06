//
//  HYPhoneChargeDataController.h
//  Teshehui
//
//  Created by Kris on 16/3/1.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ChargeType) {
    ChargePhone = 2,
    ChargeFlow = 5,
};

typedef void(^RechargeBlock)(NSArray *dataList);
typedef void(^AddRechargeBlock)(id order);

@interface HYPhoneChargeDataController : NSObject

//for the phone num cache
@property (nonatomic, copy, readonly) NSString *phoneNum;

- (void)fetchRechargeGoodsType:(NSUInteger)type
                  withPlatForm:(NSUInteger)platForm
                     andNumber:(NSString *)num
               completionBlock:(RechargeBlock)block;

//without number you can use this
- (void)fetchRechargeGoodsType:(NSUInteger)type
                  withPlatForm:(NSUInteger)platForm
               completionBlock:(RechargeBlock)block;

//add order
- (void)addRechargeOrderWithParamObjects:(id)param
                                    Type:(NSUInteger)type
                         CompletionBlock:(AddRechargeBlock)block;
@end
