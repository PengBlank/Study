//
//  HYCradSummaryInfo.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYCardSummaryInfo : NSObject

@property (nonatomic, strong) NSString *card_id;  //会员卡ID
@property (nonatomic, strong) NSString *number;  //应收款

- (id)initWithData:(NSDictionary *)data;

@end
