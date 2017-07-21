//
//  DrawerTwoChildViewController.m
//  YYBS_DrawerTool
//
//  Created by moocking－ios on 17/7/20.
//  Copyright © 2017年 严兵胜. All rights reserved.
//

#import "DrawerTwoChildViewController.h"

@interface DrawerTwoChildViewController ()

@end

@implementation DrawerTwoChildViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // view 即将出现是 显示导航条
    [self.navigationController setNavigationBarHidden:false];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // view 即将消失时  隐藏导航条
    [self.navigationController setNavigationBarHidden:true];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    
    UILabel *ybs_titleLable = [UILabel new];
    ybs_titleLable.textColor = [UIColor redColor];
    ybs_titleLable.font = [UIFont systemFontOfSize:20];
    ybs_titleLable.numberOfLines = 0;
    ybs_titleLable.textAlignment = NSTextAlignmentCenter;
    ybs_titleLable.frame = CGRectMake(0, 0, self.view.bounds.size.width, 200);
    ybs_titleLable.text = @" 第二个 \n我是抽屉列表中 第二个控制器";
    ybs_titleLable.center = self.view.center;
    [self.view addSubview:ybs_titleLable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
