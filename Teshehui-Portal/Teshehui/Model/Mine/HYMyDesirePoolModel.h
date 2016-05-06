//
//  HYMyDesirePoolModel.h
//  Teshehui
//
//  Created by HYZB on 15/11/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMyDesirePoolModel : JSONModel

@property (nonatomic, assign) NSInteger d_id;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *contactName;
@property (nonatomic, copy) NSString *contactMobile;
@property (nonatomic, copy) NSString *wishTitle;
@property (nonatomic, copy) NSString *wishContent;
@property (nonatomic, copy) NSString *wishTime;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *statusStr;
@property (nonatomic, copy) NSString *createTime;

@end
