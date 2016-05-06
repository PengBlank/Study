//
//  CQUserInfo.h
//  Teshehui
//
//  Created by ChengQian on 13-11-16.
//  Copyright (c) 2013年 Charse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CQResponseResolve.h"
#import "HYPolicy.h"
#import "HYImageInfo.h"


 /** 用户类型普通会员 */
//"user_type_member", "0");
/** 用户类型商户 */
//"user_type_merchant", "1");
/** 用户类型企业 */
//"user_type_enterprise", "2");
/** 用户类型企业员工 */
//"user_type_enterprise_member", "21");
/** 用户类型运营系统管理公司 */
//"user_type_operate_company", "30");
/** 用户类型运营系统管理公司员工 */
//"user_type_operate_company_member", "31");
/** 用户类型运营系统管理公司运营中心 */
//"user_type_operate_company_center", "32");
/** 用户类型运营系统管理公司运营中心员工 */
//"user_type_operate_company_center_member", "33");
/** 用户类型运营系统管理公司运营中心操作员 */
//"user_type_operate_company_center_operator", "34");


typedef enum _HYUserType
{
    Normal_User = 0,  //普通用户
    Store_User = 1,  //商户
    Enterprise_User = 2,  //企业用户
    Enterprise_Member = 21,
    Operate_Company = 30,
    Operate_Company_Member = 31,
    Operate_Company_Center = 32,
    Operate_Company_Center_Member = 33,
    Operate_Company_Center_Operator = 34
}HYUserType;

@interface HYUserInfo : JSONModel

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *nickName; //昵称
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *birthday;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *certificateCode;
@property (nonatomic, copy) NSString *certificateName;
@property (nonatomic, copy) NSString *certificateNumber;
@property (nonatomic, copy) NSString *mobilePhone;

@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *lastLoginTime;
@property (nonatomic, copy) NSString *promotersId;
@property (nonatomic, copy) NSString *promotersUserId;
@property (nonatomic, copy) NSString *isCompany;
@property (nonatomic, copy) NSString* isAgency;
@property (nonatomic, copy) NSString* idAuthentication;  //是否为认证会员
@property (nonatomic, copy) NSString* token;
@property (nonatomic, copy) NSString* portrait;
@property (nonatomic, copy) NSString* enterpriseId;  //该字段只能判断为企业员工和非企业员工
@property (nonatomic, assign) NSInteger userLevel;  //为0则为试用用户

@property (nonatomic, assign) HYUserType userType;  //type只能判断为普通用户或者企业用户，无法用来判定是否为企业员工
@property (nonatomic, strong) HYPolicy *insurancePolicy;

@property (nonatomic, strong) HYImageInfo *userLogo;

/// 性别，本地性别，由服务器性别自动转换。
@property (nonatomic, strong) NSString* sex;

/// 本地性别，区别服务器性别，服务器使用0和1表示，或者用m,f给示，app内使用枚举变量表示
@property (nonatomic, assign) HYUserInfoSex localSex;


- (void)saveData;
+ (HYUserInfo *)getUserInfo;
- (void)updateUserInfo;

//- (NSString *)portrait;

@end

/*
 userId:		用户id;
 userName:	用户名;
 email:		电子邮箱;
 password:	用户密码;
 realName:	真实姓名;
 gender:		性别;
 birthday:	出生日期;
 number:		会员卡号;
 cardType:	证件类型 01：身份证 02：护照 03：军人证 05：驾驶证 06：港澳回乡证或台胞证 99：其他;
 idCard:		证件号码;
 phoneMob:	手机号码;
 points:		现金券数量;
 lastLoginTime:最后登录时间;
 lastLoginIP:	最后登录IP;
 promotersId:	推广员邀请码ID;
 enterpriseId:	归属哪个企业用户;
 promotersUserId:推广员会员ID;
 isCompany:			是否为管理公司账户;
 isAgency:				是否为票务中心账户;
 token:					登录TOKEN;
 */
