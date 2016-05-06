//
//  HYProductFilterDataManeger.h
//  Teshehui
//
//  Created by 成才 向 on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HYBrandSummary.h"
#import "HYMallCategoryInfo.h"

@interface HYProductFilterDataManeger : NSObject
{
    CGFloat _cItemHeight;
    CGFloat _bItemHeight;
}

@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, strong) UIFont *textFont;

/**
 *  选中的分类和品牌
 */
@property (nonatomic, assign) NSInteger cateIndex;
@property (nonatomic, assign) NSInteger brandIndex;
@property (nonatomic, strong) HYBrandItem *selectedBrand;

@property (nonatomic, strong) HYMallCategoryInfo *parentCategory;
@property (nonatomic, strong) HYMallCategoryInfo *selectedCategory;


@property (nonatomic, strong) NSArray *subCategroyList;
@property (nonatomic, strong) HYBrandSummary *brandInfo;

@property (nonatomic, copy) NSString *priceRangDesc;
@property (nonatomic, copy) NSString *maxPrice;
@property (nonatomic, copy) NSString *minPrice;

@property (nonatomic, strong, readonly) NSArray *cateTitles;
@property (nonatomic, strong, readonly) NSArray *brandTitles;

- (CGFloat)heightForCatesItem;
- (CGFloat)heightForBrandsItem;


/**
 *  设置filterViewController各section的展开状态
 *  使用变量expandStatus存放
 *  影响height方法的返回值
 *
 *  @param section
 */
- (void)reverseSectionExpand:(NSInteger)section;
- (void)setSection:(NSInteger)section isExpand:(BOOL)expand;
- (BOOL)sectionIsExpanded:(NSInteger)section;


/**
 *  将三个内容顺序化
 *  返回的index序列中,0代表品牌,1代表分类,2代表价格
 *
 *  @return [0, 1, 2]
 */
- (NSIndexPath *)indexedSections;

/**
 *  清除一个筛选条件
 *  条件排序 分类->品牌
 *
 *  @param index
 */
- (void)clearConditionAtIndex:(NSInteger)index;

/**
 *  获取用于显示的条件列表,以字符串数组返回
 *
 *  @return [String]
 */
- (NSArray *)conditionsDisplay;

@end
