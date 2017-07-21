//
//  YBSrawerViewController.m
//  YBSrawerViewController
//
//  Created by 严兵胜 on 16/10/17.
//  Copyright © 2016年 YBS. All rights reserved.
//

#import "YBSrawerViewController.h"
#import "YBSrawerCell.h"
#import "YBSSrawerHeadView.h"
#import "YBSScaleHeader.h"

#define kMainBouns [UIScreen mainScreen].bounds
@interface YBSrawerViewController () <UITableViewDelegate ,UITableViewDataSource>
@property (strong , nonatomic) NSMutableArray * titleArray;
@property (strong , nonatomic) NSMutableArray * imageArray;
@property (strong , nonatomic) NSMutableArray * vcArray;
/**
 *  存的控制器
 */
@property (strong , nonatomic) UIViewController * vc;
/**
 *  tableView用于选择
 */
@property (strong , nonatomic) UITableView * tableView;
/**
 *  tapGesture
 */
@property (strong , nonatomic) UITapGestureRecognizer * tapGesture;
/**
 *  rightPanGesture
 */
@property (strong , nonatomic) UIPanGestureRecognizer * rightPanGesture;
/**
 *  rootVC在数组中的位置。
 */
@property (assign , nonatomic) NSInteger rootIndex;
/**
 *  点击的遮挡视图。
 */
@property (strong , nonatomic) UIView * tapView;
@property (assign , nonatomic) CGFloat drawerWidth;
@end
static YBSrawerViewController * drawerVC;
@implementation YBSrawerViewController
+ (instancetype)new
{
    return [self shareDrawer];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.drawerWidthScale = 0.8;
        self.drawerWidth      = [UIScreen mainScreen].bounds.size.width * self.drawerWidthScale;
        self.startGesture     = NO;
        self.tapGesture       = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismiss)];
        self.rootIndex        = 0;
        self.rightPanGesture  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(rightPanAction:)];
        self.transparentScale = 0.2;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
//    [self changeViewControllerWithNumber:self.rootIndex]; // 默认取 子控制器数组中第 0 个
}


