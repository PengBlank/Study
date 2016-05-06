//
//  HYMallOrderReturnRequest.m
//  Teshehui
//
//  Created by RayXiang on 14-9-22.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallOrderReturnRequest.h"
#import "HYMallOrderReturnResponse.h"

@implementation HYMallOrderReturnRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/common/getRemoteService.action?httpUrl=%@/%@", kJavaRequestBaseURL, kMallRequestBaseURL, @"api/order/return_request"];
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
        
        [newDic setObject:[NSNumber numberWithInteger:_refund_type] forKey:@"refund_type"];
        
        if (self.goods_id.length > 0) {
            NSString *key = [NSString stringWithFormat:@"goods[%@]", _goods_id];
            [newDic setObject:[NSNumber numberWithInteger:_return_number] forKey:key];
            
        }
        
        if (self.refund_desc.length > 0) {
            [newDic setObject:_refund_desc forKey:@"refund_desc"];
        }
        
        if (self.attachments.count > 0) {
            NSInteger i = 0;
            for (UIImage *img in _attachments) {
                NSData *data = UIImageJPEGRepresentation(img, .5);
                [newDic setObject:data forKey:[NSString stringWithFormat:@"attachments[%ld]", i]];
                i ++;
            }
        }
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMallOrderReturnResponse *respose = [[HYMallOrderReturnResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
