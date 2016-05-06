//
//  HYMallGoodCommentInfo.h
//  Teshehui
//
//  Created by ichina on 14-2-24.
//  Copyright (c) 2014年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYMallGoodCommentInfo <NSObject>


@end

/**
 *  商品评价信息
 */
@interface HYMallGoodCommentInfo : JSONModel

@property (nonatomic,strong) NSString* m_id;
@property (nonatomic,strong) NSString *user_id;
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *goods_id;
@property (nonatomic,strong) NSString *order_id;
@property (nonatomic,strong) NSString *order_goods_id;
@property (nonatomic,strong) NSString *goods_name;
@property (nonatomic,strong) NSString *goods_spec_name;
@property (nonatomic,assign) NSInteger goods_score;
@property (nonatomic,assign) NSInteger service_score;
@property (nonatomic,assign) NSInteger delivery_score;
@property (nonatomic,strong) NSString *comment;
@property (nonatomic,strong) NSArray *pics;
@property (nonatomic,assign) BOOL is_anonymous;
@property (nonatomic,strong) NSArray<HYMallGoodCommentInfo> *replies;
@property (nonatomic,strong) NSString *created;

//从订单列表处创建
- (instancetype)initWithOrderInfo:(NSDictionary *)info;

@end



/*
 {
 "buyer_id": "49",
 "buyer_name": "test",
 "evaluation_time": "1391988783",
 "comment": "还可以\r\n",
 "evaluation": "1",
 "rec_id": "47"
 },
*/