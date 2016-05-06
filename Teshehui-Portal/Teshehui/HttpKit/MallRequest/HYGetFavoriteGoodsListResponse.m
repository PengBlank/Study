//
//  HYGetFavoriteGoodsListResponse.m
//  Teshehui
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYGetFavoriteGoodsListResponse.h"
#import "HYMallFavouriteItem.h"

@implementation HYGetFavoriteGoodsListResponse

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        NSArray *items = GETOBJECTFORKEY(data, @"items", NSArray);
        self.goodsList = [HYMallFavouriteItem arrayOfModelsFromDictionaries:items];
    }
    
    return self;
}

@end
