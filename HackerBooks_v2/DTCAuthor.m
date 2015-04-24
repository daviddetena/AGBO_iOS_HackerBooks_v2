#import "DTCAuthor.h"
#import "AGTCoreDataStack.h"
#import "DTCCoreDataQueries.h"

@interface DTCAuthor ()

// Private interface goes here.

@end

@implementation DTCAuthor

#pragma mark - Factory init
+(instancetype) authorWithName:(NSString *) name
                         stack:(AGTCoreDataStack *) stack{

    // Check out if a author with that name already exists
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",name];
    NSArray *results = [DTCCoreDataQueries resultsFromFetchForEntityName:[DTCAuthor entityName]
                                                                sortedBy:DTCAuthorAttributes.name
                                                               ascending:YES
                                                           withPredicate:predicate
                                                                 inStack:stack];
    DTCAuthor *author = nil;
    
    if ([results count]!=0) {
        // Author already exists. Take from CoreData
        author = (DTCAuthor *) [results lastObject];
    }
    else{
        // Author does not exist. Create
        author = [DTCAuthor insertInManagedObjectContext:stack.context];
        author.name = name;
    }
    return author;
}

@end
