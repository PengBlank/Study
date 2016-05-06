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

#import "CQBaseRequest.h"

typedef void(^RequestCompetionBlock)(NSDictionary *responeInfo);
typedef void(^RequestFailedBlock)(NSError *error);

@interface PTHttpManager : NSObject
{
    NSInteger _requestTag;  //自增长的请求tag；
    NSMutableDictionary *_requestDic;  //带tag的请求，用来出来cancel
}

@property (nonatomic, readonly, copy) NSString *appKey;

+ (PTHttpManager *)getInstantane;
- (NSInteger)getRequestTag;

/**
 *	@brief	根据参数发送post请求, 默认的请求是放在请求队列里面，如果需要单独的请求使用sendPostRequestWithoutQueue:
 *          （不支持cancel，如果需要，使用带tag的请求）
 *	@param 	requestParam 	请求参数的实体
 */
- (void)sendPostRequestWithParam:(CQBaseRequest *)requestParam;

/**
 *	@brief	同上，根据tag支持cancel，
 *
 *	@param 	requestParam 	请求参数的实体
 *	@param 	tag 	请求的tag
 */
- (void)sendPostRequestWithParam:(CQBaseRequest *)param tag:(NSInteger)tag;

/**
 *	@brief	根据请求参数的tag，取消掉某一个请求
 *
 *	@param 	requestParam 	请求的参数
 */
- (void)cancelRequestWithParamTag:(NSInteger)paramTag;


- (NSString *)timestamp;

/**
 * 获取签名
 */
- (NSString *)getSigantureWittTimestpamp:(NSString *)timeStamp;

/**
 *  @brief 将普通的URL进行参数花，用于发送给后台
 *
 *  @param URL url
 *
 *  @return url after signed
 */
- (NSString *)signWithURL:(NSString *)URL;

- (void)cancelAll;
- (void)cleanCache;

@end
