//
//  HYActivateUserRequest.h
//  Teshehui
//
//  Created by ichina on 14-3-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYBaseRequestParam.h"
#import "HYActivateUserReponse.h"

@interface HYActivateUserRequest : HYBaseRequestParam

@property (nonatomic, copy) NSString *agency_id;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *number_password;
@property (nonatomic, copy) NSString *number_id;
@property (nonatomic, copy) NSString *phone_mob;
@property (nonatomic, copy) NSString *user_name;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *eamil;
@property (nonatomic, copy) NSString *check_code;
@property (nonatomic, copy) NSString *id_card;
@property (nonatomic, copy) NSString *real_name;

@property (nonatomic, copy) NSString *sex;  //性别，M表示男，F表示女-->
@property (nonatomic, assign) NSInteger cardType;  //证件类型，01：身份证 02：护照 03：军人证 05：驾驶证 06：港澳回乡证或台胞证 99：其他。-->
@property (nonatomic, copy) NSString *birthday;  //生日，格式yyyy-MM-dd-->

@property (nonatomic, assign) NSInteger activate_type;

@end
