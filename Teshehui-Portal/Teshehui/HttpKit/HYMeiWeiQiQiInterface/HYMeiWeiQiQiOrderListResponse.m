//
//  HYMeiWeiQiQiOrderListResponse.m
//  Teshehui
//
//  Created by HYZB on 15/12/26.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMeiWeiQiQiOrderListResponse.h"
#import "HYMeiWeiQiQiOrderListModel.h"
#import "HYMeiWeiQiQiOrderListModel.h"

@implementation HYMeiWeiQiQiOrderListResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *dict = GETOBJECTFORKEY(dictionary, @"data", dictionary);
        NSArray *arr = GETOBJECTFORKEY(dict, @"items", NSArray);
        self.orders = [HYMeiWeiQiQiOrderListModel arrayOfModelsFromDictionaries:arr];
    }
    
    return self;
}


@end
