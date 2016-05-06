//
//  SFTagView.h
//  WrapViewWithAutolayout
//
//  Created by shiweifu on 12/9/14.
//  Copyright (c) 2014 shiweifu. All rights reserved.
//
/*wfl
  用于 包含景点 的名称标签的背景View
 */

#import <UIKit/UIKit.h>

@class SFTag;

@interface SFTagView : UIView


@property (nonatomic, assign) UIEdgeInsets margin;  // 标签与背景上下左右距离
@property (nonatomic, assign) int lineSpace;        // 标签间列距离
@property (nonatomic, assign) CGFloat insets;       // 标签间行距离

- (void)addTag:(SFTag *)tag;

- (void)removeAllTags;

- (void)removeTagText:(NSString *)text;

// 修改addTag方法方法
- (void)addTag:(SFTag *)tag isCheck:(NSString *)isCheck;
//根据景点名计算view高度
- (CGFloat)calculateHeight:(SFTag *)tag;

@end

