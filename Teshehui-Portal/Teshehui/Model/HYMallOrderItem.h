//
//  HYMallOrderItem.h
//  Teshehui
//
//  Created by HYZB on 15/5/11.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYMallGoodCommentInfo.h"

typedef enum
{
    HYCannotEvaluation  = 0,
    HYCanEvaluation,
    HYCanAddEvaluation
}
HYOrderGoodsEvaluationStatus;

typedef enum
{
    HYCannotIndemnity  = 0,  //不可赔付
    HYCanIndemnity,  //可赔付
    HYIndemnified  //已赔付
}
HYIndemnityStatus;

@protocol HYMallOrderItem <NSObject>

@end

@interface HYMallOrderItem : JSONModel

@property (nonatomic, copy) NSString *businessType;
@property (nonatomic, copy) NSString *orderItemId;
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *points;

@property (nonatomic, assign) HYOrderGoodsEvaluationStatus isEvaluable;
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productSKUCode;
@property (nonatomic, copy) NSString *specification;
@property (nonatomic, copy) NSString *marketingPrice;
@property (nonatomic, copy) NSString *pictureBigUrl;
@property (nonatomic, copy) NSString *pictureSmallUrl;
@property (nonatomic, copy) NSString *pictureMiddleUrl;
@property (nonatomic, copy) NSString *thumbnailPicUrl;//商品缩略图
@property (nonatomic, copy) NSString *sellerCode;
@property (nonatomic, copy) NSString *storeDeliveryId;
@property (nonatomic, copy) NSString *storeDeliveryName;
@property (nonatomic, copy) NSString *storeDeliveryFee;

@property (nonatomic, assign) NSInteger returnable;
@property (nonatomic, strong) NSString *returnId;
@property (nonatomic, assign) HYIndemnityStatus isCanApplyGuijiupei;
@property (nonatomic, assign) BOOL isCanApplyReturn;
@property (nonatomic, assign) BOOL isCanApplyAfterSale;
@property (nonatomic, assign) BOOL isCanApplyExchange;
@property (nonatomic, assign) BOOL isCanApplyLightReturn;
@property (nonatomic, assign) NSInteger returnableQuantity;

@property (nonatomic, strong) NSString *guijiupeiId;

@property (nonatomic, strong) HYMallGoodCommentInfo *commentInfo;

@property (nonatomic, assign) NSInteger quantity;

//@property (nonatomic, assign) HYIndemnityStatus indemnityStatus;  //赔付的

/**
 * 是否是海淘商品  1是 2否  (默认为 2 )
 */
@property (nonatomic, assign) NSInteger isSears;

- (id)initWithDataInfo:(NSDictionary *)data;

@end
