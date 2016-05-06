//
//  HYMallGuessYouLikeModel.h
//  Teshehui
//
//  Created by Kris on 16/4/12.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@interface HYMallMainImageModel : JSONModel

@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *imageFileType;
@property (nonatomic, copy) NSString *imageIndex;

@end

@interface HYMallGuessYouLikeModel : JSONModel

@property (nonatomic, copy) NSString *itemId;
@property (nonatomic, copy) NSString *itemCode;
@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *marketPrice;
@property (nonatomic, copy) NSString *points;
@property (nonatomic, copy) HYMallMainImageModel *mainImageBo;

@end


/*
{
    "mainImageBo": {
        "imageUrl": "http://image.beta.teshehui.com/goods/46/150100041946/150100041946001/sk1_20150001",
        "imagePath": "goods/46/150100041946/150100041946001",
        "imageName": "sk1_20150001",
        "imageFileType": ".jpg",
        "imageIndex": 1
    },
    "itemId": 41946,
    "itemCode": "150100041946",
    "itemName": "瑞士军刀（SWISSGEAR） SA-7715 圆点 时尚潮流款15.6寸防水PU双肩电脑休闲背包",
    "price": 174.9,
    "marketPrice": 199,
    "points": 24
},
*/