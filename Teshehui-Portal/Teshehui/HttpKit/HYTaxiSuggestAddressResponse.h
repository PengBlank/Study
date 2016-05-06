//
//  HYTaxiSuggestAddressResponse.h
//  Teshehui
//
//  Created by Kris on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYTaxiSuggestAddress.h"

@interface HYTaxiSuggestAddressResponse : CQBaseResponse

@property (nonatomic, copy) NSArray *suggAddressList;

@end
