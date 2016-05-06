//
//  HYInactiveSingleMigrateParam.h
//  HYManagmentDept
//
//  Created by HYZB on 14-9-30.
//  Copyright (c) 2014年 回亿资本. All rights reserved.
//

//单张中心下会员卡未激活未关联推广员的会员卡转移

#import "HYBaseRequestParam.h"
#import "HYInactiveSingleMigrateResponse.h"

@interface HYInactiveSingleMigrateParam : HYBaseRequestParam

@property (nonatomic, copy) NSString *card_number; //会员卡号
@property (nonatomic, copy) NSString *user_id;  //操作员会员ID

@end


/*
 card_number	INT	会员卡号
 user_id	INT	操作员会员ID
*/