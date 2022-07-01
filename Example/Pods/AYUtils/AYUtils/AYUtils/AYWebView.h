//
//  AYWebView.h
//  AYUtils
//
//  Created by dnake_ay on 2019/9/26.
//  Copyright © 2019 dnake_ay. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AYWebView;

@protocol AYWebViewDelegate <NSObject>

- (void)webView:(AYWebView *_Nullable)webView didFinishLoadedWithURL:(NSString *_Nullable)url;

@end

NS_ASSUME_NONNULL_BEGIN

@interface AYWebView : UIView

//是否能上一页
@property (assign, nonatomic) BOOL canGoBack;
//是否能下一页
@property (assign, nonatomic) BOOL canGoForward;

//加载URL
- (void)loadUrl:(NSString *)url;
//加载HTML
- (void)loadHTMLString:(NSString *)string;

//返回上一级
- (void)goBack;
//跳转下一级
- (void)goForward;
//刷新当前页
- (void)goRefreshCurrentPage;
//关闭网页（popViewController）
- (void)closePage;

@property (weak, nonatomic) id <AYWebViewDelegate> webViewDelegate;

@end

NS_ASSUME_NONNULL_END
