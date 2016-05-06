//
//  HYSeckillGoodsListModel.h
//  Teshehui
//
//  Created by HYZB on 15/12/9.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYImageInfo.h"

@interface HYSeckillGoodsListModel : JSONModel

@property (nonatomic, copy) NSString *productCode;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *marketPrice;
@property (nonatomic, copy) NSString *seckillPrice;
@property (nonatomic, assign) NSInteger point;
@property (nonatomic, assign) NSInteger totalStock;
@property (nonatomic, assign) NSInteger stock;//剩余库存数
@property (nonatomic, copy) NSString *productPicUrl;
@property (nonatomic, strong) HYImageInfo *productImage;
@property (nonatomic, assign) NSInteger isHaveReminded;
@property (nonatomic, assign) NSInteger remindId;
@property (nonatomic, copy) NSString *totalRemindNum;
@property (nonatomic, copy) NSString *isShowSeckillIcon;

@property (nonatomic, copy) NSString *productSkuCode;
@property (nonatomic, assign) NSInteger storeId;
@property (nonatomic, copy) NSString *storeName;
@property (nonatomic, copy) NSString *supplierType;
/*
 productSkuCode;// 商品中心SKU CODE
 storeId;//店铺id
 storeName;//店铺名称
 返回值中加一个字段是海淘商品的标识。
 supplierType      01   普通类型    06    海淘类型（String）
 */
/*
 items":[
 {
 "productCode":"020300106164",
 "productName":"瑜伽舞蹈测试",
 "marketPrice":"300",
 "seckillPrice":"100",
 "point":200,
 "totalStock":10,
 "stock":10,
 "productPicUrl":"http://image.teshehui.com/goods/64/020300106164/020300106164001/sk1_20150001.jpg",
 "productImage":{
 "index":0,
 "isInnerImage":"1",
 "imageUrl":"http://image.teshehui.com/goods/64/020300106164/020300106164001/sk1_20150001",
 "imageName":"",
 "size":"",
 "imageFileType":".jpg",
 "sizeIntValue":null
 },
 "isHaveReminded":0
 }
 ],
 */

@end
