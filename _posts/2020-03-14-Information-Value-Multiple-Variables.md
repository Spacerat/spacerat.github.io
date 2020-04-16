---
layout: post
title: "How To Measure Anything: The Information Values for Multiple Variables"
date: 2020-03-14 12:23:37 -0700
categories: tech
tags: hide
---

The book [How To Measure Anything] (by Douglas W. Hubbard) teaches a process for quantitative decision making. I highly recommend giving it a read, but here's the overall approach it suggests:

---
<br>

1. Define and model a decision. A decision must have a measurable impact, e.g. company profits, which is modeled with a collection of variables. For example, decide to sell a product if $$ \textrm{Unit Profit} * \textrm{Buyers} - \textrm{Fixed cost} > 0$$

2. Estimate distributions for each variable using existing knowledge. Ideally, this should be done by experts in the area who have undergone [calibration training]

3. Compute the value of obtaining more accurate estimates for each variable.

4. Reduce uncertainty by measuring the highest-value variables, or by decomposing them into finer grained estimates.

5. Make a decision once uncertainty has been sufficiently reduced.

---
<br>
I believe the cornerstone of this approach is step 3, but how exactly do you compute the value of measuring a variable?

The book describes the theory in detail, with some nice examples... for a model with a single variable. It then acknowledges that most models will consist of many variables, and dedicates a mere _two short paragraphs_ to the multi-variate case!

This blog post fills in the gap with a working example. I define a model, then compute the value of obtaining perfect information for each of its variables using the more accurate method suggested by the book.


## The advertising campaign

The model we'll use is similar to the simple model used in Chapter 6, but with a second variable included.

There is a proposal for an ad campaign which will will cost \$5m to run. If the campaign is rejected, no money will be made or spent. If the campaign is accepted, it will run in two market segments, and may succeed or fail in each segment independently.

In this unrealistic example, we know exactly how much we'll make if we succeed, but our experts have estimated the chance of success in each segment.

|           | Chance of success | Revenue if successful | Revenue if unsuccessful |
|-----------|-------------------|-----------------------|-------------------------|
| Segment A | 60%               | $45m                  | $0                      |
| Segment B | 70%               | $6m                   | $0                      |

We could run surveys to improve our confidence in the outcomes, but which market segment should we do that for, and how much should we spend?

Intuition should rightly tell you that A is worth more to measure than B, but the hope is that if we can demonstrate Hubbard's technique on this simple example, you can generalize it to situations where the outcome is less clear.

## The value of perfect information

The method starts by computing what it calls the "Overall Expected Opportunity Loss" for the model. Here's the quote from Chapter 6, page 164 of the Third Edition:

> Another more elaborate -- but more accurate -- method starts by running a simulation that shows our expected loss at our current level of uncertainty. I call this the Overall EOL or the Decision EOL. This is simply the average of all outcomes given our current (default) decision assuming we don't measure any further. [...] All of these results averaged together -- zeros and non-zero values alike -- is the Overall EOL.

Opportunity Loss (OL) is defined as the cost of a bad decision, which could be as much as $5m for this campaign if it completely fails. Expected Opportunity Loss (EOL) is the cost of a bad decision multiplied by its probability.

If the campaign is run, we risk losing money if we don't make as much as the $5m we paid for it.

| A result   | B result   | Profit | Probability | Opportunity Loss<br>(loss if campaign is accepted)
|------------|------------|--------|-------------|------------------
| A succeeds | B succeeds | $46m   | 42%         | $0
| A succeeds | B fails    | $40m   | 18%         | $0 
| A fails    | B succeeds |  $1m   | 28%         | $0
| A fails    | B fails    | -$5m   | 12%         | $5m


$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& \sum_{\textrm{all scenarios}}{\textrm{Opportunity Loss} * \textrm{Probability}} \\
                         &=& $5m * 12\% \\
                         &=& $600k
\end{eqnarray}$$

Ignoring how much we stand to _make_, running this campaign involves a 12% risk of a $5m loss, so the expected loss is $600k.

We can make a similar calculation for the case where the campaign is not run. Here, the risk is that we lose out out on everything we would have made.[^eolname]


| A result   | B result   | Profit | Probability | Opportunity Loss<br>(loss if campaign is rejected)
|------------|------------|--------|-------------|------------------
| A succeeds | B succeeds | $0     | 42%         | $46m
| A succeeds | B fails    | $0     | 18%         | $40m
| A fails    | B succeeds | $0     | 28%         | $1m
| A fails    | B fails    | $0     | 12%         | $0

