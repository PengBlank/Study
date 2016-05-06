//
//  HYMallGoodsCommendRequest.m
//  Teshehui
//
//  Created by HYZB on 14-9-18.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodsCommentRequest.h"
#import "HYUserInfo.h"

@implementation HYMallGoodsCommentRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"comment/addProductComment.action"];
        self.httpMethod = @"POST";
        self.businessType = BusinessType_Mall;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        NSString *userName = [HYUserInfo getUserInfo].realName;
        if (!userName) {
            userName = [HYUserInfo getUserInfo].mobilePhone;
        }
        if (userName)
        {
            [newDic setObject:userName forKey:@"userName"];
        }
        // 假数据
      //  NSString *userName = @"test";
      //  [newDic setObject:userName forKey:@"userName"];
        
        if ([self.orderCode length] > 0)
        {
           // NSString *key = [NSString stringWithFormat:@"comment"];
            [newDic setObject:self.orderCode forKey:@"orderCode"];
        }
        
        if ([self.productCode length] > 0)
        {
           // NSString *key = [NSString stringWithFormat:@"orderProductId"];
            [newDic setObject:self.productCode forKey:@"productCode"];
        }
        
        if (self.productSkuCode.length > 0)
        {
           // NSString *key = [NSString stringWithFormat:@"productId"];
            [newDic setObject:self.productSkuCode forKey:@"productSkuCode"];
        }
        
        if (self.isReplyComment.length > 0)
        {
           // NSString *key = [NSString stringWithFormat:@"productScore"];
            [newDic setObject:self.isReplyComment
                       forKey:@"isReplyComment"];
        }
        
        if (self.productScore.length > 0)
        {
           // NSString *key = [NSString stringWithFormat:@"serviceScore"];
            [newDic setObject:self.productScore
                       forKey:@"productScore"];
        }
        
        if (self.serviceScore.length > 0)
        {
           // NSString *key = [NSString stringWithFormat:@"deliveryScore"];
            [newDic setObject:self.serviceScore
                       forKey:@"serviceScore"];
        }
        
        if (self.deliveryScore.length > 0)
        {
            [newDic setObject:self.deliveryScore forKey:@"deliveryScore"];
        }
        
        if (self.comment)
        {
            [newDic setObject:self.comment forKey:@"comment"];
        }
        
        if (self.isAnonymous.length > 0)
        {
            [newDic setObject:self.isAnonymous forKey:@"isAnonymous"];
        }
        
        if (self.rltId.length > 0)
        {
            [newDic setObject:self.rltId forKey:@"rltId"];
        }
        // 上传图片
        if (self.uploadfile.count > 0)
        {
            NSMutableArray *array = [NSMutableArray array];
            [self.uploadfile enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = UIImageJPEGRepresentation(obj, .5);
                NSDictionary *dict = @{@"uploadfile": imageData};
                [array addObject:dict];
            }];
            
            [newDic setObject:array forKey:@"uploadfile"];
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCommentAddSecondStepResponse *respose = [[HYCommentAddSecondStepResponse alloc]initWithJsonDictionary:info];
    return respose;
}

// 售后服务曾经使用过，目前售后服务没有评论功能
+ (instancetype)requestWithCommentModel:(HYCommentModel *)model
{
    HYMallGoodsCommentRequest *request = [[HYMallGoodsCommentRequest alloc] init];
//    request.order_id = model.goods.orderId;
//    request.product_id = model.goods.productCode;
//    request.rec_id = model.goods.orderItemId;
//    request.comment = model.comment;
//    request.goods_rating = model.desctiptionLevel;
//    request.service_rating = model.serviceLevel;
//    request.delivery_rating = model.deliverLevel;
    NSMutableArray *imgDatas = [NSMutableArray array];
    for (UIImage *img in model.photos)
    {
        if ([img isKindOfClass:[UIImage class]])
        {
            NSData *imgData = UIImageJPEGRepresentation(img, 0.4);
            NSDictionary *dic = [NSDictionary dictionaryWithObject:imgData
                                                            forKey:@"commentPicArray"];
            [imgDatas addObject:dic];
        }
    }
    
//    request.imagesData = imgDatas;
    return request;
}

@end
