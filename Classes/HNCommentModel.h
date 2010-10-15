@class HNComment, HNStory;

@interface HNCommentModel : TTURLRequestModel  {

	HNStory* headerStory;
	
	NSMutableArray* comments;
	NSString* story_id;
	/*		
@private
	
	BOOL _isLoading;
	BOOL _isLoaded;
	 */
}

@property(nonatomic,retain) HNStory* headerStory;
@property(nonatomic,retain) NSMutableArray* comments;
@property(nonatomic,retain) NSString *story_id;

@end
