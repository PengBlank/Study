//
//  GetImageTableCell.m
//  Teshehui
//
//  Created by macmini5 on 15/11/20.
//  Copyright © 2015年 HY.Inc. All rights reserved.
//

#import "GetImageTableCell.h"
#import "DefineConfig.h"
#import "GetImageCollectionCell.h"
#import "UIView+Frame.h"
#import "CommentInfo.h"

@implementation GetImageTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        if (!self.mediaView) {
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            self.mediaView = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, kScreen_Width - 2 * 15, 80) collectionViewLayout:layout];
            self.mediaView.scrollEnabled = NO;
            [self.mediaView setBackgroundView:nil];
            [self.mediaView setBackgroundColor:[UIColor whiteColor]];
            [self.mediaView registerClass:[GetImageCollectionCell class] forCellWithReuseIdentifier:@"imageCell"];
            self.mediaView.dataSource = self;
            self.mediaView.delegate = self;
            [self.contentView addSubview:self.mediaView];
        }
    }
    return self;
}

- (void)loadMediaView:(NSArray *)arr
{
    
    [self.mediaView setHeight:[GetImageTableCell cellHeightWithArr:arr]];
    [_mediaView reloadData];
    
}
//- (void)setCurTweet:(CommentInfo *)curPost{
//    if (_curPost != curPost) {
//        _curPost = curPost;
//    }
//    [self.mediaView setHeight:[PostSendImageTableCell cellHeightWithObj:_curPost]];
//    [_mediaView reloadData];
//}

+ (CGFloat)cellHeightWithArr:(NSMutableArray *)arr{
    CGFloat cellHeight = 0;
    NSInteger row = ceilf((float)(arr.count)/4.0);
//    NSInteger row = ceilf((float)5/4.0);
    if (row == 0) {
        row = 1;
    }
    row = 2;    //写死 返回两行高度
    cellHeight = ([GetImageCollectionCell ccellSize].height +10) *row;
    
    return cellHeight;
}

#pragma mark - CollectionView 代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.images.count;
//    return 6;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GetImageCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    
    TweetImage *curImage = self.images[indexPath.row];
    [cell loadImage:curImage];
//    [cell loadImage2:self.images[indexPath.row]]; // 模拟评论用
    
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [GetImageCollectionCell ccellSize];
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.imageBlock)
    {
        self.imageBlock(self.images,indexPath.row);
    }
}

@end
