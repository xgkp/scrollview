//
//  ViewController.m
//  NewPagedFlowViewDemo
//
//  Copyright © 2016年 Mars. All rights reserved.
//  Designed By PageGuo,
//  QQ:799573715
//  github:https://github.com/PageGuo/NewPagedFlowView

#import "ViewController.h"
#import "NewPagedFlowView.h"
#import "PGIndexBannerSubiew.h"
#import "CustomViewController.h"

#define Width [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

/**
 *  图片数组
 */
@property (nonatomic, strong) NSMutableArray *imageArray;

/**
 *  指示label
 */
@property (nonatomic, strong) UILabel *indicateLabel;

@property(nonatomic ,assign) NSInteger index;

@property(nonatomic,assign) NSInteger indexOld;

@property(nonatomic,strong)NewPagedFlowView *pageFlowView ;

@property(nonatomic,strong) UITextField *tf;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index = 5;
    
    self.title = @"NewPagedFlowView";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Custom" style:UIBarButtonItemStyleDone target:self action:@selector(pushCustomVC)];
    
    for (int index = 0; index < 5; index++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"Yosemite%02d",index]];
        [self.imageArray addObject:image];
    }
    
    [self setupUI];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 300, 120, 50);
    [button setTitle:@"切换数组长度" forState:(UIControlStateNormal)];
    button.backgroundColor = [UIColor redColor];
    [button setTintColor: [UIColor redColor]];
    [button addTarget:self action:@selector(changeArrayLength) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
    self.tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 380, 120, 50)];
    [self.view addSubview:self.tf];
    
}

#pragma mark --push控制器
- (void)pushCustomVC {

    //完全自定义,注意两处 #warning !!!!!!!!!1
    CustomViewController *customVC = [[CustomViewController alloc] init];
    
    [self.navigationController pushViewController:customVC animated:YES];
}
-(void)changeArrayLength
{

    [_pageFlowView reloadData];
    
    if (self.index >= self.indexOld && self.indexOld != nil)
    {
        [_pageFlowView scrollToPage:self.indexOld ];
    }else
    {
        [_pageFlowView scrollToPage:0];
    }
    
}
- (void)setupUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    //初始化pageControl
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _pageFlowView.frame.size.height - 32, Width, 8)];
    self.pageFlowView.pageControl = pageControl;
    [_pageFlowView addSubview:pageControl];
    [_pageFlowView reloadData];
    
    [self.view addSubview:self.pageFlowView];
    
    //添加到主view上
    [self.view addSubview:self.indicateLabel];

}


#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(Width - 60, (Width - 60) * 9 / 16);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
    
    self.indicateLabel.text = [NSString stringWithFormat:@"点击了第%ld张图",(long)subIndex + 1];
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    
   
 
    if (pageNumber != nil && pageNumber != 0) {
        self.indexOld = pageNumber;
        NSLog(@"page number != nil ");

    }
    
    if (pageNumber == nil && pageNumber == 0) {
        NSLog(@"page number == nil ");
        self.indexOld = 0;
    }
    
    if (pageNumber == 0) {
        NSLog(@"page number == 0 ");

    }
    if (pageNumber != 0) {
        NSLog(@"page number != 0");
    }
    
    NSLog(@"----------------------------- --------------------------------");
    
    
    



}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.index;
    
}

- (PGIndexBannerSubiew *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = [flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] init];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    //在这里下载网络图片
    //  [bannerView.mainImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:hostUrlsImg,imageDict[@"img"]]] placeholderImage:[UIImage imageNamed:@""]];
    bannerView.mainImageView.image = self.imageArray[index];
    
    return bannerView;
}


#pragma mark --懒加载
- (NSMutableArray *)imageArray {
    if (_imageArray == nil) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (UILabel *)indicateLabel {
    
    if (_indicateLabel == nil) {
        _indicateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, Width, 16)];
        _indicateLabel.textColor = [UIColor blueColor];
        _indicateLabel.font = [UIFont systemFontOfSize:16.0];
        _indicateLabel.textAlignment = NSTextAlignmentCenter;
        _indicateLabel.text = @"指示Label";
    }
    
    return _indicateLabel;
}
-(NewPagedFlowView *)pageFlowView
{
    if (_pageFlowView == nil) {
     
        _pageFlowView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(0, 72, Width, Width * 9 / 16)];
        _pageFlowView.delegate = self;
        _pageFlowView.dataSource = self;
        _pageFlowView.minimumPageAlpha = 0.1;
        _pageFlowView.isCarousel = NO;
        _pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
        _pageFlowView.isOpenAutoScroll = YES;

    }
    return _pageFlowView;
}

@end
