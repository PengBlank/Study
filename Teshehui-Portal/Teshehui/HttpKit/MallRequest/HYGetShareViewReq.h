//
//  HYGetShareViewReq.h
//  Teshehui
//
//  Created by HYZB on 16/4/6.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"


/**
 H5页面请求
 @param string $token 用户登录的Token
 @param int $type 1:分享赚现金券，（目前只有1，留作扩展用）
 */
@interface HYGetShareViewReq : CQBaseRequest

@property (nonatomic, assign) int type;

@end





@interface HYGetShareViewResp: CQBaseResponse

@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *shareUrl;

@end
