//
//  TYDrinksListInfo.h
//  Teshehui
//
//  Created by wujianming on 15/11/11.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TYDrinksListInfo : NSObject

//MerId	商家id	int
@property (nonatomic, copy) NSString *MerId;
//Name	商品名称	string
@property (nonatomic, copy) NSString *Name;
//SalePrice	非会员销售价	double
@property (nonatomic, copy) NSString *SalePrice;
//Rmb	会员销售价（人民币）	double
@property (nonatomic, copy) NSString *Rmb;
//TeBi	会员销售价（现金券）	int
@property (nonatomic, copy) NSString *TeBi;
//Gid	商品id
@property (nonatomic, copy) NSString *Gid;

@end
