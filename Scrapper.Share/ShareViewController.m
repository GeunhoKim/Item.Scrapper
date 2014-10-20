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

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    NSExtensionContext *context = [self extensionContext];
    NSExtensionItem *item = [context inputItems].firstObject;
    NSItemProvider *provider = item.attachments.firstObject;
    
    [provider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(NSURL *url, NSError *error) {
        NSString *urlString = url.absoluteString;
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }];
    
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.

}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}

@end
