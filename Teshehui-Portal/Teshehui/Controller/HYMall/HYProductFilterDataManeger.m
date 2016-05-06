//
//  HYProductFilterDataManeger.m
//  Teshehui
//
//  Created by 成才 向 on 15/9/4.
//  Copyright (c) 2015年 HY.Inc. All rights reserved.
//

#import "HYProductFilterDataManeger.h"

@interface HYProductFilterDataManeger ()
{
    NSMutableDictionary *_expandStatus;
}
@property (nonatomic, strong) NSArray *cateTitles;
@property (nonatomic, strong) NSArray *brandTitles;



@end

@implementation HYProductFilterDataManeger

- (id)init
{
    self = [super init];
    
    if (self)
    {
        [self initMemberVar];
        _expandStatus = [NSMutableDictionary
                         dictionaryWithDictionary:@{@0: @(NO),
                                                    @1: @(NO),
                                                    @2: @(NO)}];
        _cateIndex = -100;
        _brandIndex = -100;
    }
    
    return self;
}

- (void)initMemberVar
{
    
}

#pragma mark - setter/getter
- (void)setSubCategroyList:(NSArray *)subCategroyList
{
    if (subCategroyList != _subCategroyList)
    {
        _subCategroyList = subCategroyList;
        
        _cItemHeight = 0;
        _cateIndex = -100;
        self.cateTitles = [self titleOfItems:subCategroyList];
    }
}

- (void)setBrandInfo:(HYBrandSummary *)brandInfo
{
    if (brandInfo != _brandInfo)
    {
        _brandInfo = brandInfo;
        
        _bItemHeight = 0;
        
        if ([brandInfo.selectedProductAttributeArray count])
        {
            _brandIndex = 0;
            self.brandTitles = [self titleOfItems:brandInfo.selectedProductAttributeArray];
        }
        else
        {
            _brandIndex = -100;
            self.brandTitles = [self titleOfItems:brandInfo.productAttibuteArray];
        }
    }
}

- (void)setParentCategory:(HYMallCategoryInfo *)parentCategory
{
    if (parentCategory != _parentCategory)
    {
        _parentCategory = parentCategory;
    }
}

- (void)setCateIndex:(NSInteger)cateIndex
{
    if (cateIndex != _cateIndex)
    {
        _cateIndex = cateIndex;
        
        if (_cateIndex >= 0 && _cateIndex < _subCategroyList.count)
        {
            self.selectedCategory = [_subCategroyList objectAtIndex:_cateIndex];
        }
        else
        {
            self.selectedCategory = nil;
        }
    }
}

#pragma mark - private methods
- (NSArray *)titleOfItems:(NSArray *)items
{
    NSMutableArray *muTempArr = [[NSMutableArray alloc] init];
    
    for (id item in items)
    {
        NSString *title = nil;
        if ([item isKindOfClass:[HYBrandItem class]])  //品牌
        {
            HYBrandItem *b = (HYBrandItem *)item;
            title = b.name;
        }
        else if ([item isKindOfClass:[HYMallCategoryInfo class]])  //分类
        {
            HYMallCategoryInfo *c = (HYMallCategoryInfo *)item;
            title = c.cate_name;
        }
        
        if (title)
        {
            [muTempArr addObject:title];
        }
    }
    
    return [muTempArr copy];
}

- (CGFloat)heightForItem:(NSArray *)items
{
    if ([items count])
    {
        CGFloat org_x = 0;
        CGFloat spec = 10;
        CGFloat itemHeight = 30;
        NSInteger line = 1;
        
        for (NSString *title in items)
        {
            CGSize size = [title sizeWithFont:self.textFont
                            constrainedToSize:CGSizeMake(self.maxWidth, MAXFLOAT)];
            if (size.width>(self.maxWidth-spec*2))
            {
                size.width = self.maxWidth-spec*2;
            }
            else
            {
                size.width = (size.width+6)>(self.maxWidth-spec*4)/3 ? (size.width+6) : (self.maxWidth-spec*4)/3;
            }
            
            if ((org_x+size.width+spec) > (self.maxWidth-spec))
            {
                org_x = 0;
                line++;
            }
            
            org_x += (size.width+spec);
        }
        
        return itemHeight*line + spec*(line+1);
    }
    
    return 0;
}
#pragma mark - public methods
- (CGFloat)heightForCatesItem
{
    if (!_cItemHeight)
    {
        _cItemHeight = [self heightForItem:self.cateTitles];
        if (self.selectedCategory)
        {
            _cItemHeight += 50;
        }
    }
    
    return _cItemHeight;
}

- (CGFloat)heightForBrandsItem
{
    if (!_bItemHeight)
    {
        _bItemHeight = [self heightForItem:self.brandTitles];
    }
    
    return _bItemHeight;
}

- (void)reverseSectionExpand:(NSInteger)section
{
    _expandStatus[@(section)] = @(![_expandStatus[@(section)] boolValue]);
}
- (void)setSection:(NSInteger)section isExpand:(BOOL)expand
{
    _expandStatus[@(section)] = @(expand);
}

- (BOOL)sectionIsExpanded:(NSInteger)section
{
    return [_expandStatus[@(section)] boolValue];
}

- (HYBrandItem *)selectedBrand
{
    NSArray *arr = _brandInfo.selectedProductAttributeArray;
    if (![arr count])
    {
        arr = _brandInfo.productAttibuteArray;
    }
    
    if (_brandIndex >= 0 && _brandIndex < arr.count)
    {
        return [arr objectAtIndex:_brandIndex];
    }
    return nil;
}

- (NSIndexPath *)indexedSections
{
    NSIndexPath *sections = [[NSIndexPath alloc] init];
    if (self.brandInfo) {
        sections = [sections indexPathByAddingIndex:0];
    }
    if (self.subCategroyList.count>0 || self.selectedCategory)
    {
        sections = [sections indexPathByAddingIndex:1];
    }
    
    //后台有可能不下发，但是界面必须显示
//    if (self.priceRangDesc)
//    {
        sections = [sections indexPathByAddingIndex:2];
//    }
    
    return sections;
}

//因为显示的顺序是 分类->品牌->价格,而分类可能会没有,所以需要遍历条件来确定该index到底对应
//是哪一个条件
- (void)clearConditionAtIndex:(NSInteger)index
{
    NSMutableArray *sequence = [NSMutableArray array];
    if (self.selectedCategory)
    {
        [sequence addObject:@(0)];
    }
    if (self.selectedBrand)
    {
        [sequence addObject:@(1)];
    }
    NSInteger condition = [[sequence objectAtIndex:index] integerValue];
    if (condition == 0)
    {
        self.cateIndex = -1;
    }
    else if (condition == 1)
    {
        self.brandIndex = -1;
    }
}

- (NSArray *)conditionsDisplay
{
    NSMutableArray *display = [NSMutableArray array];
    if (self.selectedCategory)
    {
        [display addObject:self.selectedCategory.cate_name];
    }
    if (self.selectedBrand)
    {
        [display addObject:self.selectedBrand.name];
    }
    return [NSArray arrayWithArray:display];
}

@end
