//
//  DTCHackerBooksBaseClass.m
//  HackerBooks_v2
//
//  Created by David de Tena on 24/04/15.
//  Copyright (c) 2015 David de Tena. All rights reserved.
//

#import "DTCHackerBooksBaseClass.h"

@implementation DTCHackerBooksBaseClass

#pragma mark - Class properties
// Array of observable properties for the class
+(NSArray *) observableKeys{
    return @[];
}

#pragma mark - NSManagedObject lifecycle

/**
    Executed once in lifecycle. Need to setup KVO for changes
 */
-(void)awakeFromInsert{

    [super awakeFromInsert];
    [self setupKVO];
}

/**
    Executed several times in lifecycle, when back from faulting
    or getting from DB. Need to setup KVO for changes
 */
-(void)awakeFromFetch{
    
    [super awakeFromFetch];
    [self setupKVO];
}

/**
    Executed several times in lifecycle, when getting empty 
    and turning into fault. Need to tear down KVO
 */
-(void)willTurnIntoFault{

    [super willTurnIntoFault];
    [self tearDownKVO];
}


#pragma mark - KVO

/**
    Observe for all necessary properties
 */
-(void)setupKVO{
    
    for (NSString *key in [[self class] observableKeys]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:NULL];
    }
}

/**
    Stop observing for all necessary properties
 */
-(void)tearDownKVO{
    
    for (NSString *key in [[self class] observableKeys]) {
        [self removeObserver:self forKeyPath:key];
    }
}



@end