$$\begin{eqnarray}
\textrm{EOL if Rejected} &=& \sum_{\textrm{all scenarios}}{\textrm{Opportunity Loss} * \textrm{Probability}} \\
                         &=& $46m * 42\% \\ &+&  $40m * 18\% \\ &+&  $1m * 28\% \\
                         &=& $26.8m
\end{eqnarray}$$

Based on what we know, should we decide to run the campaign? That depends on our risk tolerance - if we don't have $5m to lose, we might be more sensitive to actual losses than missed profits.

However, let's keep things simple and say that we'll take whichever option has the lowest risk. This policy is our **decision rule**. It results in a "default" decision to run the campaign, and means that our Overall EOL is currently $600k.

Just to be safe, should we spend a bit on a survey to refine our estimate of the chance of failure?

Let's imagine we can buy *perfect information*. We'd definitely do it for $1, and definitely not for $100m, so what's the maximum we should pay? The theory goes that given our current level of uncertainty, we would pay up to $600k to confirm that the campaign won't fail. Despite the fact that we might lose up to $5m, any more than $600k and we're paying more than our expected loss.

Conversely, if our default option was to reject the campaign, we're throwing away an 'expected' $26.8m, so it would probably be worth spending a lot more to make sure we're not missing out. However, if we pay more than $26.8m, we're paying more than we expect to gain.

This is what the book calls the Expected Value of Perfect Information (EVPI), and as you can see, the value of information partly depends on the action you'd take without it. We've calculated it for the entire model, but what if we can get perfect information for just one variable?

## The actual value of information for a single variable

> We then run a series of Monte Carlo Simulations where we pretend we knew one selected variable in the model exactly.

Let's imagine that we get some new information, and now we're 100% confident the campaign will fail in segment A.

| A result   | B result   | Profit | Probability | Opportunity Loss (Accepted) | Opportunity Loss (Rejected) |
|------------|------------|--------|-------------|-----------------------------|-----------------------------|
| A succeeds | B succeeds | $46m   | 0%          | $0                          | $46m                        |
| A succeeds | B fails    | $40m   | 0%          | $0                          | $40m                        |
| A fails    | B succeeds |  $1m   | **70%**     | **$0**                      | **$1m**                      |
| A fails    | B fails    | -$5m   | **30%**     | **$5m**                     | **$0**                      |

$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& $5m &*& 30\% &=& $1.5m \\
\textrm{EOL if Rejected} &=& $1m &*& 70\% &=& $700k
\end{eqnarray}$$

Note that we computed these numbers analytically, but 100 random simulations (i.e. Monte Carlo) would have produced roughly the same results.

> We apply a decision rule that tells the model what I would have done differently if I knew only that variable exactly. If knowing this variable was informative, my opportunity losses from making a bad decision (the Overall EOL) should go down.

**This is the part of the book I've been having trouble interpreting.** The new information was clearly informative, since my decision rule now tells me to reject the proposal. However, the expected opportunity loss of my decision has gone _up_ from $600k to $700k! So what was the value of this information?

1. Was it $0, since my expected losses didn't decrease?
2. Was it $100k, the absolute difference between Overall EOL before and after?
3. Was it $900k, since the expected loss of my previous decision turned out to be $900k larger than I thought?
4. Or was it $800k, since the new information updates the EOL for my previous decision to $1.5m and then updates my decision to reduce my EOL to $700k?

I argue the the answer is (4), and I'm going to back that up with some extreme examples.

- If I had somehow learned that running the campaign risked a billion dollars, with a $50m potential upside, that information would clearly have immense value. I was going to run that campaign before! If I had paid a $100m dollars to avoid an expected billion dollar loss, that would have been very much worth it.
- However, if I'd have learned that the campaign stands to make OR lose one one billion dollars -- and I value actual loss as much as I value lost potential gains -- I would regret having spent any money on research at all. If I have 1000 opportunities to run this campaign, it won't matter whether I do or not - I'll make an average of $0. Spending money to learn that would have just cost me extra.

With that in mind, my interpretation if the 

Putting that aside, lets try the same thing for the case that we learn that segment A is 100% likely to succeed. Noting that this reduces the situation to a single variable, we can simplify the table a bit.

