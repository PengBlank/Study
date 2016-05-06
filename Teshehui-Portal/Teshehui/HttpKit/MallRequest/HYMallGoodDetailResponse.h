//
//  HYMallGoodDetailResponse.h
//  Teshehui
//
//  Created by ichina on 14-2-23.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "CQBaseResponse.h"
#import "HYMallGoodsDetail.h"

@interface HYMallGoodDetailResponse : CQBaseResponse

@property(nonatomic, strong) HYMallGoodsDetail *goodDetailInfo;

@end

/*
 {
 "status": 200,
 "data": {
 "goods_id": "64",
 "store_id": "82",
 "goods_name": "PRADA\/普拉达男款压纹牛皮黑色手提\/公文包",
 "description": " ",
 "cate_id": "2119",
 "cate_name": "鞋具箱包\t潮款男包\t手提包",
 "brand": "PRADA\/普拉达",
 "spec_qty": "0",
 "spec_name_1": "",
 "spec_name_2": "",
 "last_update": "1391972580",
 "default_spec": "123",
 "default_image": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_24\/small_201401141423443962.JPG",
 "cate_id_2": "1750",
 "cost_price": "14860.00",
 "marketing_price": "17980.00",
 "tags": [
 "手提包",
 "商务包",
 "公文包"
 ],
 "price_rate": "0.10",
 "price": 16346,
 "points": 0,
 "_specs": [
 {
 "spec_id": "123",
 "goods_id": "64",
 "spec_1": "",
 "spec_2": "",
 "color_rgb": "",
 "cost_price": "14860.00",
 "marketing_price": "17980.00",
 "stock": "100",
 "sku": "",
 "price_rate": "0.10",
 "price": 16346,
 "points": 0
 }
 ],
 "_images": [
 {
 "image_id": "214",
 "goods_id": "64",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_24\/201401141423443962.JPG",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_24\/small_201401141423443962.JPG",
 "sort_order": "1",
 "file_id": "473"
 },
 {
 "image_id": "215",
 "goods_id": "64",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_25\/201401141423454284.JPG",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_25\/small_201401141423454284.JPG",
 "sort_order": "255",
 "file_id": "474"
 },
 {
 "image_id": "216",
 "goods_id": "64",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_25\/201401141423457649.JPG",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_25\/small_201401141423457649.JPG",
 "sort_order": "255",
 "file_id": "475"
 },
 {
 "image_id": "217",
 "goods_id": "64",
 "image_url": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_26\/201401141423463672.jpg",
 "thumbnail": "http:\/\/www.teshehui.com\/data\/files\/store_82\/goods_26\/small_201401141423463672.jpg",
 "sort_order": "255",
 "file_id": "476"
 }
 ],
 "_scates": [
 
 ],
 "views": "42",
 "collects": "0",
 "carts": "0",
 "orders": "0",
 "sales": "0",
 "comments": "0",
 "spec_data": {
 
 }
 }
 }
*/