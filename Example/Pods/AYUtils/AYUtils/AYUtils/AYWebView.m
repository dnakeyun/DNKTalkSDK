//
//  AYWebView.m
//  AYUtils
//
//  Created by dnake_ay on 2019/9/26.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import "AYWebView.h"
#import <WebKit/WebKit.h>

@interface AYWebView () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation AYWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        
        self.webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        self.webView.contentScaleFactor = 0;
        self.webView.navigationDelegate = self;
        [self addSubview:self.webView];
        
        //进度条初始化
        self.progressView = [UIProgressView new];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        [self.webView addSubview:self.progressView];
        
        [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.webView.frame = self.bounds;
    
    self.progressView.frame = CGRectMake(0, 0, self.webView.frame.size.width, 2);
}
//加载URL
- (void)loadUrl:(NSString *)url
{
    if(@available(iOS 11, *)){
            //发送请求前插入cookie
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        WKHTTPCookieStore *cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore;
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStore setCookie:cookie completionHandler:^{
                
            }];
        }
    }
    NSURL *nsurl = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:request];
}
//加载本地HTML串
- (void)loadHTMLString:(NSString *)string
{
    if(@available(iOS 11, *)){
            //发送请求前插入cookie
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        WKHTTPCookieStore *cookieStore = self.webView.configuration.websiteDataStore.httpCookieStore;
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStore setCookie:cookie completionHandler:^{
                
            }];
        }
    }
    
    [self.webView loadHTMLString:string baseURL:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.webView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
                
            }];
        }
    } else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.webView)
        {
            //            NSLog(@"title - %@", self.webView.title);
            
            UIViewController *vc = [self findCurrentViewController];
            vc.title = self.webView.title;
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
        
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

-(void)dealloc{
    
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    
    [self.webView removeObserver:self forKeyPath:@"title"];
}

#pragma mark 下面连续的四个函数是对WKNavigationDelegate的实现
#pragma mark 开始加载数据
- (void) webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self bringSubviewToFront:self.progressView];
}

#pragma mark 数据返回 开始在界面上显示
- (void) webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation {
}

#pragma mark 数据加载完毕
- (void) webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {

    //  网页加载完成后禁止缩放
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, user-scalable=no\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    NSString *content = @"document.getElementById('jsonType').innerText";
    
    [webView evaluateJavaScript:content completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        
        NSString *jsContent = [NSString stringWithFormat:@"document.getElementById('jsonType').innerText = JSON.stringify(JSON.parse('%@'),null,2)", result];
        
        [webView evaluateJavaScript:jsContent completionHandler:nil];
        
        //返回当前加载的网址
        if ([self.webViewDelegate respondsToSelector:@selector(webView:didFinishLoadedWithURL:)]) {
            [self.webViewDelegate webView:self didFinishLoadedWithURL:webView.URL.absoluteString];
        }
    }];
}

#pragma mark 加载数据错误
- (void) webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(nonnull NSError *)error{
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // 如果是跳转一个新页面
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (void)goBack
{
    [self.webView goBack];
}

- (void)goForward
{
    //跳转到下级页面
    [self.webView goForward];
}

- (void)goRefreshCurrentPage
{
    [self.webView reload];
}

- (void)closePage
{
    //退出控制器
    UIViewController *vc = [self findCurrentViewController];
    [vc.navigationController popViewControllerAnimated:YES];
}

- (BOOL)canGoBack
{
    _canGoBack = self.webView.canGoBack;
    return self.webView.canGoBack;
}

- (BOOL)canGoForward
{
    _canGoForward = self.webView.canGoForward;
    return self.webView.canGoForward;
}

- (UIViewController *)findCurrentViewController
{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UIViewController *topViewController = [window rootViewController];
    
    while (true) {
        
        if (topViewController.presentedViewController) {
            
            topViewController = topViewController.presentedViewController;
            
        } else if ([topViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)topViewController topViewController]) {
            
            topViewController = [(UINavigationController *)topViewController topViewController];
            
        } else if ([topViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
            
        } else {
            break;
        }
    }
    return topViewController;
}

- (CGFloat)navigationBarHeight
{
    UIViewController *vc = [self findCurrentViewController];
    
    return vc.navigationController.navigationBar.frame.size.height;
}

- (CGFloat)statusBarHeight
{
    return [UIApplication sharedApplication].statusBarFrame.size.height;
}

- (CGFloat)tabbarHeight
{
    UIViewController *vc = [self findCurrentViewController];
    
    return vc.tabBarController.tabBar.frame.size.height;
}

@end
