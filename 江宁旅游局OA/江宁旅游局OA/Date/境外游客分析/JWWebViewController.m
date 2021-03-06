//
//  JWWebViewController.m
//  江宁旅游局OA
//
//  Created by 欣华pro on 2017/1/3.
//  Copyright © 2017年 xujw. All rights reserved.
//

#import "JWWebViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "DetailWebView.h"
@interface JWWebViewController ()
@property (nonatomic ,strong)  DetailWebView *webView;
@property (nonatomic ,strong)  UIView *opaqueView;
@property (nonatomic ,strong)  UIActivityIndicatorView *activityIndicatorView;
@end

@implementation JWWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"境外游客分析";
    [self creatWebView];
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
}

- (void)pop{
    
}

- (void)creatWebView{
    DetailWebView *webView = [[DetailWebView alloc] initWithFrame:ccr(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    NSURL *url = [NSURL URLWithString:@"https://baidu.com/"];
    [webView loadDataWithURL:url];
    [self.view addSubview:webView];
    self.webView = webView;
}

@end
