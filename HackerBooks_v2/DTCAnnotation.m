#import "DTCAnnotation.h"
#import "DTCBook.h"
#import "DTCPhoto.h"
#import "AGTCoreDataStack.h"

@interface DTCAnnotation ()

// Private interface goes here.

@end

@implementation DTCAnnotation


#pragma mark - Class methods
/*
 Set the properties this object will observe for
 */
+(NSArray *) observableKeys{
    return @[DTCAnnotationAttributes.name,
             DTCAnnotationAttributes.text,
             DTCAnnotationRelationships.book,
             @"photo.photoData"];
}



#pragma mark - Factory init
+(instancetype) annotationWithName:(NSString *) name
                              book:(DTCBook *) book
                             stack:(AGTCoreDataStack *) stack{

    DTCAnnotation *annotation = [DTCAnnotation insertInManagedObjectContext:stack.context];
    
    // Set mandatory properties
    annotation.name = name;
    annotation.book = book;
    annotation.creationDate = [NSDate date];
    annotation.modificationDate = [NSDate date];
    annotation.photo = [DTCPhoto insertInManagedObjectContext:stack.context];
    
    return annotation;
}



#pragma mark - KVO

/*
    When any property (except for the modificationDate)
    changes, the object will receive a notification.
    In this case, we want the modificationDate of the
    annotation to change with every change in the object
 */
-(void) observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    
    self.modificationDate = [NSDate date];
}

@end
