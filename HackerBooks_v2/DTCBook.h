#import "_DTCBook.h"
@import UIKit;
@class AGTCoreDataStack;

@interface DTCBook : _DTCBook {}

#pragma mark - Properties
@property (nonatomic, strong, readonly) UIImage* coverImage;

#pragma mark - Factory inits
+(instancetype) bookWithDictionary:(NSDictionary *) dict
                             stack:(AGTCoreDataStack *) stack;

+(instancetype) bookWithArchivedURIRepresentation:(NSData *) archivedURI
                                            stack:(AGTCoreDataStack *) stack;


#pragma mark - Instance methods

-(NSString *) sortedListOfAuthors;
-(NSString *) sortedListOfTags;
-(NSData *) archiveURIRepresentation;


@end
