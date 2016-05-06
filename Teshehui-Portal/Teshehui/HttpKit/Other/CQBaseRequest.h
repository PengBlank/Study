//
//  CQBaseRequest.h
//  Teshehui
//
//  Created by ChengQian on 13-11-15.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "CQBaseResponse.h"
#import "HYRequestParams.h"

typedef enum _POSTDATATYPE{
    KeyValue = 1,
    JSON
}POSTDATATYPE;

typedef enum _INTERFACETYPE{
    PHP = 1,
    JAVA = 2,
    DotNET = 3,
    DotNET2
}INTERFACETYPE;

typedef void(^RequestResult)(id result, NSError *error);

@interface CQBaseRequest : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic, copy) NSString *httpMethod;  //http请求的方式：POST/GET
@property (nonatomic, copy) NSString *interfaceURL;  //接口地址
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) POSTDATATYPE postType;  //post的数据格式
@property (nonatomic, assign) INTERFACETYPE interfaceType;  //接口的类型，校验方式不同
@property (nonatomic, copy) NSString *imei;
@property (nonatomic, copy) NSString *app_key;
@property (nonatomic, copy) NSString *timestamp;
@property (nonatomic, copy) NSString *app_from;
@property (nonatomic, copy) NSString *signature;

@property (nonatomic, copy) NSString *javaSignature;
@property (nonatomic, copy) NSString *javaTimestamp;
@property (nonatomic, copy) NSString *clientType;
@property (nonatomic, copy) NSString *clientVersion;
@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *userId;

@property (nonatomic, assign) BOOL repIsJsonData;  //返回的response默认为json格式数据

@property (nonatomic, strong) HYRequestParams *requestParams;


/**
 *  发送请求
 *  
 *  @param result
 */- (void)sendReuqest:(RequestResult)result;

/**
 *  取消请求
 *  在发送请求的对象的dealloc时候最好调用该方法
 */
- (void)cancel;

/**
 *  请求成功的callback
 *  该方法仅在httpmanager 对象里面调用
 *  @param requestFailedCallback 成功返回的responge
 */
- (void)requestCompletionCallback:(NSString *)response;
/**
 *  请求失败的callback
 *  该方法仅在httpmanager 对象里面调用
 *  @param error 失败返回的错误
 */
- (void)requestFailedCallback:(NSError *)error;

//获得参数JSON字典, 主要为新版本java服务器的加密处理， 该方法仅在httpmanager 对象里面调用
- (NSMutableDictionary *)getJsonDictionary;

//组装data数据域，转为json字符串传递，该方法仅在httpmanager 对象里面调用
- (NSMutableDictionary *)getDataDictionary;

@end
