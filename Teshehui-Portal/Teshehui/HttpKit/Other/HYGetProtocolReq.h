//
//  HYGetProtocolReq.h
//  Teshehui
//
//  Created by HYZB on 15/4/28.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

/*
 *获取各种协议的文案
 */

#import "CQBaseRequest.h"

@interface HYGetProtocolReq : CQBaseRequest

//必须字段
//文案键值，多个用逗号分开
//fake 假一赔十三
//guijiupei 贵就赔
//lightning 闪电退
//official 细则详见官方公告
//meituan_tips 团购订单不支持赠送现金券
//flower_tips 鲜花弹出温馨提示

@property (nonatomic, copy) NSString *copywriting_key;

//可选字段

@end


@interface HYGetProtocolResp : CQBaseResponse

@property (nonatomic, copy) NSString *fake;
@property (nonatomic, copy) NSString *guijiupei;
@property (nonatomic, copy) NSString *lightning;
@property (nonatomic, copy) NSString *official;
@property (nonatomic, copy) NSString *meituan_tips;
@property (nonatomic, copy) NSString *flower_tips;
@property (nonatomic, copy) NSString *user_agreement;

@property (nonatomic, strong) NSString *resTips;

- (id)initWithJsonDictionary:(NSDictionary *)dictionary inputKey:(NSString *)key;

@end
