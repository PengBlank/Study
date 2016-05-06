//
//  HYGetFunctionModuleTipsRequest.h
//  Teshehui
//
//  Created by HYZB on 15/12/28.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseRequest.h"

@interface HYGetFunctionModuleTipsRequest : CQBaseRequest

@property (nonatomic, copy) NSString *moduleCode;

@end


@interface HYGetFunctionModuleTipsResponse : CQBaseResponse

@property (nonatomic, copy) NSString *mwqq_tips;

@end
