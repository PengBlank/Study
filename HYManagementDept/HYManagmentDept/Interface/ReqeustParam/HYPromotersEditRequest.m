//
//  HYPromotersEditRequest.m
//  HYManagmentDept
//
//  Created by apple on 15/4/23.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYPromotersEditRequest.h"

@implementation HYPromotersEditRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kRequestBaseURL, @"users/edit_promoters"];
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
        if ([self.operator_id length] > 0) {
            
            [newDic setObject:self.operator_id forKey:@"operator_id"];
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
    HYPromotersEditResponse *respose = [[HYPromotersEditResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
