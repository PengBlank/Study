//
//  HYMallOrderItem.m
//  Teshehui
//
//  Created by HYZB on 15/5/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYMallOrderItem.h"

@implementation HYMallOrderItem

+ (BOOL)propertyIsOptional:(NSString *)propertyName {
    return YES;
}

- (id)initWithDataInfo:(NSDictionary *)data
{
    if (self = [super init])
    {
        self.pictureBigUrl = GETOBJECTFORKEY(data, @"goods_image", NSString);
        self.pictureMiddleUrl = GETOBJECTFORKEY(data, @"middle_goods_image", NSString);
        self.orderItemId = GETOBJECTFORKEY(data, @"rec_id", NSString);
        self.productName = GETOBJECTFORKEY(data, @"goods_name", NSString);
        self.specification = GETOBJECTFORKEY(data, @"specification", NSString);
        self.points = GETOBJECTFORKEY(data, @"points", NSString);
        self.price = GETOBJECTFORKEY(data, @"price", NSString);
        self.quantity = [GETOBJECTFORKEY(data, @"quantity", NSString) integerValue];
        self.productCode = GETOBJECTFORKEY(data, @"goods_id", NSString);
        NSArray *comments = [data objectForKey:@"evaluationPOList"];
        if (comments.count > 0)
        {
            self.commentInfo = [[HYMallGoodCommentInfo alloc] initWithOrderInfo:comments[0]];
        }
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    if (self = [super initWithDictionary:dict error:err])
    {
        NSArray *comments = [dict objectForKey:@"evaluationPOList"];
        if (comments.count > 0)
        {
            self.commentInfo = [[HYMallGoodCommentInfo alloc] initWithOrderInfo:comments[0]];
        }
    }
    return self;
}

- (HYIndemnityStatus)isCanApplyGuijiupei
{
    if ([_guijiupeiId intValue] > 0)
    {
        return HYIndemnified;
    }
    else
    {
        return _isCanApplyGuijiupei;
    }
}

+ (JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc]
            initWithDictionary:@{@"specifications": @"specification"}];
                            
}

@end
