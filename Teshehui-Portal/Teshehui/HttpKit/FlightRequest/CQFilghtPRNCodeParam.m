//
//  CQFilghtPRNCodeParam.m
//  ComeHere
//
//  Created by ChengQian on 13-11-27.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQFilghtPRNCodeParam.h"
#import "CQFilghtPRNCodeResponse.h"

@implementation CQFilghtPRNCodeParam

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = @"http://app.bnx6688.com/airpnr/";
        self.httpMethod = @"POST";
        
        //固定值
        self.uid = @"bnxapp";
        self.key = @"8g92f8e0-65b9-45aa-a2d2-1c4b9e2bd587";
    }
    
    return self;
}


- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null])
    {
        if ([self.uid length] > 0)
        {
            [newDic setObject:self.uid
                       forKey:@"uid"];
        }
        
        if ([self.key length] > 0)
        {
            [newDic setObject:self.key
                       forKey:@"key"];
        }
        
        NSString *r = [self.routes routeString];
        if ([r length] > 0)
        {
            [newDic setObject:r
                       forKey:@"Routes"];
        }
        
        NSMutableArray *mupass = [[NSMutableArray alloc] init];
        for (CQPassengers *p in self.passengers)
        {
            NSString *pstr = [p getPRNCondeString];
            
            if ([pstr length] > 0)
            {
                [mupass addObject:pstr];
            }
        }
        NSString *p = [mupass componentsJoinedByString:@"$"];
        if ([p length] > 0)
        {
            [newDic setObject:p
                       forKey:@"passengers"];
        }
        
        if (self.officeid)
        {
            [newDic setObject:self.officeid
                       forKey:@"officeid"];
        }
        
        if (self.osimobile)
        {
            [newDic setObject:self.osimobile
                       forKey:@"osimobile"];
        }
    }
    return newDic;
}

- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    CQFilghtPRNCodeResponse *respose = [[CQFilghtPRNCodeResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
