//
//  DTCHackerBooksBaseClass.h
//  HackerBooks_v2
//
//  Created by David de Tena on 24/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

@import CoreData;

@interface DTCHackerBooksBaseClass : NSManagedObject

#pragma mark - Class properties

// Array of observable properties for the class
+(NSArray *) observableKeys;

@end
