//
//  HYGetPolicyListRequest.h
//  Teshehui
//
//  Created by Kris on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYGetPolicyListRequest : CQBaseRequest

/*
 1：激活会员卡
 
 2：虚拟会员升级
 
 3：在线购卡
 
 4：续费
 
 注：不传则返回全部
 */

@property (nonatomic, copy) NSString *type;

@end
