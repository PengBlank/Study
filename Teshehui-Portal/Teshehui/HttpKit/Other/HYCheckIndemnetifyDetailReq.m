//
//  HYCheckIndemnetifyDetailReq.m
//  Teshehui
//
//  Created by HYZB on 15/4/2.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCheckIndemnetifyDetailReq.h"

@implementation HYCheckIndemnetifyDetailReq

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/guijiupei/getGuijiupeiDetail.action", kJavaRequestBaseURL];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if (self.indemntify_id)
        {
            [newDic setObject:self.indemntify_id forKey:@"guijiupeiId"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCheckIndemnetifyDetailResq *respose = [[HYCheckIndemnetifyDetailResq alloc]initWithJsonDictionary:info];
    return respose;
}

@end


@implementation HYCheckIndemnetifyDetailResq

- (id)initWithJsonDictionary:(NSDictionary*)dictionary
{
    self = [super initWithJsonDictionary:dictionary];
    
    if (self)
    {
        NSDictionary *data = GETOBJECTFORKEY(dictionary, @"data", [NSDictionary class]);
        
        if ([data count] > 0)
        {
            self.indemnityInfo = [[HYIndemnityinfo alloc] initWithDictionary:data error:nil];
        }
    }
    
    return self;
}

@end