//
//  ItemEntity.h
//  Item.Scrapper
//
//  Created by Geunho Khim on 2014. 10. 26..
//  Copyright (c) 2014년 com.ebay.kr.gkhim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ItemEntity : NSManagedObject

@property (nonatomic, retain) NSString * formatPrice;
@property (nonatomic, retain) NSString * imageUrl;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) NSString * title;

@end
