//
//  HYPromotersAddRequest.m
//  HYManagmentDept
//
//  Created by RayXiang on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromotersAddRequest.h"

@implementation HYPromotersAddRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/promoters_adding"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.number length] > 0) {
            
            [newDic setObject:self.number forKey:@"number"];
        }
        if ([self.code length] > 0) {
            
            [newDic setObject:self.code forKey:@"code"];
        }
        if ([self.tel length] > 0) {
            
            [newDic setObject:self.tel forKey:@"tel"];
        }
        if (self.nickname.length > 0)
        {
            [newDic setObject:_nickname forKey:@"nickname"];
        }
        if (self.imgs.count > 0)
        {
            for (int i = 0; i < _imgs.count; i++)
            {
                NSString *key = [NSString stringWithFormat:@"img[%d]", i];
                UIImage *img = [_imgs objectAtIndex:i];
                NSData *imgdata = UIImageJPEGRepresentation(img, .4);
                [newDic setObject:imgdata forKey:key];
            }
        }
        [newDic setObject:@(_promoters_type) forKey:@"promoters_type"];
    }
    
    return newDic;
}

- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYPromotersAddResponse *respose = [[HYPromotersAddResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
