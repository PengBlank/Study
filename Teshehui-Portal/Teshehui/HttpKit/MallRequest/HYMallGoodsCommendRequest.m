//
//  HYMallGoodsCommendRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodsCommendRequest.h"

@implementation HYMallGoodsCommendRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kMallRequestBaseURL, @"api/order/evaluate"];
        self.httpMethod = @"POST";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.order_id length] > 0)
        {
            [newDic setObject:self.order_id forKey:@"order_id"];
        }
        
        if ([self.comment length] > 0)
        {
            NSString *key = [NSString stringWithFormat:@"evaluations[comment]"];
            [newDic setObject:self.comment forKey:key];
        }
        
        if ([self.rec_id length] > 0)
        {
            NSString *key = [NSString stringWithFormat:@"rec_id"];
            [newDic setObject:self.rec_id forKey:key];
        }
        
        if (self.goods_rating > 0)
        {
            NSString *key = [NSString stringWithFormat:@"evaluations[goods]"];
            [newDic setObject:[NSString stringWithFormat:@"%d", self.goods_rating]
                       forKey:key];
        }
        
        if (self.service_rating > 0)
        {
            NSString *key = [NSString stringWithFormat:@"evaluations[service]"];
            [newDic setObject:[NSString stringWithFormat:@"%d", self.service_rating]
                       forKey:key];
        }
        
        if (self.delivery_rating > 0)
        {
            NSString *key = [NSString stringWithFormat:@"evaluations[delivery]"];
            [newDic setObject:[NSString stringWithFormat:@"%d", self.delivery_rating]
                       forKey:key];
        }
        
        int index = 0;
        for (NSData *data in self.imagesData)
        {
            NSString *key = [NSString stringWithFormat:@"evaluations[pics][%d]", index];
            [newDic setObject:data forKey:key];
            index++;
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallGoodsCommendResponse *respose = [[HYMallGoodsCommendResponse alloc]initWithJsonDictionary:info];
    return respose;
}

+ (instancetype)requestWithCommentModel:(HYCommentModel *)model
{
    HYMallGoodsCommendRequest *request = [[HYMallGoodsCommendRequest alloc] init];
    request.order_id = model.goods.orderId;
//    request.rec_id = model.goods.rec_id;
    request.comment = model.comment;
    request.goods_rating = model.desctiptionLevel;
    request.service_rating = model.serviceLevel;
    request.delivery_rating = model.deliverLevel;
    NSMutableArray *imgDatas = [NSMutableArray array];
    for (UIImage *img in model.photos)
    {
        NSData *imgData = UIImageJPEGRepresentation(img, 0.4);
        [imgDatas addObject:imgData];
    }
    
    request.imagesData = imgDatas;
    return request;
}

@end
