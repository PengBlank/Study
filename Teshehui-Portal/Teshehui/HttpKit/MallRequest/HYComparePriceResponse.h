//
//  HYComparePriceResponse.h
//  Teshehui
//
//  Created by Kris on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "JSONModel.h"

@interface HYComparePriceModel : JSONModel

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, strong) NSArray *productSKUWebPriceArray;

@end

@interface HYProductSKUWebPriceArrayModel : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *compareUrl;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *imageUrl;

@end

@interface HYComparePriceResponse : CQBaseResponse

@property (nonatomic, strong) HYComparePriceModel *comparePriceModel;

@end
