//
//  HYActivateInfo.h
//  Teshehui
//
//  Created by ichina on 14-3-1.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYPolicyType.h"

@interface HYActivateInfo : JSONModel


@property (nonatomic, copy) NSString *active_time;

@property (nonatomic, copy) NSString *agency_id;

@property (nonatomic, copy) NSString *company_id;

@property (nonatomic, copy) NSString *deadline;

@property (nonatomic, copy) NSString *Activateid;

@property (nonatomic, copy) NSString *memberCardId;

@property (nonatomic, copy) NSString *memberCardNumber;

@property (nonatomic, copy) NSString *memberCardPassword;

@property (nonatomic, copy) NSString *phone_mob;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *policyType;

@property (nonatomic, copy) NSString *insuranceTypeCode;

@property (nonatomic, copy) NSString *insuranceTypeName;

@property (nonatomic, copy) NSString *insuranceProvision;

@end
/*
 {
 "active_time" = 0;
 "agency_id" = 1;
 "company_id" = 1;
 deadline = 1400256000;
 id = 430;
 "member_id" = "<null>";
 number = 000000007897;
 password = 123456;
 "phone_mob" = 13113178211;
 status = 0;
 }

*/