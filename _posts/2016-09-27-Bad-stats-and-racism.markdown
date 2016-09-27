---
layout: post
title:  "Bad statistics is a friend of racism"
date:   2016-09-27 12:23:37 -0700
categories: social
---

If there's one thing which really grinds my gears, it's abuse of statistics. Oh, and racism, that isn't too hot either.

The other day while browsing Facebook, I came across a comment posted by a friend (or acquaintance, I hope!) of a friend.

> Black people are 18.5 times more likely to kill a police officer than to be killed by a police officer when unarmed.

This is obviously rubbish and ordinarily I would probably have brushed it off as "just another internet racist!" and continued, but I was intrigued by the number 18.5. Where could that have come from? He didn't make it up himself, so who else is saying it?

Well, the commenter himself quoted an article on [The Daily Wire](http://www.dailywire.com/news/7264/5-statistics-you-need-know-about-cops-killing-aaron-bandler)

> Blacks are more likely to kill cops than be killed by cops. This is according to FBI data, which also found that 40 percent of cop killers are black. According to Mac Donald, the police officer is 18.5 times more likely to be killed by a black than a cop killing an unarmed black person.

This 'Mac Donald' is Heather Mac Donald, and [here is her article](https://www.washingtonpost.com/news/volokh-conspiracy/wp/2016/07/19/academic-research-on-police-shootings-and-race/?utm_term=.8e6d4606cd01) which computes this number. So, what's going on here?

For a start, Heather was subtly misquoted. The previous descriptions make you think that we're talking about the probability that a _given black person_ will kill a cop versus get shot by one, but Heather says:

> an officer’s chance of getting killed by a black assailant is 18.5 times higher than the chance of an unarmed black getting killed by a cop.

But of course the rate of cops being killed is going to be higher than the rate of civilians being killed - being a police officer is a dangerous job, and there are only 628,000 officers versus over 19 million black males! To illustrate how absurd this statistic is, we can compute the same ratio for non-black people using Heather's numbers and methods as closely as possible.

1. The article implies that 60% of 52 officers were not killed by black assailants.
2. The Washington Post's [police shooting database](https://www.washingtonpost.com/graphics/national/police-shootings/) indicates that 54 out of 90 unarmed black men killed by police were not black.
3. The population of men who aren't black was approximately 134,921,800.

Let's plug in the numbers.

$$\frac{\textrm{rate that officers are killed by non-black people}}{\textrm{rate that non-black males are shot by the police}} = \frac{(52 \times 0.60) \div (628,000)}{54 \div 134,921,800} = 124$$

If this Facebook commenter really cared about being fair, he would quote add "and the number is 124x for everyone else"!

I could stop here, but I decided to see what would happen if I actually computed the number he described i.e. the frequency that black kill police versus get killed by them, and the answer is:

$$\frac{\textrm{black-on-blue-killings} \div \textrm{black male population}}{\textrm{rate of blue-on-black-shootings}} = \frac{20 \div 19,000,000}{0.0000018} = 0.58$$

Which implies that black 1.7 times _more_ likely to be killed by an officer than kill one, but again I'm not actually saying that since it really makes no sense to compare such tiny rates and such different population sizes.

I decided to go on with the game of creating bunk statistics using these numbers. If you like, you can show that an officer is 52x more likely to kill an unarmed black male than a black person is to kill a cop. I imagine you might hear some complaints if I ever tried to use that number.

The trend of people throwing big numbers unchecked around is a worrying one, and it's used to support everything from racism and xenophobia to anti-vaccination. Sometimes it really is difficult to spot - e.g. Andrew Wakefield's infamous and discredited autism/vaccination paper was debunked by other scientists - but I believe that most people on the internet today should have the capability to do what I just did. 

I wasn't able to reply on the Facebook thread and the Daily Wire's comments were closed too, and so I was inspired to post this instead. But if I see something so egregiously wrong again - so tantalisingly disprovable - I'm sure I won't hesitate to bring out the calculator.

The low hanging fruit is there for you to pick, it's tasty, and it'll help you fight intolerance!
