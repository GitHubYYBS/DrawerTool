//
//  AppDelegate.m
//  YYBS_DrawerTool
//
//  Created by moocking－ios on 17/7/20.
//  Copyright © 2017年 严兵胜. All rights reserved.
//

#import "AppDelegate.h"


#import "YBSrawerViewController.h"
#import "NavVcHomeViewController.h"


#import "DrawerOneChildViewController.h"
#import "DrawerTwoChildViewController.h"
#import "DrawerThreeChildViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    
    #pragma mark - 使用 UINavigationController 的设计模式
    
    // 1.创建抽屉控制器
    YBSrawerViewController *drawerVC = [YBSrawerViewController shareDrawer];
    
    // 2.创建 UINavigationController 作为 抽屉控制器的根控制器
    UINavigationController *navVc = [[UINavigationController alloc] initWithRootViewController:[NavVcHomeViewController new]];
    // 隐藏导航栏
    [navVc setNavigationBarHidden:true];
    
    // 3.设置抽屉控制器的根控制器
    drawerVC.rootViewController = navVc;
    
    // 4.给抽屉控制器 的抽屉列表中添加 子控制器
    [drawerVC addSubViewControllerWithVC:[DrawerOneChildViewController new] Title:@"我是第一个" Image:@"mianfei"];
    [drawerVC addSubViewControllerWithVC:[DrawerTwoChildViewController new] Title:@"我是第二个" Image:@"jing"];
    [drawerVC addSubViewControllerWithVC:[DrawerThreeChildViewController new] Title:@"我是第三个" Image:@"mianfei"];

    
    // 5.将抽屉控制器 加入到导航控制器管理中 便于在抽屉母控制器中点击侧边栏时  push到相应的控制器
    UINavigationController *navVc_0 = [[UINavigationController alloc] initWithRootViewController:drawerVC];
    [navVc_0 setNavigationBarHidden:true];

    
    
    
    
    
    
    
    
    
    
    
    // 设置窗口
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = navVc_0;
    [self.window makeKeyAndVisible];

    
    
    
    
    
    return YES;
}



@end
