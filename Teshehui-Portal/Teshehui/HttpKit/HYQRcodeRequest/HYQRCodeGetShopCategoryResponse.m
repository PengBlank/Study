//
//  HYQRCodeGetShopCategoryResponse.m
//  Teshehui
//
//  Created by Kris on 15/7/1.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYQRCodeGetShopCategoryResponse.h"

@implementation HYQRCodeGetShopCategory

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation HYQRCodeGetShopCategoryResponse

- (id)initWithJsonDictionary:(NSDictionary *)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        HYQRCodeGetShopCategory *cate = [[HYQRCodeGetShopCategory alloc]initWithDictionary:data error:nil];
        if (cate)
        {
            _shopCateList = cate.items;
        }
    }
    
    return self;
}
@end
