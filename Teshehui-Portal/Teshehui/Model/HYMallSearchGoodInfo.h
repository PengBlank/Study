//
//  HYMallSearchGoodInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 商品搜索信息
 */

#import "JSONModel.h"
#import "HYProductImageInfo.h"

@interface HYMallSearchGoodInfo : JSONModel

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *productPicUrl;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) CGFloat stock;

@end

/*
 "praise_rate": "83.33",
 "im_qq": "",
 "im_ww": "",
 "imqq": "453747053",
 "imalww": "",
 "goods_id": "55",
 "store_id": "82",
 "type": "material",
 "goods_name": "香奈儿可可小姐淡香水 50ml",
 "cate_id": "2344",
 "cate_name": "天天最大牌\t香奈儿 Chanel",
 "brand": "香奈儿",
 "spec_qty": "0",
 "spec_name_1": "",
 "spec_name_2": "",
 "if_show": "1",
 "closed": "0",
 "add_time": "1389639075",
 "recommended": "1",
 "default_image": "http://www.teshehui.com/data/files/store_82/goods_68/small_201401141047483284.jpg",
 "audit_status": "1",
 "spec_id": "113",
 "spec_1": "",
 "spec_2": "",
 "color_rgb": "",
 "marketing_price": "790.00",
 "cost_price": "679.00",
 "price_rate": "0.10",
 "stock": "100",
 "store_name": "特奢汇",
 "region_id": "319",
 "region_name": "中国\t广东省\t深圳",
 "credit_value": "4",
 "sgrade": "2",
 "pvs": null,
 "views": "25",
 "sales": "0",
 "comments": "0",
 "price": 747,
 "points": 0,
 "credit_image": "/images/heart_1.gif",
 "grade_name": "认证店铺",
 "im_qq_val": "453747053",
 "im_alww_val": "",
 "_images": []
 }
*/