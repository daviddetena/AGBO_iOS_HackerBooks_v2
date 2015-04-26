//
//  DTCCoreDataQueries.h
//  HackerBooks2
//
//  Created by David de Tena on 16/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import Foundation;
@import CoreData;
@class AGTCoreDataStack;

@interface DTCCoreDataQueries : NSObject

#pragma mark - Factory methods

// Method with the objects matching a request
+(NSArray *) resultsFromFetchForEntityName:(NSString *) entityName
                                  sortedBy:(NSString *) sortingField
                                 ascending:(BOOL) ascending
                                   inStack:(AGTCoreDataStack *) stack;

// Method with the objects matching a request with predicate
+(NSArray *) resultsFromFetchForEntityName:(NSString *) entityName
                                  sortedBy:(NSString *) sortingField
                                 ascending:(BOOL) ascending
                             withPredicate:(NSPredicate *) predicate
                                   inStack:(AGTCoreDataStack *) stack;

// Method with the objects matching a request with predicate and sort descriptors
+(NSArray *) resultsFromFetchForEntityName:(NSString *) entityName
                             withPredicate:(NSPredicate *) predicate
                           sortDescriptors:(NSArray *) sortDescriptors
                                   inStack:(AGTCoreDataStack *) stack;


@end
