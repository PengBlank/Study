//
//  HYDeliverCompanyResponse.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYDeliverCompany.h"

@interface HYDeliverCompanyResponse : CQBaseResponse

@property (nonatomic, strong) NSArray<HYDeliverCompany*> *companyList;

@end
