//
//  DetailViewController.m
//  Item Scrapper
//
//  Created by ebaymobile on 1/16/15.
//  Copyright (c) 2015 com.ebay.kr.gkhim. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController

+ (DetailViewController *)getViewController {
    DetailViewController *viewController = [[DetailViewController alloc]
                                                 initWithNibName:@"DetailViewController"
                                                 bundle:nil];
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = request.URL.absoluteString.lowercaseString;
    
    if (![url hasPrefix:@"http"]) {
        return NO;
    } else {
        return YES;
    }
}

- (void)request {
    NSString *urlString = [SharedInstance singleton].detailUrl;
    
    if(![self.webView.request.URL.absoluteString isEqualToString:urlString]) {
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

        [self.webView loadRequest:request];
    }
}


@end
