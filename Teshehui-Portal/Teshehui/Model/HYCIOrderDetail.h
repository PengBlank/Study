//
//  HYCIOrderDetail.h
//  Teshehui
//
//  Created by HYZB on 15/7/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYCICarInfo.h"
#import "HYCIPersonInfo.h"
#import "HYCIDeliverInfo.h"



@interface  HYCIInsuranceOrderInfo: JSONModel

@property (nonatomic, copy) NSString *bizPolicyNo;
@property (nonatomic, copy) NSString *bizBeginDate;
@property (nonatomic, copy) NSString *forceBeginDate;
@property (nonatomic, copy) NSString *bizEndDate;
@property (nonatomic, copy) NSString *forceEndDate;
@property (nonatomic, copy) NSString *standardPremium;
@property (nonatomic, copy) NSString *totalPremium;
@property (nonatomic, copy) NSString *productTypeName;

@end

@interface HYCIOrderDetail : JSONModel

@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderCode;
@property (nonatomic, copy) NSString *orderStatus;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) NSString *orderTotalAmount;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) BOOL isNeedCheckCode;
@property (nonatomic, copy) NSString *sessionId;

@property (nonatomic, strong) HYCIPersonInfo *ownerInfo;
@property (nonatomic, strong) HYCICarInfo *carInfo;
@property (nonatomic, strong) HYCIInsuranceOrderInfo *insuranceInfo;
@property (nonatomic, strong) HYCIPersonInfo *insuredInfo;
@property (nonatomic, strong) HYCIPersonInfo *applicantInfo;
@property (nonatomic, strong) HYCIDeliverInfo *deliverInfo;

@end


/*
 "responseField": {
 "message":"系统错误消息","":"suggestMsg":"建议错误提示消息","status":"200正常，其他异常","orderId":"订单标识","orderCode":"订单编号","orderStatus":"订单状态","orderShowStatus":"订单显示状态","isDelete":"订单是否删除","clientType":"下单时客户端类型","buyerId":"订单所属用户标识","orderTotalAmount":"订单总金额","points":"订单现金券数","expandedResponse":"保险订单扩展数据节点","ownerInfo":"车主信息节点","carInfo":"车辆信息节点","insuranceInfo":"保险信息节点","insuredInfo":"被保人信息节点","applicantInfo":"申请人信息节点","deliverInfo":"配送信息节点","name":"姓名","idCardNo":"身份证号","mobilephone":"手机号","email":"点子邮箱","cityId":"城市编码","licenseNo":"车牌号","noLicenseFlag":"是否为新车","vehicleModelName":"车辆型号名称","vehicleId":"车辆型号标识","firstRegisterDate":"车辆登记日期","engineNo":"发动机号","vehicleFrameNo":"车架号","standardPremium":"车险市场价","totalPremium":"车险网购价","forcePremium":"交强险保费","vehicleTaxPremium":"车船税","forceTotalPremium":"交强险总保费","bizInsuranceList":"商业险节点","bizTotalPremium":"商业险保费","bizBeginDate":"商业险起保日期","forceBeginDate":"交强险起保日期","bizPolicyNo":"商业险保单号","forcePolicyNo":"交强险保单号","productTypeName":"保险产品名称"}
*/