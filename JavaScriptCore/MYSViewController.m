//
//  MYSViewController.m
//  JavaScriptCore
//
//  Created by Dan Willoughby on 6/24/14.
//  Copyright (c) 2014 Mysterious Trousers. All rights reserved.
//
@import JavaScriptCore;
#import "MYSViewController.h"
#import "MTPocket.h"

@interface MYSViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong)          NSString            *defaultChatCSS;
@property (nonatomic, strong)          JSContext           *jsContext;
@end

@implementation MYSViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.jsContext[@"document"][@"body"][@"style"][@"background"] = @"steelblue";
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"firehose-chat-settings"]];
      //[self.jsContext[@"window"][@"App"] invokeMethod:@"setCustomCSS" withArguments:@[self.defaultChatCSS]];
    
    //[self.webView setFrameLoadDelegate:self];
    [self.webView  loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.exclusiveTouch = YES;
    self.webView.multipleTouchEnabled = YES;
    [self fetchDefaultCSS:^(void) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.jsContext[@"window"][@"App"] invokeMethod:@"setCustomCSS" withArguments:@[self.defaultChatCSS]];
        });
    }];

    //[[self.webView  setAllowsScrolling:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchDefaultCSS:(void (^)(void))completion
{
    if (self.defaultChatCSS == nil) {
        
        NSURL *url = [NSURL URLWithString:@"https://firehosechat.com/default.css"];
        
        MTPocketRequest *websiteRequest = [MTPocketRequest requestWithURL:url method:MTPocketMethodGET body:nil];
        [websiteRequest sendWithSuccess:^(MTPocketResponse *response) {
            NSString *defaults  = response.text;
            self.defaultChatCSS = defaults;
            if (completion) completion();
        } failure:^(MTPocketResponse *response) {
        }];
    }
    else {
        if (completion) completion();
    }
}


@end
