//
//  HYMakeWishPoolDeclareRequest.m
//  Teshehui
//
//  Created by HYZB on 16/3/30.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "HYMakeWishPoolDeclareRequest.h"
#import "HYMakeWishPoolDeclareResponse.h"

@interface HYMakeWishPoolDeclareRequest ()

@property (nonatomic, copy) NSString *copywriting_key;

@end

@implementation HYMakeWishPoolDeclareRequest

- (id)init
{
    self = [super init];
    if (self) {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kMallRequestBaseURL,@"api/default/get_copywriting"];
        self.httpMethod = @"POST";
    }
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    self.copywriting_key = @"b5m_tips";
    [newDic setObject:self.copywriting_key forKey:@"copywriting_key"];
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYMakeWishPoolDeclareResponse *response = [[HYMakeWishPoolDeclareResponse alloc] initWithJsonDictionary:info];
    return response;
}

@end
