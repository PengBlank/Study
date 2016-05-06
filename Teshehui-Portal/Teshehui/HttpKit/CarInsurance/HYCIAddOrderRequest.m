//
//  HYCIAddOrderRequest.m
//  Teshehui
//
//  Created by 成才 向 on 15/7/13.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYCIAddOrderRequest.h"
#import "HYCIAddOrderResponse.h"
#import "HYCICarInfoFillType.h"
#import "JSONKit_HY.h"

@implementation HYCIAddOrderRequest

- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.interfaceURL = [NSString stringWithFormat:@"%@/%@", kJavaRequestBaseURL, @"order/addOrder.action"];
        self.httpMethod = @"POST";
        self.postType = KeyValue;
        self.businessType = @"06";
        self.version = @"1.0.1";
    }
    
    return self;
}

- (NSMutableDictionary *)getJsonDictionary
{
    NSMutableDictionary *newDic = [super getJsonDictionary];
    if (newDic && (NSNull *)newDic != [NSNull null]
        )
    {
        NSMutableDictionary *data = [NSMutableDictionary dictionary];
        [data setObject:@(self.totalAmount) forKey:@"orderTotalAmount"];
        [data setObject:@(self.points) forKeyedSubscript:@"points"];
        if (self.userId.length > 0)
        {
            [data setObject:self.userId forKeyedSubscript:@"userId"];
        }
        
        
        NSMutableDictionary *expanded = [NSMutableDictionary dictionary];
        [data setObject:expanded forKeyedSubscript:@"expandedRequest"];
        
        if (self.sessionid.length > 0)
        {
            [expanded setObject:self.sessionid forKey:@"sessionId"];
        }

        HYCIPersonInfo *ownerInfo = [[HYCIPersonInfo alloc] init];
        ownerInfo.name = self.ownerInfo.ownerName;
        ownerInfo.idCardNo = self.ownerInfo.ownerIdNo;
        ownerInfo.mobilephone = self.ownerInfo.ownerMobilephone;
        ownerInfo.email = self.ownerInfo.email;
        NSDictionary *owner = [ownerInfo toDictionary];
        [expanded setObject:owner forKey:@"ownerInfo"];
        
        self.carInfo.cityId = self.ownerInfo.cityId;
        self.carInfo.licenseNo = self.ownerInfo.plateNumber;
        self.carInfo.noLicenseFlag = self.ownerInfo.plateNumber.length > 0 ? @"0" : @"1";
        NSDictionary *carinfo = [self.carInfo toDictionaryWithKeys:@[@"licenseNo",
                                                                     @"noLicenseFlag",
                                                                     @"vehicleModelName",
                                                                     @"vehicleId",
                                                                     @"firstRegisterDate",
                                                                     @"engineNo",
                                                                     @"vehicleFrameNo",
                                                                     @"seats",
                                                                     @"specialCarFlag",
                                                                     @"specialCarDate",
                                                                     @"vehicleInvoiceNo",
                                                                     @"vehicleInvoiceDate"]];
        NSMutableDictionary *carinfo_ = [NSMutableDictionary dictionaryWithDictionary:carinfo];
        [carinfo_ setObject:self.carInfo.cityId forKey:@"cityCode"];
        [expanded setObject:carinfo_ forKey:@"carInfo"];
        
        NSMutableDictionary *insureceInfo = [NSMutableDictionary dictionary];
        NSMutableArray *insurceList = [NSMutableArray array];
        NSSet *insureaceInfoKeys = [NSSet setWithObjects:@"standardPremium",
                                    @"totalPremium",
                                    @"forcePremium",
                                    @"vehicleTaxPremium",
                                    @"forceTotalPremium",
                                    @"bizTotalPremium",
                                    @"bizBeginDate",
                                    @"forceBeginDate", nil];
        for (HYCICarInfoFillType *fillType in self.insureInfoList)
        {
            if ([insureaceInfoKeys containsObject:fillType.name])
            {
                [insureceInfo setObject:fillType.serverValue forKey:fillType.name];
            }
            else if ([fillType.name hasPrefix:@"cov_"])
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                if (fillType.name.length > 0)
                    [dict setObject:fillType.name forKey:@"bizInsuranceName"];
                if (fillType.inputShowName.length > 0)
                    [dict setObject:fillType.inputShowName forKey:@"bizInsuranceDescription"];
                if (fillType.value.length > 0)
                    [dict setObject:fillType.value forKey:@"bizInsuranceValue"];
                if (fillType.serverValue.length > 0)
                    [dict setObject:fillType.serverValue forKey:@"bizInsuranceFee"];
                [insurceList addObject:dict];
            }
        }
        for (HYCICarInfoFillType *fillType in self.forceList)
        {
            if ([insureaceInfoKeys containsObject:fillType.name])
            {
                [insureceInfo setObject:fillType.serverValue forKey:fillType.name];
            }
            else if ([fillType.name hasPrefix:@"cov_"])
            {
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                if (fillType.name.length > 0)
                    [dict setObject:fillType.name forKey:@"bizInsuranceName"];
                if (fillType.inputShowName.length > 0)
                    [dict setObject:fillType.inputShowName forKey:@"bizInsuranceDescription"];
                if (fillType.value.length > 0)
                    [dict setObject:fillType.value forKey:@"bizInsuranceValue"];
                if (fillType.serverValue.length > 0)
                    [dict setObject:fillType.serverValue forKey:@"bizInsuranceFee"];
                [insurceList addObject:dict];
            }
        }
        for (HYCICarInfoFillType *fillType in self.dateList)
        {
            [insureceInfo setObject:fillType.value forKey:fillType.name];
        }
        [insureceInfo setObject:insurceList forKey:@"bizInsuranceList"];
        [expanded setObject:insureceInfo forKey:@"insuranceInfo"];
        
        
        //
        NSDictionary *insuredInfo = self.insuredInfo ? [self.insuredInfo toDictionary] : owner;
        [expanded setObject:insuredInfo forKey:@"insuredInfo"];
        
        NSDictionary *applicantInfo = self.applicantInfo ? [self.applicantInfo toDictionary] : owner;
        [expanded setObject:applicantInfo forKey:@"applicantInfo"];
        
        NSDictionary *deliverInfo = [self.deliverInfo toDictionary];
        [expanded setObject:deliverInfo forKey:@"deliverInfo"];
        
//        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:self.insuranceOrderType, @"insuranceOrderType", nil];
        NSString *jsondata = [data JSONString];
        DebugNSLog(@"json:%@", jsondata);
        
        if ([jsondata length] > 0)
        {
            [newDic setObject:jsondata forKey:@"data"];
        }
    }
    return newDic;
}

- (HYCIAddOrderResponse *)getResponseWithInfo:(NSDictionary *)info
{
    HYCIAddOrderResponse *respose = [[HYCIAddOrderResponse alloc]initWithJsonDictionary:info];
    return respose;
}

@end
