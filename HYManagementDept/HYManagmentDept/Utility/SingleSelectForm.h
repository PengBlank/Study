//
//  SingleSelectForm.h
//  ChengShiJia
//
//  Created by Ray on 14-1-2.
//  Copyright (c) 2014年 Souvi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  抽象对象，利用一组UIButton实现单选，被放进这个对象的button会只被允许选中一个
 *  其中的button需要单独配置，这个对象仅实现单选的逻辑
 */

@class SingleSelectForm;
@protocol SingleSelectFormDelegate <NSObject>

@optional
- (void)singleSelectForm:(SingleSelectForm *)form didSelectedButton:(UIButton *)button atIndex:(NSInteger)idx;

@end

@interface SingleSelectForm : NSObject {
    /**
     *  单选按钮
     */
    NSArray *_buttons;
}

/**
 *  初始化方法，这个方法会将所有的button的target对象全部指向为这个form对象
 *
 *  @param buttons 用于单选的按钮
 *
 *  @return the form
 */
- (id)initWithButtons:(NSArray *)buttons;

/**
 *  暂时只读先
 */
@property (nonatomic, strong, readonly) NSArray *buttons;

/**
 *  代理对象，单选框发生某些事件后会通知该对象
 */
@property (nonatomic, weak) id<SingleSelectFormDelegate> delegate;

/**
 *  当前选中序号,未选中时为-1,初始化时为-1，设置selectedButton属性会同时更新这个属性
 */
@property (nonatomic, assign) NSInteger selectedIndex;

/**
 *  当前选中按钮，未选中时为nil，初始化时为nil，设置selectedIndex属性会同时更新这个属性
 */
@property (nonatomic, weak) UIButton *selectedButton;

/**
 *  回调方法
 */
@property (nonatomic, copy) void (^singleSelectFormDidSelectCallback)(SingleSelectForm *form, UIButton *button, NSInteger idx);

/**
 *  决定在一个按钮已被选中的情况点击该按钮是否可以触发事件
 */
@property (nonatomic, assign) BOOL allowMultipleClick;



@end
