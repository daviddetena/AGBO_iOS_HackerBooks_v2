
#define DTCBOOK_DID_CHANGE_NOTIFICATION @"DTCBOOK_DID_CHANGE_NOTIFICATION"
#define DTCBOOK_CHANGE_KEY @"DTCBOOK_KEY"


#import "_DTCBook.h"
@import UIKit;

@class AGTCoreDataStack;
@class DTCBook;


#pragma mark - Protocol definition
@protocol DTCBookDelegate <NSObject>

-(void) bookDidChange:(DTCBook *) book;

@end


@interface DTCBook : _DTCBook {}

#pragma mark - Properties
@property (nonatomic) BOOL isFavorite;
@property (nonatomic, strong, readonly) UIImage* coverImage;


// Delegate
@property (weak, nonatomic) id<DTCBookDelegate>delegate;


#pragma mark - Factory inits
+(instancetype) bookWithDictionary:(NSDictionary *) dict
                             stack:(AGTCoreDataStack *) stack;

+(instancetype) bookWithArchivedURIRepresentation:(NSData *) archivedURI
                                            stack:(AGTCoreDataStack *) stack;


#pragma mark - Instance methods

-(NSString *) sortedListOfAuthors;
-(NSString *) sortedListOfTags;
-(NSData *) archiveURIRepresentation;

-(BOOL) hasFavoriteTag;
-(void) insertFavoriteTag;
-(void) removeFavoriteTag;
-(void) notifyChanges;


@end
