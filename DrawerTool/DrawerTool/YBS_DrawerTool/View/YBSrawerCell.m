//
//  YBSrawerCell.m
//  YBSrawerViewController
//
//  Created by YBS on 16/10/17.
//  Copyright © 2016年 YBS. All rights reserved.
//

#import "YBSrawerCell.h"
@interface YBSrawerCell()

@property (nonatomic, weak) UIView *bagView;
@property (weak, nonatomic) UIImageView *iconImageView;
@property (weak, nonatomic) UILabel *titleLabel;

@end
@implementation YBSrawerCell

- (UIView *)bagView{
    
    if (!_bagView) {
        UIView *bagView = [UIView new];
        bagView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_bagView = bagView];
    }
    return _bagView;
}

- (UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        UIImageView *iconImageView = [UIImageView new];
        [self.bagView addSubview:_iconImageView = iconImageView];
        
    }
    return _iconImageView;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        UILabel *titleLable = [UILabel new];
        titleLable.font = [UIFont systemFontOfSize:15];
        titleLable.textColor = [UIColor blackColor];
        [self.bagView addSubview:_titleLabel = titleLable];
    }
    return _titleLabel;
}



#pragma mark ----- 重写set方法 -----
- (void)setTitle:(NSString *)title
{
    if (_title != title) {
        _title = title;
        self.titleLabel.text = title;
    }
}

- (void)setImageName:(NSString *)imageName
{
    if (_imageName != imageName && ![_imageName isEqualToString:imageName]) {
        _imageName = imageName;
        if ([_imageName isEqualToString:@""]) {

        }else{
            self.iconImageView.image = [UIImage imageNamed:imageName];
        }
    }
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.bagView.frame = CGRectMake(0, 0,CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    self.iconImageView.frame = CGRectMake(25, 0,0,0);
    [self.iconImageView sizeToFit];
    self.iconImageView.center = CGPointMake(_iconImageView.center.x,_bagView.center.y);

    
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + 10, 0, 0, 0);
    [self.titleLabel sizeToFit];
    self.titleLabel.center = CGPointMake(_titleLabel.center.x, _iconImageView.center.y);

    
    
    
}





@end














































