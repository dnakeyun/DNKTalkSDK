# DNKTalkSDKDemo

支持Cocoapods

pod 'DNKTalkSDK'

使用：在需要使用到的地方导入狄耐克对讲库头文件

#import <DNKTalkSDK/DNKTalkManager.h>

在PrefixHeader.pch配置Sip信息

(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

//sip初始化

[[DNKTalkManager sharedInstance] initSDK];

//收到门口机呼叫消息

[[DNKTalkManager sharedInstance] setReceiveCallingSuccessBlock:^{

  //跳转到呼叫界面监视
}];

//收到门口机挂断消息

[[DNKTalkManager sharedInstance] setTalkStopBlock:^{

  //退出监视界面
}];

return YES;

}

//Sip注册

(void)registerSip {

//new一个配置sip的实体对象

SipConfigEntity *sipConfigEntity = [SipConfigEntity new];

sipConfigEntity.node = @"Sip服务器地址";

sipConfigEntity.user = @"Sip账号";

sipConfigEntity.passwd = @"Sip密码";

//注册

[[DNKTalkManager sharedInstance] setSipConfigWithSipConfigEntity:sipConfigEntity];

}

其他Api：

监听Sip是否注册上（在线）

[[DNKTalkManager sharedInstance] setSipStatusBlock:^(int status) {

//处理展示Sip在线状态
}];

开锁：

[[DNKTalkManager sharedInstance] unLockWithSipAccount:@"目标门口机的Sip账号"];

具体接口请查看Demo。
