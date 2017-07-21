//
//  YBSScaleHeader.h
//  UDun
//
//  Created by moocking－ios on 17/7/12.
//  Copyright © 2017年 严兵胜. All rights reserved.
//  下拉放大

#import <UIKit/UIKit.h>

@interface YBSScaleHeader : UIView

+ (instancetype)headerWithImage:(NSString *)img imageViewHeight:(CGFloat)height;


/**
 加载网络图片 由于要依赖 YYwebImage  或 SD  什么的 具体实现被注释了 需要使用者自己打开

 @param url 图片地址
 @param height 图片想要的高度高度
 @return <#return value description#>
 */
+ (instancetype)headerImageWithUrl:(NSURL *)url imageViewHeight:(CGFloat)height;
@end


@interface UIScrollView (YBSScaleHeader)

@property (nonatomic, weak) YBSScaleHeader *ybs_header;

@end