| B result   | Profit | Probability | Opportunity Loss (Accepted) | Opportunity Loss (Rejected) |
|------------|--------|-------------|-----------------------------|-----------------------------|
| B succeeds | $46m   | **70%**     | $0                          | **$46m**                    |
| B fails    | $40m   | **30%**     | $0                          | **$40m**                    |


$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& $0 \\
\textrm{EOL if Rejected} &=& $46m * 90\% + $40m * 10\% = $44.2m
\end{eqnarray}$$

Again, perfect information reduced our risk to $0, and our decision rule tells us to definitely run the campaign, because segment A's success will always cover the potential loss of segment B. Overall, it looks like the expected value of perfect information on segment A is $600k.

Now let's consider perfect information about segment B. Suppose we learn that it will fail.

| A result   | Profit | Probability | Opportunity Loss (Accepted) | Opportunity Loss (Rejected) |
|------------|--------|-------------|-----------------------------|-----------------------------|
| A succeeds | $40m   | **60%**     | $0                          | **$40m**                    |
| A fails    | -$5m   | **40%**     | **$5m**                     | $0                          |

$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& $5m &*& 40\% &=& $2m \\
\textrm{EOL if Rejected} &=& $40m &*& 60\% &=& $24m
\end{eqnarray}$$

The campaign looks $720,000 more risky, but that doesn't change our decision to run it.

What if we learn that it succeeds?

| A result   | Profit | Probability | Opportunity Loss (Accepted) | Opportunity Loss (Rejected) |
|------------|--------|-------------|-----------------------------|-----------------------------|
| A succeeds | $46m   | **60%**     | $0                          | **$46m**                    |
| A fails    |  $1m   | **40%**     | $0                          | $0                          |

$$\begin{eqnarray}
\textrm{EOL if Accepted} &=& $0 \\
\textrm{EOL if Rejected} &=& $46m &*& 60\% &=& $27.6m
\end{eqnarray}$$

Now the Expected Opportunity Loss of our decision to run the campaign is reduced by $80,000.

> The change in Overall EOL by eliminating uncertainty for a single variable is the "Individual EVPI" for that variable. 

Here is where my interpretation of the book is fuzzy. It seems clear that we should pay up to $600k for perfect information on Segment A, but since information on Segment B can never change our decision, would we pay even one dollar to learn more about it?

## Knowing what to measure

**WIP**

- this was a simple example
- it still demonstrates that P(success of B) is the most valuable estimate to refine
- when a model consists of a sum of variables, the variable with the widest range is always going to be the most informative
- but in more complex models:
    - it won't always be a sum of variables
    - it may be that no single variable is informative

## Decision rules, loss functions

**WIP**

- "Decision rule" selects from decisions based on their EOL
- Could just take the decision with the lowest EOL, but not always
- You might be more sensitive to actual loss than to lost potential gain.
- e.g. might have a cap on maximum actual loss (a budget), but not a cap on lost potential gain.

## Realistic decisions

**WIP**

- Application to ranges of variables and decisions would follow the same principle
    - Hold a variable (or group of variables) at a single value
    - Simulate the others & compute EOLs of resulting decisions.
    - Compute EOL for 


## Interlude: does any of this actually make sense?

**WIP - worth including?**

### Linear loss versus maximum loss

The concept of paying **[WIP finish this sentence]**, and ultimately it's a pretty simple model of risk. Perhaps we think that we should spend up to $5m because there's *some chance* we could lose that much. That would be the **Maximum** Opportunity Loss, and perhaps it sounds like a good idea, but it falls apart for slimmer probabilities. For example, if we introduce a 0.001% chance of a massive PR disaster which costs $500m in lost sales, should we spend $500m to test the advertisement for PR issues? Probably not! The linear model (for this single variable) suggests $5,000 which seems much more reasonable.

[^eolname]: When you realize that loss can including *losing out*, I think that it makes the name Expected **Opportunity** Loss more clear.

### Uncalibrated estimates

**TODO** something about how the model falls apart if you begin with uncalibrated estimates.

[How To Measure Anything]: https://www.howtomeasureanything.com/3rd-edition/
[calibration training]: https://en.wikipedia.org/wiki/Calibrated_probability_assessment











######################## TODO ####################

Simulate two agents making a decision

D = p1 * a + p2 * b > c

Agent 1 always chooses the same thing.

Agent 2 learns the true value of p1 or p2, then chooses appropriately