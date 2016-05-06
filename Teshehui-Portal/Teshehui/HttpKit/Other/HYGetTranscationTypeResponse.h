//
//  HYGetTranscationTypeResponse.h
//  Teshehui
//
//  Created by Kris on 15/7/21.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"

@interface HYBusinessType : JSONModel

@property (nonatomic, copy) NSString *businessTypeCode;
@property (nonatomic, copy) NSString *businessTypeName;
@property (nonatomic, copy) NSString *isBusinessTypeOpen;
@property (nonatomic, copy) NSString *businessTypeStatusMsg;


@end

@interface HYGetTranscationTypeResponse : CQBaseResponse

@property (nonatomic, strong) NSArray *supportTypes;

@end
