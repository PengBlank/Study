//
//  HYTaxiAddOrderParam.m
//  Teshehui
//
//  Created by 成才 向 on 15/11/23.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYTaxiAddOrderParam.h"
#import "HYUserInfo.h"

@implementation HYTaxiAddOrderParam

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

//- (NSDictionary *)toDictionary
//{
//    NSMutableDictionary *dict = [[super toDictionary] mutableCopy];
//    [dict removeObjectForKey:@"orderTotalAmount"];
//    [dict removeObjectForKey:@"userId"];
//    NSMutableDictionary *ret = [NSMutableDictionary dictionary];
//    if (self.orderTotalAmount) {
//        [ret setObject:self.orderTotalAmount forKey:@"orderTotalAmount"];
//    }
//    if (self.userId) {
//        [ret setObject:self.userId forKey:@"userId"];
//    }
//    [ret setObject:dict forKey:@"expandedRequest"];
//    
//    return ret;
//}

+ (instancetype)testData
{
    NSString *json = @"{\"orderTotalAmount\":\"45\",\"userId\":\"64492\",\"cityCode\":\"2\",\"cityName\":\"深圳\",\"ruleCode\":\"301\",\"carTypeCode\":\"600\",\"comboId\":null,\"callCarType\":\"0\",\"startTime\":null,\"passengerPhone\":\"18575560385\",\"startLatitude\":\"22.531158945227\",\"startLongitude\":\"114.02187661998\",\"startAddressName\":\"雪松大厦B座\",\"startAddressDetail\":\"泰然六路\",\"endLatitude\":\"22.540758984003\",\"endLongitude\":\"113.92442528508\",\"endAddressName\":\"南山公安分局\",\"endAddressDetail\":\"南山\",\"currentLatitude\":null,\"currentLongitude\":null,\"mapType\":null,\"smsPolicy\":null}";
    HYTaxiAddOrderParam *para = [[HYTaxiAddOrderParam alloc] initWithString:json error:nil];
    para.userId = [HYUserInfo getUserInfo].userId;
    return para;
}

@end
