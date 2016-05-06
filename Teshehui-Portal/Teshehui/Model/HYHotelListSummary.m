//
//  HYHotelInfoBase.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelListSummary.h"
#import "HYHotelStar.h"

@implementation HYHotelListSummary

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.productId = GETOBJECTFORKEY(data, @"productId", [NSString class]);
//        self.productName = GETOBJECTFORKEY(data, @"productName", [NSString class]);
//        self.productPicUrl = GETOBJECTFORKEY(data, @"productPicUrl", [NSString class]);
//        self.currencyCode = GETOBJECTFORKEY(data, @"currencyCode", [NSString class]);
//        
//        NSString *priceStr = GETOBJECTFORKEY(data, @"price", [NSString class]);
//        self.price = priceStr.floatValue;
//        self.points = GETOBJECTFORKEY(data, @"points", [NSString class]);
//        
//        NSDictionary *expandData = GETOBJECTFORKEY(data, @"expandedResponse", [NSDictionary class]);
//        
//        self.cityId = GETOBJECTFORKEY(expandData, @"cityId", [NSString class]);
//        self.address = GETOBJECTFORKEY(expandData, @"address", [NSString class]);
//        self.hotelStar = GETOBJECTFORKEY(expandData, @"hotelStar", [NSString class]);
//        self.hotelType = GETOBJECTFORKEY(expandData, @"hotelType", [NSString class]);
//        self.districtName = GETOBJECTFORKEY(expandData, @"districtName", [NSString class]);
//        self.commercialName = GETOBJECTFORKEY(expandData, @"commercialName", [NSString class]);
//        
//        self.bigLogoUrl = GETOBJECTFORKEY(expandData, @"bigLogoUrl", [NSString class]);
//        self.midLogoUrl = GETOBJECTFORKEY(expandData, @"midLogoUrl", [NSString class]);
//        self.smallLogoUrl = GETOBJECTFORKEY(expandData, @"smallLogoUrl", [NSString class]);
//        
//        NSString *score = GETOBJECTFORKEY(expandData, @"score", [NSString class]);
//        self.score = [NSString stringWithFormat:@"%.2f", score.floatValue];
//       
//        
//        self.positionTypeCode = GETOBJECTFORKEY(expandData, @"positionTypeCode", [NSString class]);
//        
//        NSString *latitude = GETOBJECTFORKEY(expandData, @"latitude", [NSString class]);
//        self.latitude = [latitude floatValue];
//        
//        NSString *longitude = GETOBJECTFORKEY(expandData, @"longitude", [NSString class]);
//        self.longitude = [longitude floatValue];
//        
//
//        NSString *wifi = GETOBJECTFORKEY(expandData, @"wifi", [NSString class]);
//        if (wifi) {
//            self.wifi = [wifi integerValue];
//        }
//        NSString *park = GETOBJECTFORKEY(expandData, @"park", [NSString class]);
//        if (park)
//        {
//            self.park = [park integerValue];
//        }
//    }
//    
//    return self;
//}

@end
