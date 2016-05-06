//
//  HYTaxiSuggestAddress.h
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYTaxiSuggestAddress : JSONModel

@property (nonatomic, copy) NSString *addressInput;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *addressDetail;
@property (nonatomic, copy) NSString *latitude;
@property (nonatomic, copy) NSString *longitude;
@property (nonatomic, copy) NSString *cityCode;
@property (nonatomic, copy) NSString *cityName;

@end

/*
"addressInput":"s",
"address":"深圳北站",
"addressDetail":"",
"latitude":"22.6110032791",
"longitude":"114.02943708182",
"cityCode":"2",
"cityName":"深圳市"
*/