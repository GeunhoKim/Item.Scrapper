//
//  ShareViewController.m
//  Scrapper.Share
//
//  Created by Geunho Khim on 2014. 10. 20..
//  Copyright (c) 2014년 com.ebay.kr.gkhim. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ScrapperItem

+ (ScrapperItem *)item {
    ScrapperItem *item = [[ScrapperItem alloc] init];
    
    item.scrapDate = [NSDate date];
    
    return item;
}

@end

@implementation ShareViewController

- (BOOL)isContentValid {
    return YES;
}

- (void)didSelectPost {
    NSExtensionContext *context = [self extensionContext];
    NSExtensionItem *item = [context inputItems].firstObject;
    NSItemProvider *provider = item.attachments.firstObject;
    
    [provider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(NSURL *url, NSError *error) {
        NSString *urlString = url.absoluteString;
        ScrapperItem *item = [self requestScrapperWithUrlString:urlString];
        [self.extensionContext completeRequestReturningItems:@[item] completionHandler:nil];
    }];
}

- (NSArray *)configurationItems {
    return @[];
}

- (ScrapperItem *)requestScrapperWithUrlString:(NSString *)urlString {
    NSString *requestString = [NSString stringWithFormat:SCRAPPER_HOST@"/~geunho/run_scrapper.py?startUrl=%@", urlString];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];

    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                          returningResponse:&response
                                                      error:&error];
    if (!error) {
        ScrapperItem *item = [self parseResponseData:data];
        return item;
    } else {
        NSLog(@"error occured: %@", error.description);
        // TODO: popup dialog를 띄워줍니다. "해당 아이템을 스크랩 할 수 없습니다. 다시 시도해 주세요"
        return nil;
    }
}

- (ScrapperItem *)parseResponseData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    ScrapperItem *item = [ScrapperItem item];
    NSString *imageUrl = [json objectForKey:@"imageUrl"];
    item.imageUrl = imageUrl;
    NSString *title = [json objectForKey:@"title"];
    item.title = title;
    NSNumber *price = [json objectForKey:@"price"];
    item.price = price;
    NSString *formatPrice = [json objectForKey:@"formatPrice"];
    item.formatPrice = formatPrice;
    
    return item;
}

@end
