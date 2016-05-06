//
//  HYAgencyCountRequest.h
//  HYManagmentDept
//
//  Created by apple on 15/1/7.
//  Copyright (c) 2015年 回亿资本. All rights reserved.
//

#import "HYRowDataRequest.h"
#import "HYAgencyCountResponse.h"

@interface HYAgencyCountRequest : HYRowDataRequest

@property (nonatomic, strong) NSString *agency_name;


@end
