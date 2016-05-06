//
//  HYCICarInfoFillType.h
//  Teshehui
//
//  Created by HYZB on 15/7/3.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYCICarInfoValue@end

@interface HYCICarInfoValue : JSONModel

@property (nonatomic, copy) NSString *key;
@property (nonatomic, copy) NSString *value;

@end

@interface HYCICarInfoRangeValue : JSONModel

@property (nonatomic, copy) NSString *minimum;
@property (nonatomic, copy) NSString *maximum;

@end

@interface HYCICarInfoFillType : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *inputShowName;
@property (nonatomic, copy) NSString *inputType;
@property (nonatomic, copy) NSString *isEditable;
@property (nonatomic, strong) NSArray<HYCICarInfoValue> *selectValueList;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *showValue;
@property (nonatomic, copy) NSString *serverValue;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, strong) HYCICarInfoRangeValue *rangeValue;

- (NSArray *)inputValueList;
- (NSArray *)inputKeyList;

@end


/*
 "name":"vehicleFrameNo",
 "inputShowName":"车架号",
 "inputType":10,
 "isEditable":0,
 "inputValue":"",
 "value":"",
 "serverValue":"",
 "status":1
 "inputType": "text(10,单行文本),radio(20,单选),combo(21,下拉框),hidden(30,隐藏域),date(40,日期) (100) 品牌搜索"
 "inputType": "text(10,单行文本),radio(20,单选),combo(21,下拉框),hidden(30,隐藏域),date(40,日期),label(50,展示文本)"
*/