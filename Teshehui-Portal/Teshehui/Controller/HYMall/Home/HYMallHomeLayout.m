//
//  HYMallHomeLayout.m
//  Teshehui
//
//  Created by 成才 向 on 15/10/3.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "HYMallHomeLayout.h"
#import "HYMallHomeViewController.h"
#include "HYMallHomeSections.h"

@implementation HYMallHomeLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _moreSection = -1;
    }
    return self;
}

- (void)prepareLayout {
    
    [super prepareLayout];
    // 初始化参数
    _insert = 10; // 设置间距
}

- (CGSize)collectionViewContentSize
{
    CGFloat y = MAX(_rightY, _leftY);
    if (y > 0)
    {
        y += 44;
        return CGSizeMake(ScreenRect.size.width, y);
    }
    else
    {
        return [super collectionViewContentSize];
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    NSUInteger sections = [self.collectionView numberOfSections];
    for (NSUInteger i = 0; i < sections; i++)
    {
        NSUInteger row = [self.collectionView numberOfItemsInSection:i];
        for (NSUInteger j = 0; j < row; j++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    if (_moreSection > 0 && _moreSection < sections)
    {
//        NSInteger row = [self.collectionView numberOfItemsInSection:_moreSection];
        UICollectionViewLayoutAttributes *footAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForRow:0 inSection:_moreSection]];
        if (footAttr) {
            [attributes addObject:footAttr];
        }
        UICollectionViewLayoutAttributes *headAttr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:_moreSection]];
        if (headAttr) {
            [attributes addObject:headAttr];
        }
        
        if (sections > 1)
        {
            for (NSUInteger i = 0; i < sections-2; i++)
            {
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:i];
                UICollectionViewLayoutAttributes *attr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:path];
                if (attr)
                {
                    [attributes addObject:attr];
                }
            }
        }
    }
    else
    {
        if (sections > 0)
        {
            for (NSUInteger i = 0; i < sections-1; i++)
            {
                NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:i];
                UICollectionViewLayoutAttributes *attr = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:path];
                if (attr)
                {
                    [attributes addObject:attr];
                }
            }
        }
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    
    if (indexPath.section == _moreSection)
    {
        
        // 判断当前的item应该在左侧还是右侧
        BOOL isLeft = _leftY <= _rightY;
        if (indexPath.row == 0)
        {
            CGRect frame = attributes.frame;
            _leftY = frame.origin.y - frame.size.width*0.6;
            _rightY = frame.origin.y - frame.size.width * 0.6;
        }
        if (isLeft)
        {
            CGRect frame=  attributes.frame;
            frame.origin.y = _leftY;
            _leftY += frame.size.height + _insert;
            attributes.frame = frame;
        }
        else
        {
            CGRect frame=  attributes.frame;
            frame.origin.y = _rightY;
            _rightY += frame.size.height + _insert;
            attributes.frame = frame;
        }
    }
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == _moreSection && [elementKind isEqualToString:UICollectionElementKindSectionFooter])
    {
        UICollectionViewLayoutAttributes *attributes = [[super layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:indexPath] copy];
        CGFloat y = MAX(_rightY, _leftY);
        CGRect frame =  attributes.frame;
        frame.origin.y = y;
        attributes.frame = frame;
        return attributes;
    }
    return [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
}

@end
