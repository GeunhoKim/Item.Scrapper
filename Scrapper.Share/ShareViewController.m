//
//  ShareViewController.m
//  Scrapper.Share
//
//  Created by Geunho Khim on 2014. 10. 20..
//  Copyright (c) 2014년 com.ebay.kr.gkhim. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end


@implementation ShareViewController

- (BOOL)isContentValid {
    return YES;
}

- (void)didSelectPost {
    if([self.contentText containsString:@"http://"]) {
        NSString *urlString = [self getUrlStringFromContentText:self.contentText];
        [self.delegate foundUrl:urlString];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (NSArray *)configurationItems {
    return @[];
}

- (NSString *)getUrlStringFromContentText:(NSString *)contentText {
    NSString *parsedUrl = [contentText componentsSeparatedByString:@"http://"][1];
    NSString *returnUrl = [NSString stringWithFormat:@"http://%@", parsedUrl];
        
    return returnUrl;
}


@end
