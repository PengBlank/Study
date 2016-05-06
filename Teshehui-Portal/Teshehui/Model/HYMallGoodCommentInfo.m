//
//  HYMallGoodCommentInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodCommentInfo.h"

@implementation HYMallGoodCommentInfo

+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"id": @"m_id",
                                 @"productId": @"goods_id",
                                 @"orderItemId": @"order_goods_id",
                                 @"orderId": @"order_id",
                                 @"userId": @"user_id",
                                 @"userName": @"user_name",
                                 @"productSKUDescription" : @"goods_spec_name",
                                 @"productScore": @"goods_score",
                                 @"serviceScore": @"service_score",
                                 @"deliveryScore": @"delivery_score",
                                 @"createdTime": @"created",
                                 @"commentPicArray": @"pics",
                                 @"commentReplayArray": @"replies"}];
//    return [[JSONKeyMapper alloc] i];
}

- (instancetype)initWithOrderInfo:(NSDictionary *)info
{
    if (self = [super initWithDictionary:info error:nil])
    {
        self.goods_spec_name = GETOBJECTFORKEY(info, @"specification", NSString);
        NSArray *imgs = GETOBJECTFORKEY(info, @"pictrueUrlList", NSArray);
//        NSMutableArray *getimgs = [NSMutableArray array];
//        for (NSDictionary *imginfo in imgs)
//        {
//            NSString *imgurl = [imginfo objectForKey:@"image"];
//            [getimgs addObject:imgurl];
//        }
        self.pics = imgs;
    }
    return self;
}

//- (id)initWithDataInfo:(NSDictionary *)data
//{
//    self = [super init];
//    
//    if (self)
//    {
//        self.m_id = GETOBJECTFORKEY(data, @"id", [NSString class]);
//        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
//        self.user_name = GETOBJECTFORKEY(data, @"user_name", [NSString class]);
//        self.goods_id = GETOBJECTFORKEY(data, @"goods_id", [NSString class]);
//        self.order_id = GETOBJECTFORKEY(data, @"order_id", [NSString class]);
//        self.order_goods_id = GETOBJECTFORKEY(data, @"order_goods_id", [NSString class]);
//        self.goods_name = GETOBJECTFORKEY(data, @"goods_name", [NSString class]);
//        self.goods_spec_name = GETOBJECTFORKEY(data, @"goods_spec_name", [NSString class]);
//        self.goods_score = [GETOBJECTFORKEY(data, @"goods_score", [NSString class]) integerValue];
//        self.service_score = [GETOBJECTFORKEY(data, @"service_score", [NSString class]) integerValue];
//        self.delivery_score = [GETOBJECTFORKEY(data, @"delivery_score", [NSString class]) integerValue];
//        self.comment = GETOBJECTFORKEY(data, @"comment", [NSString class]);
//        self.pics = GETOBJECTFORKEY(data, @"pics", [NSArray class]);
//        self.is_anonymous = [GETOBJECTFORKEY(data, @"is_anonymous", [NSString class]) boolValue];
//        self.created = GETOBJECTFORKEY(data, @"created", [NSString class]);
//        NSArray *replies = GETOBJECTFORKEY(data, @"replies", [NSArray class]);
//        NSMutableArray *repliesArray = [NSMutableArray array];
//        if (replies.count > 0) {
//            for (NSDictionary *repliDict in replies)
//            {
//                HYMallGoodCommentInfo *replyComment = [[HYMallGoodCommentInfo alloc] initWithDataInfo:repliDict];
//                [repliesArray addObject:replyComment];
//            }
//        }
//        self.replies = [NSArray arrayWithArray:repliesArray];
//    }
//    
//    return self;
//}
@end

/*
 {
 "buyer_id": "49",
 "buyer_name": "test",
 "evaluation_time": "1391988783",
 "comment": "还可以\r\n",
 "evaluation": "1",
 "rec_id": "47"
 },
 */