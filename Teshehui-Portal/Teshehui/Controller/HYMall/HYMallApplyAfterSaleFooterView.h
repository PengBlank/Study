//
//  HYMallApplyAfterSaleFooterView.h
//  Teshehui
//
//  Created by Kris on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYAddressInfo.h"

@class HYMallAfterSaleInfo;

typedef NS_ENUM(NSUInteger, ReceiverInfo)
{
    ReceiverTextFied = 888,
    MobileTextFied,
    AddressRegion,
    AddressDetailTextField,
};

@protocol HYMallApplyAfterSaleFooterViewDelegate <NSObject>

@optional
- (void)beginContentOffSet;
- (void)informationOfReceiver:(NSString *)text
             fromTextFieldTag:(NSInteger)tag withObject:(id)object;


@end

@interface HYMallApplyAfterSaleFooterView : UIView

@property (nonatomic,weak) id<HYMallApplyAfterSaleFooterViewDelegate> delegate;
@property (nonatomic, strong) HYMallAfterSaleInfo *saleInfo;
@property (nonatomic, strong) HYAddressInfo *addressInfo;
@property (nonatomic, assign) BOOL isChange;
- (instancetype)initMyNib;

@end
