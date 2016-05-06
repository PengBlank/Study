//
//  PTHttpManager.h
//  ContactHub
//
//  Created by ChengQian on 13-3-11.
//  Copyright (c) 2013年 www.putao.cn. All rights reserved.
//

/**
 * 管理与服务器的http请求的单例
 */

#import <Foundation/Foundation.h>

#import "ASINetworkQueue.h"
#import "ASIFormDataRequest.h"

#import "HYBaseRequestParam.h"
#import "HYBaseResponse.h"

typedef void(^RequestCompetionBlock)(NSDictionary *responeInfo);
typedef void(^RequestFailedBlock)(NSError *error);

@interface PTHttpManager : NSObject
{
    ASINetworkQueue *_requsestQueue;
    
    NSInteger _requestTag;  //自增长的请求tag；
    NSMutableDictionary *_requestDic;  //带tag的请求，用来出来cancel
    
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
}

+ (PTHttpManager *)getInstantane;
- (NSInteger)getRequestTag;

/**
 *	@brief	根据请求参数，生成相应的request
 *
 *	@param 	requestPrama 	请求参数的实体
 *
 *	@return	返回request对象。
 */
- (ASIHTTPRequest *)getPostReuqestWithParam:(id)requestParam;

/**
 *	@brief	根据参数发送post请求, 默认的请求是放在请求队列里面，
 *          （不支持cancel，如果需要，使用带tag的请求）
 *	@param 	requestParam 	请求参数的实体
 */
- (void)sendPostRequestWithParam:(HYBaseRequestParam *)requestParam;

/**
 *	@brief	同上，根据tag支持cancel，
 *
 *	@param 	requestParam 	请求参数的实体
 *	@param 	tag 	请求的tag
 */
- (void)sendPostRequestWithParam:(HYBaseRequestParam *)param tag:(NSInteger)tag;

/**
 *	@brief	根据请求参数的tag，取消掉某一个请求
 *
 *	@param 	requestParam 	请求的参数
 */
- (void)cancelRequestWithParamTag:(NSInteger)paramTag;

- (void)cancelAll;
- (void)cleanCache;

@end
