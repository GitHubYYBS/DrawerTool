//
//  YBSScaleHeader.m
//  UDun
//
//  Created by moocking－ios on 17/7/12.
//  Copyright © 2017年 严兵胜. All rights reserved.
//

#import "YBSScaleHeader.h"

#import <objc/runtime.h>

//#import <YYWebImage.h> // 在需要加载网络图片时  需要打开 并引入 YY 的相关库

#define ybs_ScreenW [UIScreen mainScreen].bounds.size.width


@interface YBSImageView : UIImageView
@end
@implementation YBSImageView
@end


@interface YBSScaleHeader ()

@property (nonatomic, weak) YBSImageView *imageView;
@property (nonatomic, weak) UIScrollView *scrollView;


@end

@implementation YBSScaleHeader


+ (instancetype)headerWithImage:(NSString *)img imageViewHeight:(CGFloat)height
{
    YBSScaleHeader *header = [YBSScaleHeader new];
    UIImage *image = [UIImage imageNamed:img];
    
    if (!image) {
        return nil;
    }
    CGSize imgSize = image.size;
    CGFloat imgH = height? height : ybs_ScreenW * (imgSize.height / imgSize.width);
    //    CGFloat imgH = ZYScreenW * 0.6; // (imgSize.height / imgSize.width) // 等比例缩放
    header.frame = CGRectMake(0, 0, 0, imgH);
    
    YBSImageView *imageV = [[YBSImageView alloc] initWithImage:image];
    imageV.frame = header.bounds;
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
    header.clipsToBounds = true;
    [header addSubview:imageV];
    
    return header;
}


+ (instancetype)headerImageWithUrl:(NSURL *)url imageViewHeight:(CGFloat)height{
    
    YBSScaleHeader *header = [YBSScaleHeader new];
    if (!url) {
        return nil;
    }
    YBSImageView *imageV = [[YBSImageView alloc] init];
    
//    [imageV yy_setImageWithURL:url placeholder:[UIImage imageNamed:@"home"] options:YYWebImageOptionProgressiveBlur | YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//    }];
    
    
    CGSize imgSize = imageV.image.size;
    CGFloat imgH = height? height : ybs_ScreenW * (imgSize.height / imgSize.width);
    header.frame = CGRectMake(0, 0, 0, imgH);
    
    imageV.frame = header.bounds;
    imageV.contentMode = UIViewContentModeScaleAspectFill;
    imageV.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleHeight;
    header.clipsToBounds = true;
    [header addSubview:imageV];
    
    return header;
    
}


- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setFrame:(CGRect)frame
{
    CGFloat height = frame.size.height;
    [super setFrame:CGRectMake(0, -height, ybs_ScreenW, height)];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    for (UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[YBSImageView class]]) continue;
        subView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    }
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 如果不是UIScrollView，不做任何事情
    if (newSuperview && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    // 旧的父控件移除监听
    [self removeObservers];
    
    if (newSuperview) {
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        // 设置永远支持垂直弹簧效果
        _scrollView.alwaysBounceVertical = YES;
        // 设置UIScrollView的contentInset
        _scrollView.contentInset = UIEdgeInsetsMake(self.frame.size.height, 0, 0, 0);
        
        // 添加监听
        [self addObservers];
    }
}


#pragma mark - KVO监听
- (void)addObservers
{
#ifdef DEBUG
    NSLog(@"%s %@", __func__, self.scrollView.class);
#endif
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers
{
#ifdef DEBUG
    NSLog(@"%s %@", __func__, self.superview.class);
#endif
    [self.superview removeObserver:self forKeyPath:@"contentOffset"];
}

// KVO 监听代理

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    CGFloat offSetY = self.scrollView.contentOffset.y + self.frame.size.height;
    if (offSetY)
    {
        CGFloat height = self.frame.size.height - offSetY;
        self.frame = CGRectMake(0, -height, self.frame.size.width, height);
    }
}



@end



@implementation UIScrollView (YBSScaleHeader)

static char YBSScaleHeaderKey = '\0';

- (void)setYbs_header:(YBSScaleHeader *)ybs_header{
    
    if (self.ybs_header == ybs_header) return;
    
    [self.ybs_header removeFromSuperview];
    // 使用运行时  来动态添加属性 --  该函数需要四个参数：源对象，关键字，关联的对象和一个关联策略。当然，此处的关键字和关联策略是需要进一步讨论的
    objc_setAssociatedObject(self, &YBSScaleHeaderKey, ybs_header, OBJC_ASSOCIATION_ASSIGN);
    
    [self insertSubview:ybs_header atIndex:0];
  
}


- (YBSScaleHeader *)ybs_header
{
    return objc_getAssociatedObject(self, &YBSScaleHeaderKey);
}


@end