#pragma mark ----- 重写set方法 -----
- (void)settableViewSectionFooterView:(UIView *)tableViewSectionFooterView
{
    if (_tableViewSectionFooterView != tableViewSectionFooterView) {
        _tableViewSectionFooterView  = tableViewSectionFooterView;
    }
}
- (void)settableViewSectionHeaderView:(UIView *)tableViewSectionHeaderView
{
    if (_tableViewSectionHeaderView != tableViewSectionHeaderView) {
        _tableViewSectionHeaderView  = tableViewSectionHeaderView;
    }
}
- (void)setDrawerWidth:(CGFloat)drawerWidth
{
    if (_drawerWidth != drawerWidth) {
        _drawerWidth         = drawerWidth;
        self.tableView.frame = CGRectMake(-(self.drawerWidth / 2.0), 0, self.drawerWidth, kMainBouns.size.height);
    }
}
- (void)setDrawerWidthScale:(CGFloat)drawerWidthScale
{
    if (_drawerWidthScale != drawerWidthScale) {
        _drawerWidthScale    = drawerWidthScale;
        self.drawerWidth     = [UIScreen mainScreen].bounds.size.width * drawerWidthScale;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.drawerWidth, self.tableView.frame.size.height);
    }
}
#pragma mark ----- 懒加载 -----
- (UIView *)tapView
{
    if (_tapView == nil) {
        _tapView = [[UIView alloc] init];
        [_tapView addGestureRecognizer:self.tapGesture];
        _tapView.userInteractionEnabled = NO;
    }
    return _tapView;
    
    
}
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(-(self.drawerWidth / 2.0), 0, self.drawerWidth, kMainBouns.size.height) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[YBSrawerCell class] forCellReuseIdentifier:@"YBSrawerCell"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // tableView 的头部放大图片
        YBSSrawerHeadView *headView = [YBSSrawerHeadView srawerHeadView];
        YBSScaleHeader *head = [YBSScaleHeader headerWithImage:@"headImage" imageViewHeight:CGRectGetHeight(headView.bounds)];
        [head addSubview:headView];
        _tableView.ybs_header = head;

        
    }
    return _tableView;
}
- (NSMutableArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (NSMutableArray *)vcArray
{
    if (_vcArray == nil) {
        _vcArray = [NSMutableArray array];
    }
    return _vcArray;
}
- (NSMutableArray *)imageArray
{
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}


#pragma mark ----- tableView -----


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%ld",self.vcArray.count);
    return self.vcArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YBSrawerCell * cell = [tableView dequeueReusableCellWithIdentifier:@"YBSrawerCell" forIndexPath:indexPath];
    cell.title     = _titleArray[indexPath.row];
    cell.imageName = _imageArray[indexPath.row];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
#ifdef DEBUG
    
    NSLog(@"抽屉母控制器是否可以使用push来切换控制器__ %@",self.navigationController? @"YES" : @"NO");

#endif
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
 
    if ([self.vc isEqual:self.vcArray[indexPath.row]]) {
        [self dismissDrawer];
        return;
    }
    
    UIViewController *vc = self.vcArray[indexPath.row];
    if (self.navigationController) { // 当前抽屉母控制器  在导航控制器的管理下
        
        [self.navigationController pushViewController:vc animated:true];
        [self dismissDrawer];
        
    }else{
        
        [self changeViewControllerWithNumber:indexPath.row];
        [self dismissDrawer];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.tableViewSectionHeaderView?self.tableViewSectionHeaderView : [[UIView alloc]init];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.tableViewSectionFooterView?self.tableViewSectionFooterView : [[UIView alloc]init];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return self.tableViewSectionHeaderView?self.headerViewHeight:0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return self.tableViewSectionFooterView?self.footerViewHeight:0;
}


#pragma mark ----- 实现方法 -----
+ (YBSrawerViewController *)shareDrawer
{
    if (drawerVC == nil) {
        drawerVC = [[YBSrawerViewController alloc] init];
    }
    return drawerVC;
}
- (void)setHeaderView : (UIView *)headerView
         HeaderHeight : (CGFloat)headerHeight
{
    self.headerViewHeight    = headerHeight;
//    self.tableView.tableHeaderView = headerView;
    self.tableViewSectionHeaderView = headerView;
    [self.tableView reloadData];
}
- (void)setFooterView : (UIView *)footerView
         FooterHeight : (CGFloat)footerHeight
{
    self.footerViewHeight    = footerHeight;
//    self.tableView.tableFooterView = footerView;
    self.tableViewSectionFooterView = footerView;
    [self.tableView reloadData];
}
/**
 *  切换到第几个视图控制器 0 ~ n  ___  切换侧边栏中的控制器
 *
 *  @param number 数值 0 ~ n
 */
- (void)changeViewControllerWithNumber : (NSInteger)number
{
    CGRect rect = [UIScreen mainScreen].bounds;
    if (self.vc) {
        [self.vc.view removeFromSuperview];
        rect = self.vc.view.frame;
        [self.tapView removeFromSuperview];
    }
    
    self.vc = self.vcArray[number];
    self.vc.view.frame = rect;
    
    if ([self.vc isKindOfClass:[UINavigationController class]]) { // nav管理
        UINavigationController * nav  = (UINavigationController *)self.vc;
        
        if (nav.viewControllers.count == 1) {
            UIViewController * vc1    = nav.viewControllers.firstObject;
            [vc1.view addGestureRecognizer:self.rightPanGesture];
        }
    }else if ([self.vc isKindOfClass:[UITabBarController class]]){ // tabBar管理
        
        UITabBarController *tabBarVc = (UITabBarController *)self.vc;
        
        if (tabBarVc.viewControllers.count == 1) {
            UIViewController *vc1 = tabBarVc.viewControllers.firstObject;
            [vc1.view addGestureRecognizer:self.rightPanGesture];
        }
    }
    
    self.tapView.frame = self.vc.view.bounds;
    [self.vc.view addSubview:self.tapView];
    [self.view    addSubview:self.vc.view];
}

- (void)setRootViewController:(UIViewController *)rootViewController{
    
    _rootViewController = rootViewController;
    self.vc = rootViewController;
    
    CGRect rect = [UIScreen mainScreen].bounds;
    
    rootViewController.view.frame = rect;
    
    
    if ([rootViewController isKindOfClass:[UINavigationController class]]) { // nav管理
        UINavigationController * nav  = (UINavigationController *)rootViewController;

        if (nav.viewControllers.count == 1) {
            UIViewController * vc1    = nav.viewControllers.firstObject;
            [vc1.view addGestureRecognizer:self.rightPanGesture];
        }
    }else if ([rootViewController isKindOfClass:[UITabBarController class]]){ // tabBar管理
        
        UITabBarController *tabBarVc = (UITabBarController *)rootViewController;

        if (tabBarVc.viewControllers.count == 1) {
            UIViewController *vc1 = tabBarVc.viewControllers.firstObject;
            [vc1.view addGestureRecognizer:self.rightPanGesture];
        }
    }else{
        
        [rootViewController.view addGestureRecognizer:self.rightPanGesture];
    }
    
    
    self.tapView.frame = rootViewController.view.bounds;
    [rootViewController.view addSubview:self.tapView];
    [self.view    addSubview:rootViewController.view];

}



/**
 *  添加子视图控制器
 *
 *  @param vc    添加的视图
 *  @param title 添加视图的文字描述
 *  @param image 添加视图前面的图片，可以是空。
 */
- (void)addSubViewControllerWithVC : (UIViewController *)vc
                             Title : (NSString *)title
                             Image : (NSString *)image
{
    
    [self.titleArray addObject:title];
    [self.imageArray addObject:image?image:@""];
    [self.vcArray    addObject:vc];
    [self.tableView  reloadData];
    [self addChildViewController:vc];
    
}
/**
 *  添加子视图控制器
 *
 *  @param vc      添加的视图
 *  @param title   添加视图的文字描述
 *  @param image   添加视图前面的图片，可以是空。
 *  @param isRoot  添加的vc是否是第一个显示的，如果没有使用这个方法，默认会显示添加的第一个。
 */
- (void)addSubViewControllerWithVC : (UIViewController *)vc
                             Title : (NSString *)title
                             Image : (NSString *)image
                            IsRoot : (BOOL)isRoot
{
    [self addSubViewControllerWithVC:vc Title:title Image:image];
    if (isRoot) {
        self.rootIndex = self.vcArray.count - 1;
    }
}
/**
 *  显示
 */
- (void)showDrawer
{
    [self.vc.view layoutIfNeeded];
    [self.tableView layoutIfNeeded];
    self.tapView.userInteractionEnabled = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.vc.view.frame           = CGRectMake(self.drawerWidth, self.vc.view.frame.origin.y, self.vc.view.frame.size.width, self.vc.view.frame.size.height);
        self.tableView.frame         = CGRectMake(0, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
        self.tapView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.transparentScale];
    } completion:^(BOOL finished) {
        self.tapView.userInteractionEnabled = YES;
        [self.tapView addGestureRecognizer:self.rightPanGesture];
    }];
}
/**
 *  隐藏
 */
