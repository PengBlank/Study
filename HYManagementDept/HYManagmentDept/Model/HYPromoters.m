//
//  HYPromoters.m
//  HYManagmentDept
//
//  Created by HYZB on 14-9-29.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import "HYPromoters.h"

@implementation HYPromoters

- (id)initWithData:(NSDictionary *)data
{
    if (self = [super init])
    {
        self.code = GETOBJECTFORKEY(data, @"code", [NSString class]);
        self.status = [GETOBJECTFORKEY(data, @"status", [NSString class]) integerValue];
        self.created = GETOBJECTFORKEY(data, @"created", [NSString class]);
        self.real_name = GETOBJECTFORKEY(data, @"real_name", [NSString class]);
        self.number = GETOBJECTFORKEY(data, @"number", [NSString class]);
        self.phone_mob = GETOBJECTFORKEY(data, @"phone_mob", [NSString class]);
        self.proportion = GETOBJECTFORKEY(data, @"proportion", [NSString class]);
        self.m_id = GETOBJECTFORKEY(data, @"id", [NSString class]);
        self.user_id = GETOBJECTFORKEY(data, @"operator_id", [NSString class]);
        
        self.nickname = GETOBJECTFORKEY(data, @"nickname", NSString);
        self.promoters_type = [GETOBJECTFORKEY(data, @"promoters_type", NSString) integerValue];
        self.audit_status = [GETOBJECTFORKEY(data, @"audit_status", NSString) integerValue];
        self.rejection_reason = GETOBJECTFORKEY(data, @"rejection_reason", NSString);
        
        NSArray *imgs = GETOBJECTFORKEY(data, @"img", NSArray);
        if (imgs.count > 0)
        {
            NSMutableArray *imgsget = [NSMutableArray array];
            for (NSString *imginfo in imgs)
            {
                [imgsget addObject:imginfo];
            }
            self.imgURLs = [NSArray arrayWithArray:imgsget];
        }
    }
    
    return self;
}


@end
