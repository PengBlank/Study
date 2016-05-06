//
//  HYMyDesireDetailFooterView.h
//  Teshehui
//
//  Created by HYZB on 15/11/24.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYMyDesireDetailModel.h"


@protocol HYMyDesireDetailFooterViewDelegate <NSObject>

- (void)goToGoodsDetailView:(NSString *)productCode;

@end

@interface HYMyDesireDetailFooterView : UIView

@property (weak, nonatomic) IBOutlet UILabel *replyContentLab;
@property (nonatomic, weak) id <HYMyDesireDetailFooterViewDelegate>delegate;

- (void)setFooterViewWithModel:(HYMyDesireDetailModel *)model;


@end