- (void)dismissDrawer
{
    [self.vc.view layoutIfNeeded];
    [self.tableView layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        self.vc.view.frame = CGRectMake(0, self.vc.view.frame.origin.y, self.vc.view.frame.size.width, self.vc.view.frame.size.height);
        self.tableView.frame = CGRectMake(- (self.drawerWidth / 2.0), self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height);
        self.tapView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        [self.tapView removeGestureRecognizer:self.rightPanGesture];
        [self.vc.view removeGestureRecognizer:self.tapGesture];
        self.tapView.userInteractionEnabled = NO;
        if ([self.vc isKindOfClass:[UINavigationController class]]) {
            UINavigationController * nav = (UINavigationController *)self.vc;
            if (nav.viewControllers.count == 1) {
                UIViewController * vc1 = nav.viewControllers.firstObject;
                [vc1.view addGestureRecognizer:self.rightPanGesture];
            }
        }else{
            [self.vc.view addGestureRecognizer:self.rightPanGesture];
        }
        
        
    }];
}
#pragma mark ----- 手势方法 -----
- (void)tapDismiss
{
    [self dismissDrawer];
}
- (void)rightPanAction : (UIPanGestureRecognizer *)pan
{
    CGPoint point = [pan locationInView:self.vc.view];
    NSLog(@"手势点point = %@___作用区域%f",NSStringFromCGPoint(point),[UIScreen mainScreen].bounds.size.width - self.drawerWidth);
    
    
    
    
    if (point.x > [UIScreen mainScreen].bounds.size.width - self.drawerWidth) {
        if (self.vc.view.frame.origin.x != 0) {
            if (self.vc.view.frame.origin.x >= self.drawerWidth / 2.0) {
                [self showDrawer];
            }else{
                [self dismissDrawer];
            }
        }
        return;
    }

    if (pan.state == UIGestureRecognizerStateChanged) {
        //得到需要移动的view
        UIView *view = self.vc.view;
        //得到我们在视图上移动的偏移量
        CGPoint currentPoint = [pan translationInView:view.superview];
        //    NSLog(@"%@",NSStringFromCGPoint(currentPoint));
        if ((view.frame.origin.x + currentPoint.x) < 0 || (view.frame.origin.x + currentPoint.x) > (self.drawerWidth)) {
            return;
        }
        //通过2D仿射变换函数中与位移有关的函数实现视图位置变化
        view.transform = CGAffineTransformTranslate(view.transform, currentPoint.x, 0);
        self.tableView.transform = CGAffineTransformTranslate(self.tableView.transform, currentPoint.x / 2.0, 0);
        /**
         *  渐变动画
         */
        self.tapView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:self.transparentScale * ( view.frame.origin.x / self.drawerWidth)];
        //复原 // 每次都是从00点开始
        [pan setTranslation:CGPointZero inView:view.superview];
    }else{
        if (self.vc.view.frame.origin.x >= self.drawerWidth / 2.0) {
            [self showDrawer];
        }else{
            [self dismissDrawer];
        }
        return;
    }
}
+ (UIViewController *)returnShowViewController
{
    if ([[self shareDrawer].vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav = [self shareDrawer].vc;
        return nav.viewControllers.lastObject;
    }else{
        return [self shareDrawer].vc;
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
