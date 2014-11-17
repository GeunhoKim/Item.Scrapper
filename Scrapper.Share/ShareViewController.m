//
//  ShareViewController.m
//  Scrapper.Share
//
//  Created by Geunho Khim on 2014. 10. 20..
//  Copyright (c) 2014년 com.ebay.kr.gkhim. All rights reserved.
//

#import "ShareViewController.h"
#import "ItemEntity.h"

@interface ShareViewController ()

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;

@end


@implementation ShareViewController

- (BOOL)isContentValid {
    return YES;
}

- (void)didSelectPost {
    NSExtensionContext *context = [self extensionContext];
    NSExtensionItem *inputItem = [context inputItems].firstObject;
    NSItemProvider *provider = inputItem.attachments.firstObject;
    
    [provider loadItemForTypeIdentifier:@"public.url" options:nil completionHandler:^(NSURL *url, NSError *error) {
        NSString *urlString = url.absoluteString;
        [self requestScrapperWithUrlString:urlString];
        
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }];
}

- (NSArray *)configurationItems {
    [self setupManagedObjectContext];
    
    return @[];
}

- (void)requestScrapperWithUrlString:(NSString *)urlString {
    NSString *requestString = [NSString stringWithFormat:SCRAPPER_HOST@"/~geunho/run_scrapper.py?startUrl=%@", urlString];
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
        // TODO: popup dialog를 띄워줍니다. "해당 아이템을 스크랩 할 수 없습니다. 다시 시도해 주세요"
    }
}

- (void)parseResponseDataAndInsert:(NSData *)responseData url:(NSString *)urlString {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData
                                                         options:kNilOptions
                                                           error:&error];
    if(error) {
        NSLog(@"Json serialization exception: %@", error);
        return;
    }
    
    ItemEntity *item = [NSEntityDescription insertNewObjectForEntityForName:@"ItemEntity"
                                                     inManagedObjectContext:self.managedObjectContext];
    
    item.linkUrl = urlString;
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
    }
    else {
        NSLog(@"Item Not Saved.");
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
    }
    
    self.managedObjectContext.undoManager = [[NSUndoManager alloc] init];
}



@end
