//
//  HYUserPortraitRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/5/7.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYUserPortraitRequest.h"

@implementation HYUserPortraitRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"file/userImageUpload.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    
    if (self.portrait)
    {
        NSData *data = UIImageJPEGRepresentation(_portrait, .6);
        [newDic setObject:data forKey:@"userHead"];
    }
    
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYUserPortraitResponse *respose = [[HYUserPortraitResponse alloc]initWithJsonDictionary:info];
    return respose;
}


@end
