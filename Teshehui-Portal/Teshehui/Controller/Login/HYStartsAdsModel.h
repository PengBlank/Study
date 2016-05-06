//
//  HYStartsAdsModel.h
//  Teshehui
//
//  Created by Kris on 16/1/5.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"
#import "HYStartAdsProgramModel.h"

@interface HYStartsAdsModel : JSONModel

@property (nonatomic, strong) NSArray<HYStartAdsProgramModel *>*programPOList;

@end

/*
"data":[
        {
            "boardCode":"90",
            "title":"APP启动页广告",
            "programShowNum":1,
            "programTotalNum":1,
            "programPOList":[
                             {
                                 "name":"adver-002-ios",
                                 "type":"01",
                                 "businessType":"01",
                                 "url":"productId=150100001006",
                                 "pictureUrl":"http://image.beta.teshehui.com/goods/06/150100001006/150100001006001/sk1_20150001.jpg",
                                 "price":"274.0",
                                 "points":"326",
                                 "expensived":1
                             }
                             ]
        }
        ],
*/