//
//  HYMallGoodsInfo.m
//  Teshehui
//
//  Created by ichina on 14-2-20.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "HYMallGoodsInfo.h"

@implementation HYMallGoodsInfo

- (id)initWithDataInfo:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        _isSelect = YES;
        
        self.rec_id = GETOBJECTFORKEY(data, @"rec_id", [NSString class]);
        self.user_id = GETOBJECTFORKEY(data, @"user_id", [NSString class]);
        self.session_id = GETOBJECTFORKEY(data, @"session_id", [NSString class]);
        self.store_id = GETOBJECTFORKEY(data, @"store_id", [NSString class]);
        self.goods_id = GETOBJECTFORKEY(data, @"goods_id", [NSString class]);
        self.goods_name= GETOBJECTFORKEY(data, @"goods_name", [NSString class]);
        self.spec_id = GETOBJECTFORKEY(data, @"spec_id", [NSString class]);
        self.specification = GETOBJECTFORKEY(data, @"specification", [NSString class]);
        self.price = GETOBJECTFORKEY(data, @"price", [NSString class]);
        self.points = GETOBJECTFORKEY(data, @"points", [NSString class]);
        self.quantity = [GETOBJECTFORKEY(data, @"quantity", [NSString class]) integerValue];
        self.goods_image = GETOBJECTFORKEY(data, @"goods_image", [NSString class]);
        self.store_name = GETOBJECTFORKEY(data, @"store_name", [NSString class]);
        self.subtotal = GETOBJECTFORKEY(data, @"subtotal", [NSString class]);
        self.subtotal_points= GETOBJECTFORKEY(data, @"subtotal_points", [NSString class]);
        self.specification = GETOBJECTFORKEY(data, @"specification", [NSString class]);
        self.small_goods_image = GETOBJECTFORKEY(data, @"small_goods_image", [NSString class]);
        self.middle_goods_image = GETOBJECTFORKEY(data, @"middle_goods_image", [NSString class]);
        self.refund_id = GETOBJECTFORKEY(data, @"refund_id", [NSString class]);
        self.related_id = GETOBJECTFORKEY(data, @"related_id", [NSString class]);
        self.returnable = [GETOBJECTFORKEY(data, @"returnable", [NSString class]) integerValue];
    }
    
    return self;
}

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