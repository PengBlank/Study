//
//  HYAboutRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-11.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

typedef enum _GetInfoWebLinkType
{
    HelpInfo = 1,
    Introduction,
    CoyprightInfo,
    AttentionInfo,
    InsuranceInfo,
    RealnameConfirm,
    InviteCodeInfo
}GetInfoWebLinkType;

@interface HYGetWebLinkRequest : CQBaseRequest

@property(nonatomic, assign) GetInfoWebLinkType type;
@property(nonatomic, copy) NSString *cardNum;

@end
