//
//  HYHotelService.h
//  Teshehui
//
//  Created by 回亿资本 on 14-2-17.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/**
 * 酒店设施描述对象
 */

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"

@interface HYHotelService : NSObject<CQResponseResolve>

@property (nonatomic, copy) NSString *HotelID;
@property (nonatomic, copy) NSString *Facility;
@property (nonatomic, copy) NSString *FType;
@property (nonatomic, copy) NSString *FTypeName;
@property (nonatomic, copy) NSString *FacilityName;
@property (nonatomic, copy) NSString *FacilityNameEN;

@end
