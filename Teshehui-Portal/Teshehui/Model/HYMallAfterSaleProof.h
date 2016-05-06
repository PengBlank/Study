//
//  HYMallAfterSaleProof.h
//  Teshehui
//
//  Created by 成才 向 on 15/10/12.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "JSONModel.h"

@protocol HYMallAfterSaleProof <NSObject>
@end

@interface HYMallAfterSaleProof : JSONModel

@property (nonatomic, copy) NSString *returnProofId;
@property (nonatomic, copy) NSString *returnFlowDetailId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, copy) NSString *createTime;

@end
