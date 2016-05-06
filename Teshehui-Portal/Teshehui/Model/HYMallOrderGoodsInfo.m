//
//  HYMallOrderGoodsInfo.m
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderGoodsInfo.h"

@implementation HYMallOrderGoodsInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super initWithDataInfo:data];
    
    if (self)
    {
        self.order_id = GETOBJECTFORKEY(data, @"order_id", [NSString class]);
        self.cost_price = GETOBJECTFORKEY(data, @"cost_price", [NSString class]);
        self.marketing_price = GETOBJECTFORKEY(data, @"marketing_price", [NSString class]);
        //self.evaluation = GETOBJECTFORKEY(data, @"evaluation", [NSString class]);
        //self.comment = GETOBJECTFORKEY(data, @"comment", [NSString class]);
        self.credit_value = GETOBJECTFORKEY(data, @"credit_value", [NSString class]);
        self.is_valid = [GETOBJECTFORKEY(data, @"is_valid", [NSString class]) boolValue];
        self.evaluable = [GETOBJECTFORKEY(data, @"evaluable", [NSString class]) intValue];
        
        self.indemnityId = GETOBJECTFORKEY(data, @"guijiupei_id", [NSString class]);
        if (self.indemnityId.integerValue > 0)  //有赔付信息的情况
        {
            self.indemnityStatus = HYIndemnified;
        }
        else
        {
            self.indemnityStatus = [GETOBJECTFORKEY(data, @"guijiupei_status", [NSString class]) intValue];
        }
        
        NSArray *commentList = GETOBJECTFORKEY(data, @"evaluation_list", [NSArray class]);
        if (commentList.count > 0) {
            NSDictionary *commentDict = [commentList firstObject];
            HYMallGoodCommentInfo *commentInfo = [[HYMallGoodCommentInfo alloc] initWithDictionary:commentDict error:nil];
            self.commentInfo = commentInfo;
        }
    }
    
    return self;
}

@end
