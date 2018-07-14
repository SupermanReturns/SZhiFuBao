//
//  ViewController.m
//  SZhiFuBao
//
//  Created by Superman on 2018/7/12.
//  Copyright © 2018年 Superman. All rights reserved.
//

#import "ViewController.h"
#import "SingleView.h"
#import "DetailViewController.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define kMarginWidth self.view.frame.size.width/5//九宫格的宽高

@interface ViewController ()<SingleViewDelegate> {
    UIScrollView *_scrollView;
    SingleView *_singView;
    BOOL isMove;
    CGPoint rects;
}

@property (nonatomic, strong) NSMutableArray *singTag;
@property (nonatomic, strong) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableArray *singArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 标题字体和颜色
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor], NSForegroundColorAttributeName,
                                [UIFont boldSystemFontOfSize:21], NSFontAttributeName,
                                nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.titleArr = [NSMutableArray arrayWithObjects:
                     @{@"title": @"生活缴费"},
                     @{@"title": @"淘票票"},
                     @{@"title": @"股票"},
                     @{@"title": @"滴滴出行"},
                     @{@"title": @"红包"},
                     @{@"title": @"亲密付"},
                     @{@"title": @"生超市惠"},
                     @{@"title": @"我的快递"},
                     @{@"title": @"游戏中心"},
                     @{@"title": @"我的客服"},
                     @{@"title": @"爱心捐赠"},
                     @{@"title": @"亲情账户"},
                     @{@"title": @"淘宝"},
                     @{@"title": @"天猫"},
                     @{@"title": @"天猫超市"},
                     @{@"title": @"城市服务"},
                     @{@"title": @"保险服务"},
                     @{@"title": @"飞机票"}, nil];
    self.singTag = [NSMutableArray arrayWithObjects:@"100", @"101", @"102", @"103", @"104", @"105", @"106", @"107", @"108", @"109", @"110", @"111", @"112", @"113", @"114", @"115", @"116", @"117", nil];
    self.view.backgroundColor = [UIColor colorWithWhite:0.900 alpha:1.0];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.900 alpha:0.100];
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    
    [self initView];
}
//生成九宫格
- (void)initView
{
    self.singArray = [NSMutableArray array];
    
    CGFloat widthx, heighty;
    widthx = 0;
    heighty = 10;
    for (int i = 0; i < self.titleArr.count; i++) {
        
        NSString *title = self.titleArr[i][@"title"];
        
        SingleView *singview = [[SingleView alloc] initWithFrame:CGRectMake(widthx, heighty, kMarginWidth-1, kMarginWidth-1) title:title];
        singview.delegate = self;
        [_scrollView addSubview:singview];
        
        widthx = widthx + kMarginWidth;
        if (widthx == SCREEN_WIDTH) {
            widthx = 0;
            heighty+=kMarginWidth;
        }
        singview.tagid = self.singTag[i];
        singview.viewPoint = singview.center;
        [_singArray addObject:singview];
        
    }
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, heighty);
}
- (void)clickOneViewReturnTitle:(NSString *)title
{
    //根据title确定进入哪一个详情页
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.title = title;
    [self.navigationController pushViewController:detailVC animated:YES];
    NSLog(@"%@", title);
}

- (void)beginMoveAction:(NSString *)tag
{
    SingleView *singView;
    for (int i = 0; i < self.singArray.count; i++) {
        singView = self.singArray[i];
        if (tag == singView.tagid) {
            break;
        }
    }
    
    [_scrollView bringSubviewToFront:singView];
    rects = singView.viewPoint;
    singView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    _singView = singView;
    
}

- (void)moveViewAction:(NSString *)tag gesture:(UILongPressGestureRecognizer *)gesture
{
    
    
    
    //移动前的tagid值
    NSInteger fromtag = [_singView.tagid intValue];
    //移动后的新坐标
    CGPoint newPoint = [gesture locationInView:_scrollView];
    
    //移动后的X坐标
    CGFloat moveX = newPoint.x - _singView.frame.origin.x;
    //移动后的Y坐标
    CGFloat moveY = newPoint.y - _singView.frame.origin.y;
    //跟随手势移动
    _singView.center = CGPointMake(_singView.center.x + moveX-kMarginWidth/2, _singView.center.y + moveY-kMarginWidth/2);
    //目标位置
    NSInteger toIndex = [ViewController indexOfPoint:_singView.center withUiview:_singView singArray:_singArray];
    
    //向前拖动
    if (toIndex<fromtag-100 && toIndex>=0) {
        isMove = YES;
        NSInteger beginIndex = fromtag-100;
        SingleView *toView = self.singArray[toIndex];
        _singView.center = toView.viewPoint;
        rects = toView.viewPoint;
        for (NSInteger j = beginIndex; j > toIndex; j--) {
            
            SingleView *singView1 = self.singArray[j];
            SingleView *singView2 = self.singArray[j-1];
            
            [UIView animateWithDuration:0.5 animations:^{
                singView2.center = singView1.viewPoint;
                
            }];
            
        }
        //处理数组
        [_singArray removeObject:_singView];
        [_singArray insertObject:_singView atIndex:toIndex];
        
        [self manageTagAndCenter];
    }
    
    //向后拖动
    if (toIndex>fromtag-100 && toIndex<_singArray.count) {
        isMove = YES;
        NSInteger beginIndex = fromtag-100;
        SingleView *toView = self.singArray[toIndex];
        _singView.center = toView.viewPoint;
        rects = toView.viewPoint;
        for (NSInteger j = beginIndex; j < toIndex; j++) {
            
            SingleView *singView1 = self.singArray[j];
            SingleView *singView2 = self.singArray[j+1];
            
            [UIView animateWithDuration:0.5 animations:^{
                singView2.center = singView1.viewPoint;
            }];
            
        }
        [_singArray removeObject:_singView];
        [_singArray insertObject:_singView atIndex:toIndex];
        
        [self manageTagAndCenter];
        
    }
    
}

- (void)endMoveViewAction:(NSString *)tag
{
    _singView.center = rects;
    _singView.transform = CGAffineTransformIdentity;
    
}

- (void)manageTagAndCenter
{
    //处理tagid值和中心
    for (NSInteger i = 0; i < _singArray.count; i++) {
        SingleView *gridItem = _singArray[i];
        gridItem.tagid = _singTag[i];
        gridItem.viewPoint = gridItem.center;
    }
}

+ (NSInteger)indexOfPoint:(CGPoint)point
               withUiview:(UIView *)view singArray:(NSMutableArray *)singArray
{
    for (NSInteger i = 0;i< singArray.count;i++)
    {
        UIView *singVi = singArray[i];
        if (singVi != view)
        {
            if (CGRectContainsPoint(singVi.frame, point))
            {
                return i;
            }
        }
    }
    return -100;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end























