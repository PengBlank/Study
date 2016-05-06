//
//  HYHotelSearchReuqest.m
//  Teshehui
//
//  Created by 回亿资本 on 14-2-7.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYHotelSearchReuqest.h"
#import "HYHotelSearchResponse.h"
#import "JSONKit_HY.h"

@implementation HYHotelSearchReuqest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"product/searchProduct.action"];
        self.httpMethod = @"POST";
        
        _pageSize = 20;
        _pageNo = 1;
        _orderType = DEFAULT;
        _searchType = @"10";
    }
    
    return self;
}

- (void)setCondition:(HYHotelCondition *)condition
{
    _condition = condition;
    //必要的条件
    //城市id
    self.cityId = condition.cityInfo.cityId;
    
    //星级和类型
    //self.hotelStars = self.condition.starLevels;
    
    self.keyword = self.condition.keyword;      //关键字
    
    self.latitude = self.condition.DotX.doubleValue;  //纬度
    self.longitude = self.condition.DotY.doubleValue; //经度
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null] &&
        [self.cityId length] > 0 &&
        [self.startDate length] > 0 &&
        [self.endDate length] > 0)
    {
        //价格
        if (_condition.hotelPrice && _condition.hotelPrice.priceLevel != 0)
        {
            if (_condition.hotelPrice.priceLevel == 6)
            {
                [newDic setObject:@(_condition.hotelPrice.lPrice) forKey:@"lowPrice"];
            }
            else
            {
                [newDic setObject:@(_condition.hotelPrice.lPrice) forKey:@"lowPrice"];
                [newDic setObject:@(_condition.hotelPrice.hPrice) forKey:@"highPrice"];
            }
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageNo]
                   forKey:@"pageNo"];
        [newDic setObject:[NSString stringWithFormat:@"%ld", self.pageSize]
                   forKey:@"pageSize"];
        
        if ([self.keyword length] > 0)
        {
            [newDic setObject:self.keyword forKey:@"keyword"];
        }
        
        
        switch (self.orderType)
        {
            case DEFAULT:
                _order = nil;
                _orderBy = nil;
                break;
            case Price_DESC:
                _order = @"0";
                _orderBy = @"11";
                break;
            case Price_ASC:
                _order = @"1";
                _orderBy = @"11";
                break;
            case Name:
                _orderBy = @"31";
                _order = @"1";
                break;
            default:
                break;
        }
        if (self.order)
        {
            [newDic setObject:self.order forKey:@"order"];
        }
        if (self.orderBy)
        {
            [newDic setObject:self.orderBy forKey:@"orderBy"];
        }
        
        //酒店相关的扩展请求参数
        NSMutableDictionary *expandedRequest = [NSMutableDictionary dictionary];
        
        [expandedRequest setObject:self.cityId forKey:@"cityId"];
        [expandedRequest setObject:self.startDate forKey:@"startDate"];
        [expandedRequest setObject:self.endDate forKey:@"endDate"];
        
        //星级种类
        if (_condition.hotelStars.count > 0)
        {
            NSMutableArray *starArray = [NSMutableArray array];
            for (HYHotelStar *hotelstar in _condition.hotelStars)
            {
                [starArray addObject:@(hotelstar.star)];
            }
            [expandedRequest setObject:starArray forKey:@"hotelStar"];
        }
        if (_condition.hotelTypes.count > 0)
        {
            [expandedRequest setObject:_condition.hotelTypes
                                forKey:@"hotelType"];
        }
        
        //行政商业区
        if (_condition.districtInfo)
        {
            [expandedRequest setObject:_condition.districtInfo.districtId
                                forKey:@"districtId"];
        }
        if (_condition.commercialInfo)
        {
            [expandedRequest setObject:_condition.commercialInfo.downtownId
                                forKey:@"commercialId"];
        }
        
        CGFloat distance = _condition.distance.distance;
        if (_condition.searchNear && distance > 0)
        {
            [expandedRequest setObject:[NSString stringWithFormat:@"%f", distance]
                       forKey:@"distance"];
            [expandedRequest setObject:[NSString stringWithFormat:@"%f", self.latitude]
                       forKey:@"latitude"];
            [expandedRequest setObject:[NSString stringWithFormat:@"%f", self.longitude]
                       forKey:@"longitude"];
        }
        
        if ([expandedRequest count] > 0)
        {
            NSString *expand = [expandedRequest JSONString];
            [newDic setObject:expand forKey:@"expandedRequest"];
        }
        
        if (self.businessType)
        {
            [newDic setObject:self.businessType
                       forKey:@"businessType"];
        }
    }
#ifndef __OPTIMIZE__
    else
    {
        DebugNSLog(@"酒店查询请求缺少必须参数");
    }
#endif
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYHotelSearchResponse *respose = [[HYHotelSearchResponse alloc]initWithJsonDictionary:info];
    return respose;
}

/*
 *{"cityId":1451,
 "cityName":null,
 "positionTypeCode":null,
 "latitude":null,
 "longitude":null,
 "distance":null,
 "districtId":null,
 "commercialId":null,
 "hotelStar":null,
 "hotelType":null}
 */

@end
