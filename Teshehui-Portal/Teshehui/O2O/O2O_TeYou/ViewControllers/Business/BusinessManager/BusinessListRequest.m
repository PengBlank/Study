//
//  BusinessListRequest.m
//  Teshehui
//
//  Created by apple_administrator on 15/8/26.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "BusinessListRequest.h"

@implementation BusinessListRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    [newDic removeAllObjects];
    
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (_cityName.length > 0)
        {
            [newDic setObject:[NSString stringWithFormat:@"%@", self.cityName]
                       forKey:@"City"];
        }
        
        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.pageIndex)]
                   forKey:@"pageIndex"];
        [newDic setObject:[NSString stringWithFormat:@"%@", @(self.pageSize)]
                   forKey:@"pageSize"];
        if (_latitude.length > 0)
        {
            [newDic setObject:_latitude forKey:@"Latitude"];
        }
        if (_lontitude)
        {
            [newDic setObject:_lontitude forKey:@"Longitude"];
        }

        else
        {
            
        }
        [newDic setObject:@(_AreaId) forKey:@"AreaId"];
        [newDic setObject:@(_CategoryId) forKey:@"CategoryId"];

//        if(_sortType == 2){
//            _sortType = 1;
//        }else{
//            _sortType = 0;
//        }
        //排序
        [newDic setObject:[NSString stringWithFormat:@"%@", @(_sortType)] forKey:@"sortType"];
    }
    return newDic;
}

//- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
//{
//    BusinessListResponse *respose = [[BusinessListResponse alloc]initWithJsonDictionary:info];
//    return respose;
//}


@end
