#import <Foundation/Foundation.h>
#import <libxml/tree.h>


@class QBDDXMLDocument;


enum {
	DDXMLInvalidKind                = 0,
	DDXMLDocumentKind               = XML_DOCUMENT_NODE,
	DDXMLElementKind                = XML_ELEMENT_NODE,
	DDXMLAttributeKind              = XML_ATTRIBUTE_NODE,
	DDXMLNamespaceKind              = XML_NAMESPACE_DECL,
	DDXMLProcessingInstructionKind  = XML_PI_NODE,
	DDXMLCommentKind                = XML_COMMENT_NODE,
	DDXMLTextKind                   = XML_TEXT_NODE,
	DDXMLDTDKind                    = XML_DTD_NODE,
	DDXMLEntityDeclarationKind      = XML_ENTITY_DECL,
	DDXMLAttributeDeclarationKind   = XML_ATTRIBUTE_DECL,
	DDXMLElementDeclarationKind     = XML_ELEMENT_DECL,
	DDXMLNotationDeclarationKind    = XML_NOTATION_NODE
};
typedef NSUInteger QBDDXMLNodeKind;

enum {
	DDXMLNodeOptionsNone            = 0,
	DDXMLNodeExpandEmptyElement     = 1 << 1,
	DDXMLNodeCompactEmptyElement    = 1 << 2,
	DDXMLNodePrettyPrint            = 1 << 17,
};


//extern struct _xmlKind;


@interface QBDDXMLNode : NSObject <NSCopying>
{
	// Every DDXML object is simply a wrapper around an underlying libxml node
	struct _xmlKind *genericPtr;
	
	// Every libxml node resides somewhere within an xml tree heirarchy.
	// We cannot free the tree heirarchy until all referencing nodes have been released.
	// So all nodes retain a reference to the node that created them,
	// and when the last reference is released the tree gets freed.
	QBDDXMLNode *owner;
}

//- (id)initWithKind:(DDXMLNodeKind)kind;

//- (id)initWithKind:(DDXMLNodeKind)kind options:(NSUInteger)options;

//+ (id)document;

//+ (id)documentWithRootElement:(QBDDXMLElement *)element;

+ (id)elementWithName:(NSString *)name;

+ (id)elementWithName:(NSString *)name URI:(NSString *)URI;

+ (id)elementWithName:(NSString *)name stringValue:(NSString *)string;

+ (id)elementWithName:(NSString *)name children:(NSArray *)children attributes:(NSArray *)attributes;

+ (id)attributeWithName:(NSString *)name stringValue:(NSString *)stringValue;

+ (id)attributeWithName:(NSString *)name URI:(NSString *)URI stringValue:(NSString *)stringValue;

+ (id)namespaceWithName:(NSString *)name stringValue:(NSString *)stringValue;

+ (id)processingInstructionWithName:(NSString *)name stringValue:(NSString *)stringValue;

+ (id)commentWithStringValue:(NSString *)stringValue;

+ (id)textWithStringValue:(NSString *)stringValue;

//+ (id)DTDNodeWithXMLString:(NSString *)string;

#pragma mark --- Properties ---

- (QBDDXMLNodeKind)kind;

- (void)setName:(NSString *)name;
- (NSString *)name;

//- (void)setObjectValue:(id)value;
//- (id)objectValue;

- (void)setStringValue:(NSString *)string;
//- (void)setStringValue:(NSString *)string resolvingEntities:(BOOL)resolve;
- (NSString *)stringValue;

#pragma mark --- Tree Navigation ---

- (NSUInteger)index;

- (NSUInteger)level;

- (QBDDXMLDocument *)rootDocument;

- (QBDDXMLNode *)parent;
- (NSUInteger)childCount;
- (NSArray *)children;
- (QBDDXMLNode *)childAtIndex:(NSUInteger)index;

- (QBDDXMLNode *)previousSibling;
- (QBDDXMLNode *)nextSibling;

- (QBDDXMLNode *)previousNode;
- (QBDDXMLNode *)nextNode;

- (void)detach;

- (NSString *)XPath;

#pragma mark --- QNames ---

- (NSString *)localName;
- (NSString *)prefix;

- (void)setURI:(NSString *)URI;
- (NSString *)URI;

+ (NSString *)localNameForName:(NSString *)name;
+ (NSString *)prefixForName:(NSString *)name;
//+ (QBDDXMLNode *)predefinedNamespaceForPrefix:(NSString *)name;

#pragma mark --- Output ---

- (NSString *)description;
- (NSString *)XMLString;
- (NSString *)XMLStringWithOptions:(NSUInteger)options;
//- (NSString *)canonicalXMLStringPreservingComments:(BOOL)comments;

#pragma mark --- XPath/XQuery ---

- (NSArray *)nodesForXPath:(NSString *)xpath error:(NSError **)error;
//- (NSArray *)objectsForXQuery:(NSString *)xquery constants:(NSDictionary *)constants error:(NSError **)error;
//- (NSArray *)objectsForXQuery:(NSString *)xquery error:(NSError **)error;

@end
