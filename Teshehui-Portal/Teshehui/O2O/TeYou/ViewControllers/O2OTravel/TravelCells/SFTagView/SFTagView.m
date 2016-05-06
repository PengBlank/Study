//
//  SFTagView.m
//  WrapViewWithAutolayout
//
//  Created by shiweifu on 12/9/14.
//  Copyright (c) 2014 shiweifu. All rights reserved.
//

#import "SFTagView.h"
#import "SFTag.h"
#import "SFTagButton.h"

#import "Masonry.h"
#import "UIColor+hexColor.h"

@interface SFTagView ()

@property (nonatomic, strong) NSMutableArray *tags;
@property (assign) CGFloat intrinsicHeight;

@end

@implementation SFTagView
{
    NSString    *_isCheck;
    CGFloat     _height;
}

-(CGSize)intrinsicContentSize {
  return CGSizeMake(self.frame.size.width, self.intrinsicHeight);
}

- (void)addTag:(SFTag *)tag
{
  SFTagButton *btn = [[SFTagButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  [btn setTitle:tag.text forState:UIControlStateNormal];
  [btn.titleLabel setFont:tag.font];
  [btn setBackgroundColor:tag.bgColor];
  [btn setTitleColor:tag.textColor forState:UIControlStateNormal];
  [btn addTarget:tag.target action:tag.action forControlEvents:UIControlEventTouchUpInside];
    
    //是否划线(0不划线，1划线)
    if ([_isCheck integerValue] == 1)
    {
        UIView *lineView = [[UIView alloc] init];
        [lineView setBackgroundColor:[UIColor colorWithHexColor:@"a7a7a7" alpha:1]];
        [btn addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn.mas_left);
            make.right.mas_equalTo(btn.mas_right);
            make.centerY.mas_equalTo(btn.mas_centerY);
            make.height.mas_equalTo(1.0f);
        }];
    }
    
    CGSize size;
    CGSize constraintSize = CGSizeMake(MAXFLOAT, MAXFLOAT);
#ifdef __IPHONE_7_0
    NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [paragraphStyle setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary* stringAttributes = @{NSFontAttributeName: tag.font,
                                       NSParagraphStyleAttributeName: paragraphStyle};
    size = [tag.text boundingRectWithSize: constraintSize
                                  options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                               attributes: stringAttributes
                                  context: nil].size;
#else
    size = [tag.text sizeWithFont: tag.font
                constrainedToSize: constraintSize
                    lineBreakMode: NSLineBreakByCharWrapping];
#endif
    
  CGFloat i = tag.inset;
    // 这里默认文字与标签框有边距
//  if(i == 0)
//  {
//    i = 5;
//  }
  size.width  += i * 2;
  size.height += i * 2;

  btn.layer.cornerRadius = tag.cornerRadius;
  [btn.layer setMasksToBounds:YES];

//  CGSize size = btn.intrinsicContentSize;
  CGRect r = CGRectMake(0, 0, size.width, size.height);
  [btn setFrame:r];

  [self.tags addObject:btn];

  [self rearrangeTags];
}

#pragma mark - Tag removal

- (void)removeTagText:(NSString *)text
{
  SFTagButton *b = nil;
  for (SFTagButton *t in self.tags) {
    if([text isEqualToString:t.titleLabel.text])
    {
      b = t;
    }
  }

  if(!b)
  {
    return;
  }

  [b removeFromSuperview];
  [self.tags removeObject:b];
  [self rearrangeTags];
}

- (void)removeAllTags
{
  for (SFTagButton *t in self.tags) {
    [t removeFromSuperview];
  }
  [self.tags removeAllObjects];
  [self rearrangeTags];
}

- (void)rearrangeTags
{
  self.intrinsicHeight = 0;
  [self.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
    [obj removeFromSuperview];
  }];
  __block float maxY = self.margin.top;
  __block float maxX = self.margin.left;
  __block CGSize size;
  [self.tags enumerateObjectsUsingBlock:^(SFTagButton *obj, NSUInteger idx, BOOL *stop) {
    size = obj.frame.size;
    [self.subviews enumerateObjectsUsingBlock:^(UIView* obj, NSUInteger idx, BOOL *stop) {
      if ([obj isKindOfClass:[SFTagButton class]]) {
        maxY = MAX(maxY, obj.frame.origin.y);
      }
    }];

    [self.subviews enumerateObjectsUsingBlock:^(SFTagButton *obj, NSUInteger idx, BOOL *stop) {
      if ([obj isKindOfClass:[SFTagButton class]]) {
        if (obj.frame.origin.y == maxY) {
          maxX = MAX(maxX, obj.frame.origin.x + obj.frame.size.width);
        }
      }
    }];

    // Go to a new line if the tag won't fit
    if (size.width + maxX + self.insets > (self.frame.size.width - self.margin.right)) {
      maxY += size.height + self.lineSpace;
      maxX = self.margin.left;
    }
    obj.frame = (CGRect){maxX + self.insets, maxY, size.width, size.height};
    [self addSubview:obj];
  }];

  CGRect r = self.frame;
  CGFloat n = maxY + size.height + self.margin.bottom;
  self.intrinsicHeight = n > self.intrinsicHeight? n : self.intrinsicHeight;
  [self setFrame:CGRectMake(r.origin.x, r.origin.y, self.frame.size.width, self.intrinsicHeight)];
  NSLog(@"879werwerwer9879746544949%@", NSStringFromCGRect(self.frame));
    
    _height = self.intrinsicHeight; //返回的高度
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  [self rearrangeTags];
}

- (NSMutableArray *)tags
{
  if(!_tags)
  {
    _tags = [NSMutableArray array];
  }
  return _tags;
}

#pragma mark - 自己修改的方法
- (void)addTag:(SFTag *)tag isCheck:(NSString *)isCheck
{
    _isCheck = isCheck;
    [self addTag:tag];
}

-(CGFloat)calculateHeight:(SFTag *)tag
{
    [self addTag:tag];
    return _height;
}

@end
