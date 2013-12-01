---
author: gigasquid
comments: true
date: 2012-04-12 04:02:09+00:00
layout: post
slug: the-software-bathtub-curve
title: The Software Bathtub Curve
wordpress_id: 385
categories:
- All
- Development
---


{% img left http://farm4.staticflickr.com/3767/9925846584_3bf93b2cca.jpg %}

I have had my Dualit Toaster for close to 19 years now. It has never broken down. It has reliably toasted my bread every morning with the mere turn of a dial.

I have had my dishwasher for 1 year and 2 weeks. It has all sorts of cool buttons and modes so that I can customize my wash cycles to suit my dishes and my mood. Precisely two weeks after the warranty expired, it began to blink randomly and stopped working. The control board had died. This was not an isolated incident. I have gone through many such failures with other appliances, my refrigerator, stove and washing machine.

Looking at my toaster and dishwasher, I made a couple of observations:



	
  1. **The more complex the product, the less reliable it is, and the shorter the life span.**


Sure, it would be cool if I could control my toaster with my mobile phone app, but just having a heating coil and a dial gives the advantage of having a lot less things that could go wrong.

	
  2. **A product is only as reliable as its least reliable part.**


You can pay a small fortune for a oven built of stainless steel with all the latest technological advances in color display and computerized air flow. But if it relies on the same computer circuit board that all the other ovens use, (the one gives out after a year), then your investment is not any more reliable.

I also noted that these observations could be translated to software as well. Certainly, in the case of building software, the more complex the system the more things that can go wrong. The same could hold true that overall software system is only as reliable as the least reliable part of it.

This brought me to the larger question.


> How can they predict the dates so accurately? My dishwasher stopped working 2 weeks after the warranty ran out.

— Carin Meier (@carinmeier) [April 11, 2012](https://twitter.com/carinmeier/status/190222737594269696)


How do the manufacturers know, with such accuracy, when the product is going to fail? Could you apply the same principles to software?


> @[carinmeier](https://twitter.com/carinmeier) believe it or not they spend millions calculating it. I spent way too many hours in 6-sigma training with bathtub curves.

— Jonathan Hays (@cheesemaker) [April 11, 2012](https://twitter.com/cheesemaker/status/190225140863348736)


[The Bathtub Curve](http://en.wikipedia.org/wiki/Bathtub_curve), according to wikipedia, is widely used in reliability engineering. It gets its name from the shape of the curve, which looks a bit like a bathtub. It is talked about in three sections:



	
  1. Decreasing failure rate (early failures)

	
  2. Constant failure rate (random failures)

	
  3. Increasing failure rate (wear-out failures)





With software, we don't talk about failures so much. We do talk about bugs, but even that is a bit misleading because it doesn't take into account the need to accommodate features and evolving changes. So let's talk about “issues” instead that can be broad enough to accommodate traditional bugs, gaps of functional needs, and performance related items.

The Software Bathtub Curve might look like the following:



**Decreasing issue rate (launch & growing pains)**

This is the early stage of the software. After its initial launch, gaps in functionality, bugs, and performance issues are readily identified and corrected. The main factors of reliability here are communication, responsiveness and agility.

Sample questions for determining data for this part of the curve:



	
  1. Do you use a dynamic language/ framework that allows rapid development? +10

	
  2. If the product owner and developers were in the same restaurant would they recognize each other? + 10

	
  3. Can the product owner and developers recognize each other by voice? +5

	
  4. Do you have a daily standup? + 5

	
  5. Do you really stand up the whole time? +2

	
  6. How many outside integration points are there? -5 for each

	
  7. How many programming languages and frameworks are there? -5 for each

	
  8. Do you release often? +5 for every 2 weeks (-1 for each week longer)

	
  9. Do you work over 40 hours a week regularly? -10

	
  10. Do you have an automated test suite? + 10

	
  11. Does it have regularly have untended errors in it? -5

	
  12. Do you use pair programming or code reviews? +10




**Constant failure rate (random failures)**

****This is the time when the software reaches maturity. The business needs do not change drastically, but require minor refinements. Random issues occur from 3rd party integration issues or real world data issues. Major factors for reliability in this phase are avoidance of technical debt, data curation, and code quality.



	
  1. Has the team scaled down to just include a minimal or junior support staff? -10

	
  2. Do new features/ fixes get put in with the appropriate refactoring and tests? + 10

	
  3. Do new features/fixes more often just get stuck in there in the easiest way possible? -5

	
  4. Do your tests still all pass +10

	
  5. Do you get advance warning when a 3rd party api is changing? + 10

	
  6. Do you test that change in advance? + 5

	
  7. Do you still talk to the product owners? +5

	
  8. Do you care about code / data quality? + 10




**Increasing failure rate (Failure to adapt to new business needs)**

This is the final phase in the software life cycle. The new business needs cannot be met with the exsiting software and the cost of changing or adapting it is too high or not possible. Major factors for reliability and length of life span include openness and complexity of design and architecture.



	
  1. Do you have have to pay for a closed vendor product? -10

	
  2. Do you use open source languages and libraries? + 10

	
  3. Are you afraid to change anything because it might break? -10

	
  4. Is your main software language more than 1 version behind the latest? -5 for each version behind

	
  5. Does the mention of new features install fear instead of passion? -500




In the end, although it is interesting to compare software to the appliance Bathtub Curve, it is a leaky abstraction at best (sorry, couldn't resist). Software is living thing. It needs to respond to its ever changing environment and needs. Furthermore, it is made up of a collection of living people who care and tend for it as well. However, there are clear factors that can go a long way to increasing the reliability, usability, and lifespan of software as well. We, as software developers, should keep them in mind as part of the ultimate goal of creating living, quality software.


