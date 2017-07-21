//
//  UD_SrawerHeadView.m
//  UDun
//
//  Created by moocking－ios on 17/7/11.
//  Copyright © 2017年 严兵胜. All rights reserved.
//

#import "YBSSrawerHeadView.h"

static CGFloat iconImageView_WH = 60; // 头像的 宽高
static CGFloat iconSpace = 10; // 头像距左边的边距
static NSString *fontWithName = @"TrebuchetMS"; // 字体样式


@implementation YBSSrawerHeadView

+ (instancetype)srawerHeadView{
    
    YBSSrawerHeadView *headView = [[YBSSrawerHeadView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 0.45)];
    headView.backgroundColor = [UIColor clearColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yybs_icon"]];
    iconImageView.frame = CGRectMake(2 * iconSpace, CGRectGetMaxY(headView.frame) * 0.6, iconImageView_WH * 0.66, iconImageView_WH * 0.66);
    [headView addSubview:iconImageView];
    
    UILabel *nameLable = [UILabel new];
    nameLable.textColor = [UIColor whiteColor];
    nameLable.font = [UIFont fontWithName:fontWithName size:20];
    nameLable.text = @"大班严兵胜";
    [nameLable sizeToFit];
    
    nameLable.frame = CGRectMake(CGRectGetMaxX(iconImageView.frame) + 15, 0, nameLable.bounds.size.width, nameLable.bounds.size.height);
    nameLable.center = CGPointMake(nameLable.center.x, CGRectGetMidY(iconImageView.frame) + nameLable.bounds.size.height);
    [headView addSubview:nameLable];
    
    return headView;
    
}

@end
