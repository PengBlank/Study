//
//  HYDeliverCompanyListRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYDeliverCompanyListRequest.h"

@implementation HYDeliverCompanyListRequest
- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"afterSeller/getDeliveryCompanyList.action"];
        self.httpMethod = @"POST";
        self.businessType = @"01";
    }
    
    return self;
}


- (CQBaseResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYDeliverCompanyResponse *respose = [[HYDeliverCompanyResponse alloc]initWithJsonDictionary:info];
    return respose;
}
@end
