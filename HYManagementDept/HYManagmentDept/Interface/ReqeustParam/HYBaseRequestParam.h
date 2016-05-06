//
//  HYBaseRequest.h
//  HYManagmentDept
//
//  Created by 回亿资本 on 14-5-9.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

/*
 * 接口请求的参数base
 */

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "HYBaseResponse.h"

typedef enum _POSTDATATYPE{
    KeyValue = 1,
    JSON
}POSTDATATYPE;

typedef void(^RequestResult)(id result, NSError *error);

@interface HYBaseRequestParam : NSObject

@property (nonatomic, copy) NSString *httpMethod;  //http请求的方式：POST/GET
@property (nonatomic, copy) NSString *interfaceURL;  //接口地址
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) POSTDATATYPE postType;  //post的数据格式

@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *app_key;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *app_from;
@property (nonatomic, copy) NSString *signature;

//获得参数JSON字典
//如果参数字典中已有参数，将会清除原来的参数，重新装入所有参数
- (NSMutableDictionary *)getJsonDictionary;

//统一的返回数据
- (HYBaseResponse *)getResponseWithInfo:(NSDictionary *)info;

- (void)requestCompletionCallback:(NSString *)response;
- (void)requestFailedCallback:(NSError *)error;

//sendreuqset
- (void)sendReuqest:(RequestResult)result;

- (void)cancel;

@end
