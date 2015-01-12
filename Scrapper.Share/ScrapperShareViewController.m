//
//  ScrapperShareViewController.m
//  Item Scrapper
//
//  Created by Geunho Khim on 12/18/14.
//  Copyright (c) 2014 com.ebay.kr.gkhim. All rights reserved.
//

#import "ScrapperShareViewController.h"

@interface ScrapperShareViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end


@implementation ScrapperShareViewController

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidAppear:(BOOL)animated {
    
    NSExtensionContext *context = [self extensionContext];
    NSExtensionItem *inputItem = [context inputItems].firstObject;
    NSItemProvider *provider = inputItem.attachments.firstObject;
    NSString *contentText = [inputItem.attributedContentText string];
    NSString *pasteBoardString = [UIPasteboard generalPasteboard].string;
    
    if([provider hasItemConformingToTypeIdentifier:@"public.url"]) {
        [provider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(NSURL *url, NSError *error) {
            NSString *urlString = url.absoluteString;
            [self requestScrapperWithUrlString:urlString];
        }];
    }
    else if([contentText containsString:@"http://"] || [contentText containsString:@"https://"]) {
        NSString *urlString = [self getUrlStringFromContentText:contentText];
        [self requestScrapperWithUrlString:urlString];
    }
    else if([pasteBoardString containsString:@"http://"]) {
        [[UIPasteboard generalPasteboard] setValue:@"" forPasteboardType:UIPasteboardNameGeneral];
        NSString *urlString = [self getUrlStringFromContentText:pasteBoardString];
        [self requestScrapperWithUrlString:urlString];
    }
    else {
        [self showAlertWithMessage:@"Can not find item. Please try another one."];
    }
}

#pragma mark ShareViewController Delegate

- (void)foundUrl:(NSString *)url {
    if (url != nil && ![url isEqualToString:@""]) {
        [self requestScrapperWithUrlString:url];
    } else {
        [self showAlertWithMessage:@"Can not scrap the item. Please try again."];
    }
}

- (void)viewDidLoad {
    [self setupManagedObjectContext];
    
    UIImage *bgImage = [UIImage imageNamed:@"popup_bg.png"];
    self.backgroundImage.image = [bgImage stretchableImageWithLeftCapWidth:bgImage.size.width / 2
                                                              topCapHeight:bgImage.size.height / 2];
}

- (NSString *)getUrlStringFromContentText:(NSString *)contentText {
    
    NSString *parsedUrl = @"";
    if ([contentText containsString:@"http://"]) {
        parsedUrl = [contentText componentsSeparatedByString:@"http://"][1];
    }
    else if ([contentText containsString:@"https://"]) {
        parsedUrl = [contentText componentsSeparatedByString:@"https://"][1];
    }
    
    
    NSString *returnUrl = [NSString stringWithFormat:@"http://%@", parsedUrl];
    
    return returnUrl;
}

- (void)requestScrapperWithUrlString:(NSString *)urlString {
    NSString *formatUrl = [urlString stringByReplacingOccurrencesOfString:@"&" withString:@""];
    NSString *requestString = [NSString stringWithFormat:SCRAPPER_HOST@"/script/scrapper/run_scrapper.py?startUrl=%@", formatUrl];
    requestString = [requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    NSURLResponse *response = nil;
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                         returningResponse:&response
                                                     error:&error];
    if (!error) {
        [self parseResponseDataAndInsert:data url:urlString];
    } else {
        NSLog(@"error occured: %@", error.description);
        [self showAlertWithMessage:@"Can not scrap the item. Please try again."];
    }
}

- (void)showAlertWithMessage:(NSString *)message {
    [UIView animateWithDuration:0.4 animations:^{
        self.activityIndicator.hidden = YES;
        self.descriptionLabel.text = message;
        [self.view layoutIfNeeded];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(dismissAlert:) withObject:self.extensionContext afterDelay:1.5];
    });
}

- (void)dismissAlert:(NSExtensionContext *)context {
    [context completeRequestReturningItems:@[] completionHandler:nil];
}

- (void)parseResponseDataAndInsert:(NSData *)responseData url:(NSString *)urlString {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    if(error || [json count] == 0) {
        NSLog(@"Json serialization exception: %@", error);
        [self showAlertWithMessage:@"Json parse error. Cannot scrap the item."];
    }
    else {
        
        ItemEntity *item = [NSEntityDescription insertNewObjectForEntityForName:@"ItemEntity"
                                                         inManagedObjectContext:self.managedObjectContext];
        
        item.linkUrl = urlString;
        NSString *kindOf = [json objectForKey:@"kindOf"];
        item.kindOf = kindOf;
        NSString *itemno = [json objectForKey:@"itemno"];
        item.itemno = itemno;
        NSString *imageUrl = [json objectForKey:@"imageUrl"];
        item.imageUrl = imageUrl;
        NSString *title = [json objectForKey:@"title"];
        item.title = title;
        NSNumber *price = [json objectForKey:@"price"];
        item.price = price;
        NSString *formatPrice = [json objectForKey:@"formatPrice"];
        item.formatPrice = formatPrice;
        item.timestamp = [NSDate date];
        
        if ([self.managedObjectContext save:&error]) {
            NSLog(@"Item Saved");
            [self showAlertWithMessage:@"Scrap success."];
        }
        else {
            NSLog(@"Item Not Saved.");
            [self showAlertWithMessage:@"Can not scrap the item. Please try again."];
        }
    }
}

- (void)setupManagedObjectContext {
    
    NSURL *directory = [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.com.ebay.kr.gkhim.scrapper"];
    NSURL *storeURL = [directory  URLByAppendingPathComponent:@"ItemScrapper.sqlite"];
    
    self.managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ItemScrapper" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    self.managedObjectContext.persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    NSError *error;
    [self.managedObjectContext.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                                       configuration:nil
                                                                                 URL:storeURL
                                                                             options:nil
                                                                               error:&error];
    if (error) {
        NSLog(@"error: %@", error);
        [self showAlertWithMessage:@"Can not scrap the item. Please try again."];
    }
    
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}

@end
