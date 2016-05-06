//
//  HYTaxiSuggestAddressRequest.h
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYTaxiSuggestAddressRequest : CQBaseRequest

@property (nonatomic, copy) NSString *cityName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
//接口增加2个参数
/** 纬度 */

/** 经度 */
@end
