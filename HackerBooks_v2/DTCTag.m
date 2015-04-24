#import "DTCTag.h"
#import "AGTCoreDataStack.h"
#import "DTCCoreDataQueries.h"

@interface DTCTag ()

// Private interface goes here.

@end

@implementation DTCTag

#pragma mark - Factory init
+(instancetype) tagWithName:(NSString *) name
                      stack:(AGTCoreDataStack *) stack{
    
    // Check out if a tag with that name already exists
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSArray *results = [DTCCoreDataQueries resultsFromFetchForEntityName:[DTCTag entityName]
                                                                sortedBy:DTCTagAttributes.name
                                                               ascending:YES
                                                           withPredicate:predicate
                                                                 inStack:stack];
    DTCTag *tag = nil;
    
    if ([results count]!=0) {
        // Tag already exists. Take from CoreData
        tag = (DTCTag *) [results lastObject];
    }
    else{
        // Tag does not exist. Create
        tag = [DTCTag insertInManagedObjectContext:stack.context];
        tag.name = name;
    }
    
    return tag;
}



@end
