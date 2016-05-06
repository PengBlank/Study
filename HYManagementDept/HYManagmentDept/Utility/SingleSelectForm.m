//
//  SingleSelectForm.m
//  ChengShiJia
//
//  Created by Ray on 14-1-2.
//  Copyright (c) 2014年 Souvi. All rights reserved.
//

#import "SingleSelectForm.h"

@implementation SingleSelectForm

/**
 *  初始化方法
 *  默认选择按钮为空，选择序号为-1，允许重复点击为否,并将按钮的动作对象配置为该对象
 *
 *  @param buttons 用于初始化的按钮组，需要先进行配置
 *
 *  @return id
 */
- (id)initWithButtons:(NSArray *)buttons
{
    if (self = [super init]) {
        _selectedButton = nil;
        _selectedIndex = -1;
        _buttons = buttons;
        _allowMultipleClick = NO;
        for (UIButton *button in _buttons) {
            [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

/**
 *  按钮点击事件
 *
 *  @param btn
 */
- (void)buttonClicked:(UIButton *)btn
{
    //如果btn已选中，不进行任务操作
    if (btn != _selectedButton) {
        //新点击按钮的序号
        NSInteger newIdx = [_buttons indexOfObject:btn];
        if (newIdx == NSNotFound) {
            return;
        }
        
        //原选择按钮置为非selected
        _selectedButton.selected = NO;
        
        //新选择序号和新按钮
        _selectedIndex = newIdx;
        _selectedButton = btn;
        
        //新按钮设为selected
        _selectedButton.selected = YES;
        
        //将事件传递到代理对象
        if (self.delegate && [self.delegate respondsToSelector:@selector(singleSelectForm:didSelectedButton:atIndex:)]) {
            [self.delegate singleSelectForm:self didSelectedButton:btn atIndex:newIdx];
        }
        
        //调用回调方法
        if (self.singleSelectFormDidSelectCallback) {
            self.singleSelectFormDidSelectCallback(self, btn, newIdx);
        }
    //如果可以重复点击已选择的按钮
    } else if (_allowMultipleClick) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(singleSelectForm:didSelectedButton:atIndex:)]) {
            [self.delegate singleSelectForm:self didSelectedButton:_selectedButton atIndex:_selectedIndex];
        }
        
        if (self.singleSelectFormDidSelectCallback) {
            self.singleSelectFormDidSelectCallback(self, _selectedButton, _selectedIndex);
        }
    }
}

/**
 *  设置选择序号
 *
 *  @param selectedIndex 新的选择序号
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (selectedIndex != _selectedIndex) {
        _selectedButton.selected = NO;
        _selectedButton = [_buttons objectAtIndex:selectedIndex];
        _selectedButton.selected = YES;
        _selectedIndex = selectedIndex;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(singleSelectForm:didSelectedButton:atIndex:)]) {
            [self.delegate singleSelectForm:self didSelectedButton:_selectedButton atIndex:_selectedIndex];
        }
        if (self.singleSelectFormDidSelectCallback) {
            self.singleSelectFormDidSelectCallback(self, _selectedButton, _selectedIndex);
        }
    }
}

- (void)setSelectedButton:(UIButton *)selectedButton
{
    if (selectedButton != _selectedButton) {
        _selectedButton.selected = NO;
        selectedButton.selected = YES;
        NSInteger newIdx = [_buttons indexOfObject:selectedButton];
        _selectedIndex = newIdx;
        _selectedButton = selectedButton;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(singleSelectForm:didSelectedButton:atIndex:)]) {
            [self.delegate singleSelectForm:self didSelectedButton:_selectedButton atIndex:_selectedIndex];
        }
        if (self.singleSelectFormDidSelectCallback) {
            self.singleSelectFormDidSelectCallback(self, _selectedButton, _selectedIndex);
        }
    }
}

@end
