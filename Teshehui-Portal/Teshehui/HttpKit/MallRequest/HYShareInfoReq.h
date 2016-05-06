//
//  HYShareInfoReq.h
//  Teshehui
//
//  Created by HYZB on 15/8/25.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

/**
 *  分享信息接口
 *  @param  price
 *  @param  type，类型:0订单支付分享，1特币帐单分享，2商品分享，3分享获特币, 7摇一摇分享
 *  @param  user_id
 *  
 *  @return HYShareInfoResp
 *  @result url 链接
 *  @result msg 文字
 */
@interface HYShareInfoReq : CQBaseRequest

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *type;

@end


@interface HYShareInfoResp: CQBaseResponse

@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgurl;

@end