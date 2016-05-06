//
//  PostSendImageTableCell.m
//  TTClub
//
//  Created by xkun on 15/4/28.
//  Copyright (c) 2015年 熙文 张. All rights reserved.
//

#import "PostSendImageTableCell.h"
#import "DefineConfig.h"
#import "UIView+Frame.h"
@implementation PostSendImageTableCell

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
            [self.mediaView registerClass:[postSendImageCell class] forCellWithReuseIdentifier:kCCellIdentifier_TweetSendImage];
            self.mediaView.dataSource = self;
            self.mediaView.delegate = self;
            [self.contentView addSubview:self.mediaView];
        }
        if (!_imageDict) {
            _imageDict = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)loadMediaView:(CommentInfo *)info{

    if (_curPost != info) {
        _curPost = info;
    }
    [self.mediaView setHeight:[PostSendImageTableCell cellHeightWithObj:info]];
    [_mediaView reloadData];
    
}
- (void)setCurTweet:(CommentInfo *)curPost{
    if (_curPost != curPost) {
        _curPost = curPost;
    }
    [self.mediaView setHeight:[PostSendImageTableCell cellHeightWithObj:_curPost]];
    [_mediaView reloadData];
}
+ (CGFloat)cellHeightWithObj:(id)obj{
    CGFloat cellHeight = 0;
    if ([obj isKindOfClass:[CommentInfo class]]) {
        CommentInfo *curPost = (CommentInfo *)obj;
        NSInteger row = ceilf((float)(curPost.tweetImages.count +1)/4.0);
        cellHeight = ([postSendImageCell ccellSize].height +10) *row;
    }
    
    return cellHeight + 8;
}

#pragma mark Collection M
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  _curPost.tweetImages.count +1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    __weak typeof(self) weakSelf = self;
    
    postSendImageCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellIdentifier_TweetSendImage forIndexPath:indexPath];
    if (indexPath.row < _curPost.tweetImages.count) {
        TweetImage *curImage = [weakSelf.curPost.tweetImages objectAtIndex:indexPath.row];
        ccell.curTweetImg = curImage;
    }else{
        ccell.curTweetImg = nil;
    }
    ccell.deleteTweetImageBlock = ^(TweetImage *toDelete){
        NSMutableArray *tweetImages = weakSelf.curPost.tweetImages;//[weakSelf.curPost mutableArrayValueForKey:@"tweetImages"];
        [tweetImages removeObject:toDelete];
        
       // [weakSelf loadMediaView:weakSelf.curPost];
        [weakSelf.mediaView reloadData];
    };
    [_imageDict setObject:ccell.imgView forKey:indexPath];
    return ccell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [postSendImageCell ccellSize];
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _curPost.tweetImages.count) {
        if (_curPost.tweetImages.count >= 6) {
            kTipAlert(@"最多只可选择6张照片",nil);
            return;
        }
        
        if (self.callBack)
        {
            self.callBack();
        }

//        
//        if (_addPicturesBlock) {
//            _addPicturesBlock();
//        }
    }else{
        
//        WS(weakSelf)
//        citySelectBlock callback = ^(NSString *city)
//        {
//            [weakSelf.baseTableView setShowsInfiniteScrolling:YES];
//            [weakSelf setWithCity:city];
//        };
//        SelectCityViewController *city = [[SelectCityViewController alloc] init];
//        city.callback = callback;
//        
//        [self.baseViewController setTabbarShow:NO];
//        [self.navigationController pushViewController:city animated:YES];
//
        
        
//        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_curTweet.tweetImages.count];
//        for (int i = 0; i < _curPost.tweetImages.count; i++) {
//            TweetImage *imageItem = [_curTweet.tweetImages objectAtIndex:i];
//            MJPhoto *photo = [[MJPhoto alloc] init];
//            photo.srcImageView = [_imageViewsDict objectForKey:indexPath]; // 来源于哪个UIImageView
//            photo.image = imageItem.image; // 图片路径
//            [photos addObject:photo];
//        }
//        // 2.显示相册
//        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//        browser.currentPhotoIndex = indexPath.row; // 弹出相册时显示的第一张图片是？
//        browser.photos = photos; // 设置所有的图片
//        browser.showSaveBtn = NO;
//        [browser show];
    }
}



@end
