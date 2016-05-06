//
//  HYHotelTraffic.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店交通描述对象
 */

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYHotelTraffic : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *HotelID;
@property (nonatomic, copy) NSString *TypeNameEN;
@property (nonatomic, copy) NSString *TypeName;
@property (nonatomic, copy) NSString *PlaceNameEN;
@property (nonatomic, copy) NSString *PlaceName;
@property (nonatomic, copy) NSString *Distance;
@property (nonatomic, copy) NSString *ArrivalWay;

@end
