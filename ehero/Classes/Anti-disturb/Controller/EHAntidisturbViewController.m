//
//  EHAntidisturbViewController.m
//  ehero
//
//  Created by Mac on 16/7/10.
//  Copyright © 2016年 ehero. All rights reserved.
//

#import "EHAntidisturbViewController.h"
#import <WebKit/WebKit.h>
#import "MZTimerLabel.h"
#import "YTHttpTool.h"
#import "EHRegularExpression.h"
@interface EHAntidisturbViewController ()<WKNavigationDelegate,MZTimerLabelDelegate,UITextFieldDelegate>
{
    CGRect resendBtnRect;
}
@property (weak, nonatomic) IBOutlet UITextField *myPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *otherPhone;
@property (nonatomic,strong)MZTimerLabel *timer;
@property (nonatomic,strong) UIButton *sendCodeBtn;

@property (nonatomic,strong)WKWebView *webView;
@end

@implementation EHAntidisturbViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self webViewLoad];
    
    
    [self setupCountdownBtn];
    
}

- (void)setupCountdownBtn{
    UIButton *sendCodeBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.myPhoneNumber.bounds.size.width / 3.5, self.myPhoneNumber.bounds.size.height)];
    //获取按钮大小
    resendBtnRect = sendCodeBtn.frame;
    // +25 是重新发送验证码的按钮宽度
    resendBtnRect.size.width = resendBtnRect.size.width + 25;
    
    [sendCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    sendCodeBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    sendCodeBtn.titleLabel.textColor = [UIColor whiteColor];
    [sendCodeBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    
    [sendCodeBtn setBackgroundImage:[UIImage imageNamed:@"sendCodeBtn"] forState:UIControlStateNormal];
    [sendCodeBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    self.sendCodeBtn =  sendCodeBtn;
    
    
    self.myPhoneNumber.rightView = _sendCodeBtn;
    self.myPhoneNumber.rightViewMode = UITextFieldViewModeAlways;
    //添加边框
    self.code.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    self.myPhoneNumber.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    
    [self setTimer];
    [self addGesture];
    self.myPhoneNumber.delegate =  self;
    self.code.delegate = self;
    
    
}



- (void)setTimer{
    self.timer = [[MZTimerLabel alloc] initWithLabel:self.sendCodeBtn.titleLabel andTimerType:MZTimerLabelTypeTimer];
    self.timer.timeFormat = @"ss 秒";
    [self.timer setCountDownTime:60];
    //设置代理
    self.timer.delegate = self;
}


- (void)sendClick{
    
    if ([self.timer counting]) {
        //如果正在计时，则按钮不可点击
        self.sendCodeBtn.alpha = 0.7;
        self.sendCodeBtn.userInteractionEnabled = NO;
        
    }else{
        //正则表达式判断电话号码，电话格式正确，才可以发送
        if ([EHRegularExpression validateMobile:self.myPhoneNumber.text ]) {
            self.sendCodeBtn.userInteractionEnabled = YES;
            [self.sendCodeBtn setFrame:CGRectMake(self.myPhoneNumber.bounds.size.width - self.sendCodeBtn.bounds.size.width, 0, self.myPhoneNumber.bounds.size.width / 6, self.myPhoneNumber.bounds.size.height)];
            [self.timer start];
            //计时启动后不可点击
            self.sendCodeBtn.alpha = 0.7;
            self.sendCodeBtn.userInteractionEnabled = NO;
            [self sendCodeRequest];
            
        }else{
            //电话格式填写错误，不能点击发送按钮
            [MBProgressHUD showError:@"电话格式错误" toView:self.view];
        }
        
    }
    
}

#pragma mark - 倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    
    //宽度变化
    [self.sendCodeBtn setFrame:resendBtnRect];
    //可以点击
    self.sendCodeBtn.alpha = 1;
    self.sendCodeBtn.userInteractionEnabled = YES;
    [self.sendCodeBtn setTitle:@"重新发送验证码" forState:UIControlStateNormal];
    [self.sendCodeBtn.titleLabel setFont:[UIFont systemFontOfSize: 14.0]];
    NSLog(@"倒计时结束");
}

- (void)sendCodeRequest{
    
    NSDictionary *params = @{@"mobile":self.myPhoneNumber.text};
    [YTHttpTool post:sendCodeUrlStr params:params success:^(id responseObj) {
        NSLog(@"success");
    } failure:^(NSError *error) {
        NSLog(@"faild,%@",error);
    }];
}

- (void)addGesture{
    //添加手势相应，输textfield时，点击其他区域，键盘消失
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}

#pragma mark  - UITapGestureRecognizer
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.myPhoneNumber resignFirstResponder];
    [self.code resignFirstResponder];
    [self.otherPhone resignFirstResponder];
}

#pragma mark  - uiTextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.myPhoneNumber resignFirstResponder];
    [self.code resignFirstResponder];
    [self.otherPhone resignFirstResponder];
    return YES;
}
/*
#pragma mark - 开始输入时，视图上移
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect frame = textField.frame;
    
    int offset = frame.origin.y + 0 - (self.view.frame.size.height - 263.0);//iPhone键盘高度216，iPad的为352,这里设成263更方便，并且考虑到搜狗的键盘比系统的键盘高一点
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:0.5f];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    
    if(offset < -15)
        
        self.view.frame = CGRectMake(0.0f, offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

#pragma mark - 输入框编辑完成以后，将视图恢复到原始状态
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}
#pragma mark - 初始化网页
- (void)webViewLoad{
    WKWebView *webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    webView.scrollView.bounces = NO;
    self.webView = webView;
    [self.view addSubview:_webView];
    self.webView.navigationDelegate = self;
    
    NSURL *url = [NSURL URLWithString:@"http://ehero.cc/helper"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
    
}

#pragma mark - webview delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [LBProgressHUD showHUDto:self.view animated:NO];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [LBProgressHUD hideAllHUDsForView:self.view animated:NO];
}
 */
@end
