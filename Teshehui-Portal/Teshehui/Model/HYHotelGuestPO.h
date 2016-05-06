//
//  HYHotelGuestPO.h
//  Teshehui
//
//  Created by Kris on 15/5/27.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
@protocol HYHotelGuestPO @end

@interface HYHotelGuestPO : JSONModel
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *certificateCode;
@property (nonatomic, copy) NSString *gender;
@end

//{
//    "name": "韩韩韩",
//    "certificateCode": 0,
//    "gender": 0
//}