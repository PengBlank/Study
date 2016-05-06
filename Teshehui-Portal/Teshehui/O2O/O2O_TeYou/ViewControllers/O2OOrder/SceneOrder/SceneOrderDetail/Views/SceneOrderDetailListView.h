//
//  SceneOrderDetailListView.h
//  Teshehui
//
//  Created by wufeilinMacmini on 16/4/9.
//  Copyright © 2016年 HY.Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneOrderDetailModel.h"

// 点击回调block
typedef void(^SceneDetailListViewBlock)(NSInteger type);

@interface SceneOrderDetailListView : UIView

-(id)initWithFrame:(CGRect)frame WithStatus:(NSInteger)status Block:(SceneDetailListViewBlock)block;

-(void) refreshUIWithModel:(SceneOrderDetailModel *)model;

@end
