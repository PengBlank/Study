//
//  HYAfterSaleDefines.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/21.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#ifndef HYAfterSaleDefines_h
#define HYAfterSaleDefines_h

typedef NS_ENUM(NSInteger, HYAfterSaleOrderStatus)
{
    HYAfterSaleReviewing            =10,
    HYAfterSalePass                 =20,
    HYAfterSaleRefused              =21,
    HYAfterSaleCancelled            =-10,
    HYAfterSaleRefunding            =30,
    HYAfterSaleCompleted            =50,
    HYAfterSaleDisputing            =60,
    HYAfterSaleDisputed             = 8,
    HYAfterSaleRefunded             =40
};

typedef NS_ENUM(NSInteger, HYAfterSaleOrderItemStatus)
{
    HYAfterSaleWaitHandling = 1,
    HYAfterSaleCustomerSended = 5,
    HYAfterSaleMerchantRecived = 2,
    HYAfterSaleMerchantConfirm = 3,
    HYAfterSaleMerchantRefused = 4,
    HYAfterSaleMerchantSended = 6
};

typedef NS_ENUM(NSInteger, HYAfterSaleHandleType)
{
    HYAfterSaleEdit         =1,
    HYAfterSaleCancel       =2,
    HYAfterSaleFillLogis    =3,
    HYAfterSaleDelete       =4
};

#endif /* HYAfterSaleDefines_h */
