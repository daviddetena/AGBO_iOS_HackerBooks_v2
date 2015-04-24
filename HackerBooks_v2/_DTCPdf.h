// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DTCPdf.h instead.

@import CoreData;
#import "DTCHackerBooksBaseClass.h"

extern const struct DTCPdfAttributes {
	__unsafe_unretained NSString *pdfData;
} DTCPdfAttributes;

extern const struct DTCPdfRelationships {
	__unsafe_unretained NSString *book;
} DTCPdfRelationships;

@class DTCBook;

@interface DTCPdfID : NSManagedObjectID {}
@end

@interface _DTCPdf : DTCHackerBooksBaseClass {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DTCPdfID* objectID;

@property (nonatomic, strong) NSData* pdfData;

//- (BOOL)validatePdfData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DTCBook *book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;

@end

@interface _DTCPdf (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitivePdfData;
- (void)setPrimitivePdfData:(NSData*)value;

- (DTCBook*)primitiveBook;
- (void)setPrimitiveBook:(DTCBook*)value;

@end
