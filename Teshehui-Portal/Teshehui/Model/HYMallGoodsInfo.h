//
//  HYMallGoodsInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

/*
 * 商品信息
 */


#import "CQResponseResolve.h"

@interface HYMallGoodsInfo : NSObject <CQResponseResolve>

@property (nonatomic, copy) NSString * rec_id;
@property (nonatomic, copy) NSString * user_id;
@property (nonatomic, copy) NSString * session_id;
@property (nonatomic, copy) NSString * store_id;
@property (nonatomic, copy) NSString * goods_id;
@property (nonatomic, copy) NSString * goods_name;
@property (nonatomic, copy) NSString * spec_id;
@property (nonatomic, copy) NSString * specification;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString * goods_image;
@property (nonatomic, copy) NSString * store_name;
@property (nonatomic, copy) NSString * points;
@property (nonatomic, copy) NSString * subtotal;
@property (nonatomic, copy) NSString * subtotal_points;
@property (nonatomic, copy) NSString *small_goods_image;
@property (nonatomic, copy) NSString *middle_goods_image;
@property (nonatomic, assign) BOOL isSelect;  //购物车中是否选择，默认选择YES

@property (nonatomic, copy) NSString *refund_id;  //退换货id
@property (nonatomic, copy) NSString *related_id;  //换货生成的新订单
@property (nonatomic, assign) NSInteger returnable;  //退换货申请状态 0：不可申请   1：可申请 2：退换货进行中  3：退换货已完成

//- (CGFloat)getCarContentHeight;

@end

/*
 "rec_id": "266",
 "user_id": "102",
 "session_id": "b5648a3bfb734ffca2c9e676f3f37caf",
 "store_id": "82",
 "goods_id": "49",
 "goods_name": "GZUAN古钻 1克拉女款钻戒18K白金 戒指新款婚戒 钻石戒指订婚求婚",
 "spec_id": "106",
 "specification": "尺码:16号",
 "price": "108548.00",
 "points": "0",
 "quantity": "1",
 "goods_image": "http://www.teshehui.com/data/files/store_82/goods_87/small_201401141011275245.jpg",
 "store_name": "特奢汇",
 "subtotal": 108548,
 "subtotal_points": 0
*/