#import "DTCBook.h"
#import "DTCAuthor.h"
#import "DTCTag.h"
#import "DTCPhoto.h"
#import "DTCPdf.h"
#import "AGTCoreDataStack.h"
#import "DTCHelpers.h"
#import "BookSettings.h"

@interface DTCBook ()

// Private interface goes here.

@end

@implementation DTCBook

#pragma mark - Properties

-(UIImage *) coverImage{
    return [UIImage imageWithData:self.photo.photoData];
}


#pragma mark - Factory inits
+(instancetype) bookWithDictionary:(NSDictionary *) dict
                             stack:(AGTCoreDataStack *) stack{

    DTCBook *book = [DTCBook insertInManagedObjectContext:stack.context];
    
    // Set mandatory properties
    NSArray *arrayOfAuthors = [DTCHelpers arrayOfItemsFromString:[dict objectForKey:AUTHORS] separatedBy:@", "];
    NSArray *arrayOfTags = [DTCHelpers arrayOfItemsFromString:[dict objectForKey:TAGS] separatedBy:@", "];
    
    book.title = [dict objectForKey:TITLE];
    
    // Create and set authors
    for (NSString *authorName in arrayOfAuthors) {
        DTCAuthor *author = [DTCAuthor authorWithName:authorName stack:stack];
        [book addAuthorsObject:author];
    }
    
    // Create and set tags
    for (NSString *tagName in arrayOfTags) {
        DTCTag *tag = [DTCTag tagWithName:tagName stack:stack];
        [book addTagsObject:tag];
    }
    
    // Create and set image
    book.coverUrl = [dict objectForKey:IMAGE_URL];
    book.photo = [DTCPhoto photoForBookWithURL:[NSURL URLWithString:book.coverUrl]
                                  defaultImage:[UIImage imageNamed:@"emptyBookCover.png"]
                                         stack:stack];

    // Create and set pdf. Nothing special when creating pdf
    book.pdfUrl = [dict objectForKey:PDF_URL];
    book.pdf = [DTCPdf insertInManagedObjectContext:stack.context];
    
    
    return book;
}


/**
    This class init returns a DTCBook object from the uri of its objectID
    property saved in CoreData
 */
+(instancetype) bookWithArchivedURIRepresentation:(NSData *) archivedURI
                                            stack:(AGTCoreDataStack *) stack{

    NSURL *uri = [NSKeyedUnarchiver unarchiveObjectWithData:archivedURI];
    if (uri == nil) {
        return nil;
    }
    
    NSManagedObjectID *nid = [stack.context.persistentStoreCoordinator
                              managedObjectIDForURIRepresentation:uri];
    
    if (nid == nil) {
        return nil;
    }
    
    NSManagedObject *obj = [stack.context objectWithID:nid];
    if (obj.isFault) {
        // Got it !
        return (DTCBook *) obj;
    }
    else{
        // Might not exist anymore. Let's fetch it!
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:obj.entity.name];
        req.predicate = [NSPredicate predicateWithFormat:@"SELF = %@",obj];
        
        NSError *error;
        NSArray *res = [stack.context executeFetchRequest:req
                                                    error:&error];
        
        if (res == nil) {
            return nil;
        }
        else{
            return [res lastObject];
        }
    }
}


#pragma mark - Utils
// TRY TO IMPLEMENT A GENERIC METHOD FOR THESE TWO

// Return the author(s) of a book in a string
-(NSString *) sortedListOfAuthors{
    
    // Standarize case, sort, join with comma
    NSArray *all = [self.authors allObjects];
    NSMutableArray *authors = [NSMutableArray arrayWithCapacity:all.count];
    for (DTCAuthor *author in all) {
        [authors addObject:author.name];
    }
    NSString *contat = [authors componentsJoinedByString:@", "];
    return contat;
}


// Return the tag(s) of a book in a string
// Return the author(s) of a book in a string
-(NSString *) sortedListOfTags{
    
    // Standarize case, sort, join with comma
    NSArray *all = [self.tags allObjects];
    NSMutableArray *tags = [NSMutableArray arrayWithCapacity:all.count];
    for (DTCTag *tag in all) {
        [tags addObject:tag.name];
    }
    NSString *contat = [tags componentsJoinedByString:@", "];
    return contat;
}


// Returns an NSData with the serialized URI representation of the objectID.
// Ready to save it in a NSUserDefaults, for example
-(NSData *) archiveURIRepresentation{
    NSURL *uri = self.objectID.URIRepresentation;
    return [NSKeyedArchiver archivedDataWithRootObject:uri];
}

@end
