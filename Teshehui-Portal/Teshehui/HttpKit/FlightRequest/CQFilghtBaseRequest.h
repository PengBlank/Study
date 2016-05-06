//
//  CQFilghtBase.h
//  ComeHere
//
//  Created by ChengQian on 13-11-12.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import "CQBaseRequest.h"

@interface CQFilghtBaseRequest : CQBaseRequest

@property (nonatomic, copy) NSString *httpMethod;  //http请求的方式：POST/GET
@property (nonatomic, copy) NSString *interfaceURL;  //接口地址

@end
