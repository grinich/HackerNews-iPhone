# HackerNews for iPhone

This is an iPhone app I built in 2009-2010 to read HN in a nice mobile friendly way. It was the first large application I'd shipped and got several thousand downloads from the App Store with zero marketing. HackerNews didn't have an API, so the entire data layer was powered by web scraping under the hood, including login via cookies. You can see some screenshots [here](http://michaelgrinich.com/hackernews/)/

It's no longer on the store and I have no plans to update/maintain it going forward, but figured I would open source it for fun. Consider any code I wrote here under a MIT License. :) 


### Current Bugs: 

- 	[TTPostController showActivity:@"Posting comment"]; 
	This is not exposed for some reason. Subclasses need it.
-	Doesn't show blue background on selection on Story view

-	Story page parser broken for brand new accounts.
-	numberFromString is sometimes broken


### To Do:

- Switch green hilighting to the orange asterisk in upper right corner
- InstaPaper login screen
- "About the developer" page with a link to email about bugs


/////////////////
   2.0 Update
/////////////////

New Features:

- Log-in
- Voting
- Post comments
- Refresh items on homepage
- Readbility


Bug fixes: 
- Fixed-width text now displays correctly.
- Refresh items on homepage


/////////////////
   To Do
/////////////////

- Mail link to page
- In app settings. Perhaps this -> http://www.inappsettingskit.com/ 
- Searching via searchyc.com
- Bookmarlet installation for submitting articles
	http://ycombinator.com/bookmarklet.html

	Twitteriffic example:  http://furbo.org/2008/10/01/redacted/
	
	Installation screens:
	http://joemaller.com/___
	http://mekentosj.com/papers/___
	http://iconfactory.com/___?javascript:window.location='twitterrific:///post?message='+escape(window.location)
	
- Polls
- Editing/deleting posts
- More pages (/noobs, /newest, /newcomments, etc)
- Comment formatting for posting comments 
	see: http://news.ycombinator.com/formatdoc 
- HN Guidelines at first launch. http://ycombinator.com/newsguidelines.html


/////////////////
   Performance
/////////////////

- Long story http://news.ycombinator.com/item?id=692338


/////////////////
   Resources
/////////////////

- "Splash" loading view with fading stuff. 
	
	http://michael.burford.net/2008/11/fading-defaultpng-when-iphone-app.html)
	
- Singletons

	http://cocoawithlove.com/2008/11/singletons-appdelegates-and-top-level.html)
	
- Three20

- Element Parser http://github.com/Objective3/ElementParser

- Readbility http://lab.arc90.com/experiments/readability/
http://code.google.com/p/arc90labs-readability/

- JavaScript Injection http://iphoneincubator.com/blog/windows-views/how-to-inject-javascript-functions-into-a-uiwebview

